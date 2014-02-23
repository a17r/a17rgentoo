# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/pango/pango-1.30.1.ebuild,v 1.13 2013/04/30 14:04:19 tetromino Exp $

EAPI="5"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit autotools eutils gnome2 toolchain-funcs multilib-minimal

DESCRIPTION="Internationalized text layout and rendering library"
HOMEPAGE="http://www.pango.org/"

LICENSE="LGPL-2+ FTL"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

IUSE="X +introspection"

RDEPEND=">=dev-libs/glib-2.32.4-r3:2[${MULTILIB_USEDEP}]
	>=media-libs/fontconfig-2.10.2-r1:1.0=[${MULTILIB_USEDEP}]
	media-libs/freetype:2=[${MULTILIB_USEDEP}]
	>=x11-libs/cairo-1.7.6[X?,${MULTILIB_USEDEP}]
	X? (
		x11-libs/libXrender[${MULTILIB_USEDEP}]
		x11-libs/libX11[${MULTILIB_USEDEP}]
		>=x11-libs/libXft-2.0.0[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=dev-util/gtk-doc-am-1.13
	introspection? ( >=dev-libs/gobject-introspection-0.9.5[${MULTILIB_USEDEP}] )
	X? ( x11-proto/xproto[${MULTILIB_USEDEP}] )
	!<=sys-devel/autoconf-2.63:2.5"

function multilib_enabled() {
	has_multilib_profile || ( use x86 && [ "$(get_libdir)" = "lib32" ] )
}

src_prepare() {
	tc-export CXX
	G2CONF="${G2CONF}
		$(use_enable introspection)
		$(use_with X x)
		$(use X && echo --x-includes="${EPREFIX}"/usr/include)
		$(use X && echo --x-libraries="${EPREFIX}"/usr/$(get_libdir))"
	DOCS="AUTHORS ChangeLog* NEWS README THANKS"

	# In next release
	epatch "${FILESDIR}/${P}-coretext-hash.patch"

	# missing declaration causing QA abort on x64-macos, should be in next
	# release
	epatch "${FILESDIR}"/${P}-config_get_key_system-declaration.patch

	# make config file location host specific so that a 32bit and 64bit pango
	# wont fight with each other on a multilib system.  Fix building for
	# emul-linux-x86-gtklibs
	if multilib_enabled ; then
		epatch "${FILESDIR}/${PN}-1.26.0-lib64.patch"
		epatch "${FILESDIR}/${P}-AM_CONFIG_HEADER.patch" # fixed in 1.34
		eautoreconf
	fi

	gnome2_src_prepare

	multilib_copy_sources
}

pkg_postinst() {
	einfo "Generating modules listing..."

	local PANGO_CONFDIR="${EROOT}/etc/pango"
	multilib_enabled && PANGO_CONFDIR+="/${CHOST}"

	mkdir -p "${PANGO_CONFDIR}"
	local pango_conf="${PANGO_CONFDIR}/pango.modules"
	local tmp_file=$(mktemp -t tmp_pango_ebuild.XXXXXXXXXX)

	# be atomic!
	if pango-querymodules --system \
		"${EROOT}"usr/$(get_libdir)/pango/1.6.0/modules/*$(get_modname) \
			> "${tmp_file}"; then
		cat "${tmp_file}" > "${pango_conf}" || {
			rm "${tmp_file}"; die; }
	else
		ewarn "Cannot update pango.modules, file generation failed"
	fi
	rm "${tmp_file}"

	if [[ ${REPLACING_VERSIONS} < 1.30.1 ]]; then
		elog "In >=${PN}-1.30.1, default configuration file locations moved from"
		elog "~/.pangorc and ~/.pangox_aliases to ~/.config/pango/pangorc and"
		elog "~/.config/pango/pangox.aliases"
	fi
}
