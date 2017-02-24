# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools linux-info pam udev

DESCRIPTION="The systemd project's logind, extracted to a standalone package"
HOMEPAGE="https://github.com/elogind/elogind"
SRC_URI="https://github.com/elogind/elogind/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="CC0-1.0 LGPL-2.1+ public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="acl apparmor pam policykit +seccomp selinux systemd"

COMMON_DEPEND="
	sys-apps/util-linux
	sys-libs/libcap
	virtual/libudev:=
	acl? ( sys-apps/acl )
	apparmor? ( sys-libs/libapparmor )
	pam? ( virtual/pam )
	seccomp? ( sys-libs/libseccomp )
	selinux? ( sys-libs/libselinux )
"
RDEPEND="${COMMON_DEPEND}
	sys-apps/dbus
	systemd? ( sys-apps/systemd )
	!systemd? ( !sys-apps/systemd )
"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-xml-dtd:4.2
	app-text/docbook-xml-dtd:4.5
	app-text/docbook-xsl-stylesheets
	dev-util/gperf
	dev-util/intltool
	sys-devel/libtool
	virtual/pkgconfig
"
PDEPEND="policykit? ( sys-auth/polkit )"

PATCHES=(
	"${FILESDIR}/${PN}-docs.patch"
	"${FILESDIR}/${PN}-lrt.patch"
	"${FILESDIR}/${P}-session.patch"
	"${FILESDIR}/${P}-login1-perms.patch"
	"${FILESDIR}/${P}-gperf.patch"
	"${FILESDIR}/${P}-glibc.patch" # bug 605744
	"${FILESDIR}/${P}-runtime.patch"
)

pkg_setup() {
	local CONFIG_CHECK="~CGROUPS ~EPOLL ~INOTIFY_USER ~SECURITY_SMACK
		~SIGNALFD ~TIMERFD"

	use seccomp && CONFIG_CHECK+=" ~SECCOMP"

	if use kernel_linux; then
		linux-info_pkg_setup
	fi
}

src_prepare() {
	default
	eautoreconf # Makefile.am patched by "${FILESDIR}/${PN}-{docs,lrt}.patch"
}

src_configure() {
	econf \
		--with-pamlibdir=$(getpam_mod_dir) \
		--with-udevrulesdir="$(get_udevdir)"/rules.d \
		--libdir="${EPREFIX}"/$(get_libdir) \
		--enable-smack \
		$(use_enable acl) \
		$(use_enable apparmor) \
		$(use_enable pam) \
		$(use_enable seccomp) \
		$(use_enable selinux)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die

	# Build system ignores --with-rootlibdir and puts pkgconfig below
	# /$(libdir) - Move it to /usr/$(libdir)/pkgconfig
	mkdir -p "${ED%/}"/usr/$(get_libdir) || die
	mv "${ED%/}"/$(get_libdir)/pkgconfig "${ED%/}"/usr/$(get_libdir)/ || die

	newinitd "${FILESDIR}"/${PN}.init ${PN}
	newconfd "${FILESDIR}"/${PN}.conf ${PN}

	if use systemd; then
		rm -r /etc/dbus-1 || die
		rm -r /lib/udev || die
		rm /usr/bin/{loginctl,systemd-inhibit} || die
		rm -r /usr/share/{bash-completion,dbus-1,factory,man,polkit-1,zsh} || die
	else
		dosym elogind /usr/include/systemd
	fi
}

pkg_postinst() {
	if [ "$(rc-config list default | grep elogind)" = "" ]; then
		ewarn "To enable the elogind daemon, elogind must be"
		ewarn "added to the default runlevel:"
		ewarn "# rc-update add elogind default"
	fi
}
