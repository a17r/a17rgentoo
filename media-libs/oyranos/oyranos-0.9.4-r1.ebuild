# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils flag-o-matic cmake-utils cmake-multilib

DESCRIPTION="colour management system allowing to share various settings across applications and services"
HOMEPAGE="http://www.oyranos.org/"
SRC_URI="mirror://sourceforge/oyranos/Oyranos/Oyranos%200.4/${P}.tar.bz2"
if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://www.oyranos.org/git/oyranos"
	inherit git-2
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="mirror://sourceforge/oyranos/Oyranos/Oyranos%200.4/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="BSD"
SLOT="0"
IUSE="X cairo cups doc exif fltk qt4 raw test"

RDEPEND="=app-admin/elektra-0.7*
	dev-libs/libxml2
	dev-libs/yajl
	media-gfx/exiv2
	media-libs/icc-profiles-basiccolor-printing2009
	media-libs/icc-profiles-openicc
	|| ( media-libs/lcms:0 media-libs/lcms:2 )
	media-libs/libpng:0
	media-libs/libraw
	>=media-libs/libXcm-0.5.2
	fltk? ( x11-libs/fltk:1 )
	X? ( x11-libs/libXfixes
		x11-libs/libXrandr
		x11-libs/libXxf86vm
		x11-libs/libXinerama )
	cairo? ( x11-libs/cairo )
	cups? (	net-print/cups )
	exif? ( media-gfx/exiv2 )
	qt4? ( dev-qt/qtcore:4 dev-qt/qtgui:4 )
	raw? ( media-libs/libraw )"
DEPEND="${RDEPEND}
	app-doc/doxygen
	media-gfx/graphviz"

#RESTRICT="test"

CMAKE_REMOVE_MODULES_LIST="${CMAKE_REMOVE_MODULES_LIST} FindFltk FindXcm FindCUPS"

src_prepare() {
	epatch "${FILESDIR}/${PN}"-0.9.4-buildsystem-r1.patch

	if [[ ${PV} != "9999" ]] ; then
		#upstream(ed) fixes, be more verbose, better xrandr handling
		epatch "${FILESDIR}/${P}"-fix-array-access.patch \
			"${FILESDIR}/${P}"-fix-oyRankMap-helper-functions-crashes.patch \
			"${FILESDIR}/${P}"-fix-oyStringSegment-crash.patch \
			"${FILESDIR}/${P}"-be-more-verbose.patch \
			"${FILESDIR}/${P}"-use-more-internal-xrandr-info.patch \
			"${FILESDIR}/${P}"-set-xcalib-to-screen-if-ge-xrandr-12.patch \
			"${FILESDIR}/${P}"-fix-double-object-release.patch \
			"${FILESDIR}/${P}"-omit-profile-with-error.patch \
			"${FILESDIR}/${P}"-fix-typos-and-grammar.patch

		#upstream fix for QA notice, gentoo bug 464254
		epatch "${FILESDIR}/${P}"-fix-runpaths.patch

		#fix really ugly and prominently visible typo (solved in 0.9.5)
		sed -e 's/Promt/Prompt/' \
			-i src/liboyranos_config/oyranos_texts.c po/*.{po,pot} settings/*xml || die
	fi

	if use fltk ; then
		#src/examples does not include fltk flags
		append-cflags $(fltk-config --cflags)
		append-cxxflags $(fltk-confiag --cxxflags)
	fi

	cmake-utils_src_prepare

	einfo remove bundled libs
	rm -rf elektra* yajl || die

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

src_install() {
	cmake-multilib_src_install

	dodoc AUTHORS ChangeLog README
	if use doc ; then
		mv "${ED}/usr/share/doc/${PN}/*" "${ED}/usr/share/doc/${P}" || die
	fi
	rm -rf "${ED}/usr/share/doc/${PN}" || die
}
