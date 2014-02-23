# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/harfbuzz/harfbuzz-0.9.23.ebuild,v 1.7 2014/01/20 19:21:18 vapier Exp $

EAPI=5

EGIT_REPO_URI="git://anongit.freedesktop.org/harfbuzz"
[[ ${PV} == 9999 ]] && inherit git-2 autotools

inherit eutils libtool autotools multilib-minimal

DESCRIPTION="An OpenType text shaping engine"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/HarfBuzz"
[[ ${PV} == 9999 ]] || SRC_URI="http://www.freedesktop.org/software/${PN}/release/${P}.tar.bz2"

LICENSE="Old-MIT ISC icu"
SLOT="0/0.9.18" # 0.9.18 introduced the harfbuzz-icu split; bug #472416
[[ ${PV} == 9999 ]] || \
KEYWORDS="~alpha amd64 ~arm hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~x64-macos ~x86-macos ~x64-solaris"
# TODO: +introspection when it's closer to finished and useful (0.9.21 hopefully)
IUSE="+cairo +glib +graphite icu introspection static-libs +truetype"
REQUIRED_USE="introspection? ( glib )"

RDEPEND="
	cairo? ( x11-libs/cairo:=[${MULTILIB_USEDEP}] )
	glib? ( dev-libs/glib:2[${MULTILIB_USEDEP}] )
	graphite? ( media-gfx/graphite2:=[${MULTILIB_USEDEP}] )
	icu? ( dev-libs/icu:=[${MULTILIB_USEDEP}] )
	introspection? ( >=dev-libs/gobject-introspection-1.32[${MULTILIB_USEDEP}] )
	truetype? ( media-libs/freetype:2=[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	virtual/pkgconfig
"
# eautoreconf requires gobject-introspection-common
# ragel needed if regenerating *.hh files from *.rl
[[ ${PV} = 9999 ]] && DEPEND="${DEPEND}
	>=dev-libs/gobject-introspection-common-1.32
	dev-util/ragel
"

src_prepare() {
	if [[ ${CHOST} == *-darwin* || ${CHOST} == *-solaris* ]] ; then
		# on Darwin/Solaris we need to link with g++, like automake defaults
		# to, but overridden by upstream because on Linux this is not
		# necessary, bug #449126
		sed -i \
			-e 's/\<LINK\>/CXXLINK/' \
			src/Makefile.am || die
		sed -i \
			-e '/libharfbuzz_la_LINK = /s/\<LINK\>/CXXLINK/' \
			src/Makefile.in || die
		sed -i \
			-e '/AM_V_CCLD/s/\<LINK\>/CXXLINK/' \
			test/api/Makefile.in || die
	fi

	[[ ${PV} == 9999 ]] && eautoreconf
	elibtoolize # for Solaris
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" \
	econf \
		--without-coretext \
		--without-uniscribe \
		$(use_enable static-libs static) \
		$(multilib_is_native_abi \
			&& use_with cairo \
			|| echo --without-cairo) \
		$(use_with glib) \
		$(use_with glib gobject) \
		$(use_with graphite graphite2) \
		$(use_with icu) \
		$(multilib_is_native_abi \
			&& use_enable introspection \
			|| echo --disable-introspection) \
		$(use_with truetype freetype)
}

multilib_src_install_all() {
	prune_libtool_files --modules
}
