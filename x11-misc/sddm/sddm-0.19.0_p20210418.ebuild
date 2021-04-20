# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

COMMIT=4c99b784a99db8028ca438edb1f4ddb03b3b6e8c
inherit cmake linux-info pam systemd tmpfiles

DESCRIPTION="Simple Desktop Display Manager"
HOMEPAGE="https://github.com/sddm/sddm"
SRC_URI="https://github.com/${PN}/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-2+ MIT CC-BY-3.0 CC-BY-SA-3.0 public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="+elogind openrc-init +pam systemd test"

REQUIRED_USE="?? ( elogind systemd )"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	x11-base/xorg-server
	x11-libs/libXau
	x11-libs/libxcb[xkb]
	elogind? ( sys-auth/elogind )
	pam? ( sys-libs/pam )
	systemd? ( sys-apps/systemd:= )
	!systemd? ( sys-power/upower )
"
DEPEND="${COMMON_DEPEND}
	test? ( dev-qt/qttest:5 )
"
RDEPEND="${COMMON_DEPEND}
	acct-group/sddm
	acct-user/sddm
	!systemd? ( !openrc-init? ( gui-libs/display-manager-init ) )
"
BDEPEND="
	dev-python/docutils
	dev-qt/linguist-tools:5
	kde-frameworks/extra-cmake-modules:5
	virtual/pkgconfig
"

PATCHES=(
	# Pending upstream
	# fix for groups: https://github.com/sddm/sddm/issues/1159
	"${FILESDIR}"/${PN}-0.19.0-revert-honor-PAM-supplemental-groups.patch
	"${FILESDIR}"/${PN}-0.18.1-honor-PAM-supplemental-groups-v2.patch
	# ACK'd for merge but pending rebase: https://github.com/sddm/sddm/pull/1230
	"${FILESDIR}"/${P}-redesign-Xauth.patch # by openSUSE, Fedora usage for >1y
	# Downstream patches
	"${FILESDIR}"/${PN}-0.18.1-respect-user-flags.patch
	"${FILESDIR}"/${PN}-0.19.0-Xsession.patch # bug 611210
	"${FILESDIR}"/${PN}-0.19.0-pam-examples.patch
	"${FILESDIR}"/${PN}-0.19.0-no-pam_tally2.patch # PAM-1.4 woes, bug 728550
)

pkg_setup() {
	local CONFIG_CHECK="~DRM"
	use kernel_linux && linux-info_pkg_setup

	if [[ -f "${EROOT}"/etc/sddm.conf ]]; then
		cp -v "${EROOT}"/etc/sddm.conf "${T}"/sddm.conf.old || die
	fi
}

src_prepare() {
	touch "${S}"/01gentoo.conf || die

	if use elogind || use systemd; then
cat <<-EOF >> "${S}"/01gentoo.conf
[General]
# Halt/Reboot command
HaltCommand=$(usex elogind "loginctl" "systemctl") poweroff
RebootCommand=$(usex elogind "loginctl" "systemctl") reboot

EOF
	fi

cat <<-EOF >> "${S}"/01gentoo.conf
# Remove qtvirtualkeyboard as InputMethod default
InputMethod=

[Users]
ReuseSession=true

[Wayland]
EnableHiDPI=true

[X11]
EnableHiDPI=true
EOF

	cmake_src_prepare

	if ! use test; then
		sed -e "/^find_package/s/ Test//" -i CMakeLists.txt || die
		cmake_comment_add_subdirectory test
	fi
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_MAN_PAGES=ON
		-DDBUS_CONFIG_FILENAME="org.freedesktop.sddm.conf"
		-DINSTALL_PAM_EXAMPLES=OFF
		-DENABLE_PAM=$(usex pam)
		-DNO_SYSTEMD=$(usex !systemd)
		-DUSE_ELOGIND=$(usex elogind)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	newtmpfiles "${FILESDIR}/${PN}.tmpfiles" "${PN}.conf"

	insinto /etc/sddm.conf.d/
	doins "${S}"/01gentoo.conf
	[[ -f "${T}"/sddm.conf.old ]] && dodoc "${T}"/sddm.conf.old

	if use openrc-init; then
		newinitd "${FILESDIR}"/sddm.initd sddm
		newconfd "${FILESDIR}"/sddm.confd sddm
	fi

	if use pam; then
		newpamd "${FILESDIR}"/${PN}.pam ${PN} # bug 728550
		newpamd services/${PN}-autologin.pam ${PN}-autologin
		newpamd "${BUILD_DIR}"/services/${PN}-greeter.pam ${PN}-greeter
	fi
}

pkg_postinst() {
	tmpfiles_process "${PN}.conf"

	elog "NOTE: If SDDM startup appears to hang then entropy pool is too low."
	elog "This can be fixed by configuring one of the following:"
	elog "  - Enable CONFIG_RANDOM_TRUST_CPU in linux kernel"
	elog "  - # emerge sys-apps/haveged && rc-update add haveged boot"
	elog "  - # emerge sys-apps/rng-tools && rc-update add rngd boot"
	elog
	elog "SDDM example config can be shown with:"
	elog "  ${EROOT}/usr/bin/sddm --example-config"
	elog "Use ${EROOT}/etc/sddm.conf.d/ directory to override specific options."
	if [[ -f "${EROOT}"/etc/sddm.conf ]]; then
		rm "${EROOT}"/etc/sddm.conf || die
		ewarn
		ewarn "NOTE: SDDM config reset!"
		ewarn "${EROOT}/etc/sddm.conf was removed in favor of /etc/sddm.conf.d/"
		ewarn "A backup of your old config is in ${EROOT}/usr/share/doc/${PF}/"
		ewarn "It will be removed the next time ${PN} is emerged."
	fi
	elog
	elog "For more information on how to configure SDDM, please visit the wiki:"
	elog "  https://wiki.gentoo.org/wiki/SDDM"
	if has_version x11-drivers/nvidia-drivers; then
		elog
		elog "  Nvidia GPU owners in particular should pay attention"
		elog "  to the troubleshooting section."
	fi

	systemd_reenable sddm.service
}
