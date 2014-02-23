# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/oyranos/oyranos-0.9.4-r1.ebuild,v 1.5 2013/08/15 03:38:17 patrick Exp $

EAPI=5

inherit eutils flag-o-matic cmake-utils cmake-multilib

DESCRIPTION="colour management system allowing to share various settings across applications and services"
HOMEPAGE="http://www.oyranos.org/"
if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://www.${PN}.org/git/${PN}"
	inherit git-2
else
	SRC_URI="mirror://sourceforge/oyranos/Oyranos/Oyranos%200.4/${P}.tar.bz2"
fi

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="X cairo cups doc exif fltk qt4 raw test"

RDEPEND=">=app-admin/elektra-0.7[${MULTILIB_USEDEP}]
	dev-libs/libxml2[${MULTILIB_USEDEP}]
	dev-libs/yajl[${MULTILIB_USEDEP}]
	media-gfx/graphviz
	media-libs/icc-profiles-basiccolor-printing2009
	media-libs/icc-profiles-openicc
	media-libs/lcms[${MULTILIB_USEDEP}]
	media-libs/libpng:0[${MULTILIB_USEDEP}]
	>=media-libs/libXcm-0.5.2[${MULTILIB_USEDEP}]
	X? ( x11-libs/libXfixes[${MULTILIB_USEDEP}]
		x11-libs/libXrandr[${MULTILIB_USEDEP}]
		x11-libs/libXxf86vm[${MULTILIB_USEDEP}]
		x11-libs/libXinerama[${MULTILIB_USEDEP}] )
	!amd64? (
		cairo? ( x11-libs/cairo )
		cups? ( net-print/cups )
		qt4? ( dev-qt/qtcore:4 dev-qt/qtgui:4 )
		)
	amd64? (
		abi_x86_64? (
			cairo? ( x11-libs/cairo )
			cups? ( net-print/cups )
			qt4? ( dev-qt/qtcore:4 dev-qt/qtgui:4 )
		)
		abi_x86_32? (
			cairo? ( app-emulation/emul-linux-x86-gtklibs )
			cups? ( app-emulation/emul-linux-x86-baselibs )
			qt4? ( app-emulation/emul-linux-x86-qtlibs )
		)
	)
	exif? ( media-gfx/exiv2[${MULTILIB_USEDEP}] )
	fltk? ( x11-libs/fltk:1 )
	raw? ( media-libs/libraw[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	app-doc/doxygen"

RESTRICT="test"
CMAKE_REMOVE_MODULES_LIST="${CMAKE_REMOVE_MODULES_LIST} FindFltk FindXcm FindCUPS"

src_prepare() {
	einfo remove bundled libs
	rm -rf elektra* yajl || die

	epatch "${FILESDIR}/${PN}"-9999-buildsystem.patch

	if use fltk ; then
		#src/examples does not include fltk flags
		append-cflags $(fltk-config --cflags)
		append-cxxflags $(fltk-confiag --cxxflags)
	fi

	cmake-utils_src_prepare

	mycmakeargs=(
		$(usex X -DWANT_X11=1 "")
		$(usex cairo -DWANT_CAIRO=1 "")
		$(usex cups -DWANT_CUPS=1 "")
		$(usex exif -DWANT_EXIV2=1 "")
		$(usex fltk -DWANT_FLTK=1 "")
		$(usex qt4 -DWANT_QT4=1 "")
		$(usex raw -DWANT_LIBRAW=1 "")
	)
}

src_configure() {
	cmake-multilib_src_configure

	if use abi_x86_32 && use abi_x86_64 ; then
		sed -e 's:lib64:lib32:g' \
			-i "${S}"-x86/CMakeCache.txt || die
	fi
}

src_install() {
	if use abi_x86_32 && use abi_x86_64 ; then
		sed -e '/OY_LIBDIR/s:lib32:lib64:'\
			-i "${S}"-x86/src/include/oyranos_version.h || die
	fi

	cmake-multilib_src_install

	dodoc AUTHORS ChangeLog README
	if use doc ; then
		mv "${ED}/usr/share/doc/${PN}/*" "${ED}/usr/share/doc/${P}" || die
	fi
	rm -rf "${ED}/usr/share/doc/${PN}" || die
}
