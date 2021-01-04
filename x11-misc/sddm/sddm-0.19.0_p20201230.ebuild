# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

COMMIT=5825c89444626755ca7ce5eef454c4888131a12b
inherit cmake linux-info pam systemd tmpfiles

DESCRIPTION="Simple Desktop Display Manager"
HOMEPAGE="https://github.com/sddm/sddm"
SRC_URI="https://github.com/${PN}/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-2+ MIT CC-BY-3.0 CC-BY-SA-3.0 public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="+elogind kernel-randomness openrc-init systemd test"

REQUIRED_USE="^^ ( elogind systemd )"
RESTRICT="!test? ( test )"

BDEPEND="
	dev-python/docutils
	dev-qt/linguist-tools:5
	kde-frameworks/extra-cmake-modules:5
	virtual/pkgconfig
"
COMMON_DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	sys-libs/pam
	x11-base/xorg-server
	x11-libs/libxcb[xkb]
	elogind? ( sys-auth/elogind )
	systemd? ( sys-apps/systemd:= )
	!systemd? ( sys-power/upower )
"
DEPEND="${COMMON_DEPEND}
	test? ( dev-qt/qttest:5 )
"
RDEPEND="${COMMON_DEPEND}
	acct-group/sddm
	acct-user/sddm
	!kernel-randomness? ( || (
		sys-apps/haveged
		sys-apps/rng-tools
	) )
"

PATCHES=(
	# Pending upstream
	# fix for groups: https://github.com/sddm/sddm/issues/1159
	"${FILESDIR}"/${PN}-0.19.0-revert-honor-PAM-supplemental-groups.patch
	"${FILESDIR}"/${PN}-0.18.1-honor-PAM-supplemental-groups-v2.patch
	# Downstream patches
	"${FILESDIR}"/${PN}-0.18.1-respect-user-flags.patch
	"${FILESDIR}"/${PN}-0.19.0-Xsession.patch # bug 611210
	"${FILESDIR}"/${PN}-0.19.0-pam-examples.patch
	"${FILESDIR}"/${PN}-0.19.0-no-pam_tally2.patch # PAM-1.4 woes, bug 728550
)

pkg_setup() {
	local CONFIG_CHECK="~DRM"
	use kernel-randomness && CONFIG_CHECK+=" ~RANDOM_TRUST_CPU"
	use kernel_linux && linux-info_pkg_setup

	if [[ -f "${EROOT}"/etc/sddm.conf ]]; then
		cp -v "${EROOT}"/etc/sddm.conf "${T}"/sddm.conf.old || die
	fi
}

src_prepare() {
	touch "${S}"/01gentoo.conf || die

cat <<-EOF >> "${S}"/01gentoo.conf
[General]
# Halt/Reboot command
HaltCommand=$(usex elogind "/bin/loginctl" "/usr/bin/systemctl") poweroff
RebootCommand=$(usex elogind "/bin/loginctl" "/usr/bin/systemctl") reboot

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
		-DENABLE_PAM=ON
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
		newinitd "${FILESDIR}"/sddm-setup.initd sddm-setup
		newinitd "${FILESDIR}"/sddm.initd sddm
		newconfd "${FILESDIR}"/sddm.confd sddm
	fi

	newpamd "${FILESDIR}"/${PN}.pam ${PN} # bug 728550
	newpamd services/${PN}-autologin.pam ${PN}-autologin
	newpamd "${BUILD_DIR}"/services/${PN}-greeter.pam ${PN}-greeter
}

pkg_postinst() {
	tmpfiles_process "${PN}.conf"

	if use kernel-randomness; then
		elog "NOTE: If SDDM startup appears to hang then entropy pool is too low."
	else
		if has_version sys-apps/haveged; then
			elog "Make sure to configure sys-apps/haveged service."
		else
			elog "Make sure to configure sys-apps/rng-tools service."
		fi
	fi
	elog
	elog "SDDM example config can be shown with:"
	elog "  ${EROOT}/usr/bin/sddm --example-config"
	elog "Use /etc/sddm.conf.d/ directory to override specific options."
	if [[ -f "${EROOT}"/etc/sddm.conf ]]; then
		rm "${EROOT}"/etc/sddm.conf || die
		ewarn "NOTE: SDDM config reset!"
		ewarn "${EROOT}/etc/sddm.conf was removed in favor of /etc/sddm.conf.d/"
		if [[ -f "${EROOT}"/usr/share/doc/${PF}/sddm.conf.old.gz ]]; then
			ewarn "A backup of your old config is in:"
			ewarn "  ${EROOT}/usr/share/doc/${PF}/sddm.conf.old.gz"
		fi
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
