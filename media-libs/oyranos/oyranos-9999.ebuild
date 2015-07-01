# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils flag-o-matic cmake-utils cmake-multilib

DESCRIPTION="Colour management system allowing to share various settings across applications and services"
HOMEPAGE="http://www.oyranos.org/"
if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/${PN}-cms/${PN}.git"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/oyranos-cms/oyranos/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="BSD"
SLOT="0"
IUSE="X cairo cups doc exif fltk jpeg qt4 qt5 raw test tiff"

#OY_LINGUAS="cs;de;eo;eu;fr;ru" #TODO

RDEPEND="
	|| (
		=app-admin/elektra-0.7*:0[${MULTILIB_USEDEP}]
		>=app-admin/elektra-0.8.4:0[${MULTILIB_USEDEP}]
	)
	>=dev-libs/libxml2-2.9.1-r4[${MULTILIB_USEDEP}]
	>=dev-libs/yajl-2.0.4-r1[${MULTILIB_USEDEP}]
	media-libs/icc-profiles-basiccolor-printing2009
	media-libs/icc-profiles-openicc
	>=media-libs/lcms-2.5:2[${MULTILIB_USEDEP}]
	>=media-libs/libpng-1.6.10:0[${MULTILIB_USEDEP}]
	>=media-libs/libXcm-0.5.3[${MULTILIB_USEDEP}]
	cairo? ( >=x11-libs/cairo-1.12.14-r4[${MULTILIB_USEDEP}] )
	cups? ( >=net-print/cups-1.7.1-r1[${MULTILIB_USEDEP}] )
	exif? ( >=media-gfx/exiv2-0.23-r2[${MULTILIB_USEDEP}] )
	fltk? ( x11-libs/fltk:1 )
	jpeg? ( virtual/jpeg:0[${MULTILIB_USEDEP}] )
	qt5? (
		dev-qt/qtwidgets:5 dev-qt/qtx11extras:5
	)
	!qt5? (
		qt4? ( dev-qt/qtcore:4 dev-qt/qtgui:4 )
	)
	raw? ( >=media-libs/libraw-0.15.4[${MULTILIB_USEDEP}] )
	tiff? ( media-libs/tiff:0[${MULTILIB_USEDEP}] )
	X? ( >=x11-libs/libXfixes-5.0.1[${MULTILIB_USEDEP}]
		>=x11-libs/libXrandr-1.4.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXxf86vm-1.1.3[${MULTILIB_USEDEP}]
		>=x11-libs/libXinerama-1.1.3[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	doc? (
		app-doc/doxygen
		media-gfx/graphviz
	)"

DOCS=( "AUTHORS.md" "ChangeLog.md" "README.md" )
RESTRICT="test"

MULTILIB_CHOST_TOOLS=(
	/usr/bin/oyranos-config
)
MULTILIB_WRAPPED_HEADERS=(
	/usr/include/oyranos/oyranos_version.h
)

CMAKE_REMOVE_MODULES_LIST="${CMAKE_REMOVE_MODULES_LIST} FindFltk FindXcm FindCUPS"

src_prepare() {
	einfo remove bundled libs
	rm -rf elektra* yajl || die

	if use fltk ; then
		#src/examples does not include fltk flags
		append-cflags $(fltk-config --cflags)
		append-cxxflags $(fltk-config --cxxflags)
	fi

	cmake-utils_src_prepare
}

multilib_src_configure() {
	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DLIB_SUFFIX=${libdir#lib}
		-DUSE_SYSTEM_ELEKTRA=YES
		-DUSE_SYSTEM_YAJL=YES
		$(cmake-utils_use_find_package cairo)
		$(cmake-utils_use_find_package cups)
		$(cmake-utils_use_find_package doc Doxygen)
		$(cmake-utils_use_find_package exif Exif2)
		$(cmake-utils_use_find_package jpeg)
		$(cmake-utils_use_find_package raw LibRaw)
		$(cmake-utils_use_find_package tiff)
		$(cmake-utils_use_find_package X X11)
	)

	# prefer Qt5
	if ! use qt5 ; then
		use qt4 && mycmakeargs+=( $(cmake-utils_use_use qt4) )
	fi

	# only used in programs
	if ! multilib_is_native_abi ; then
		mycmakeargs+=(
			"CMAKE_DISABLE_FIND_PACKAGE_Fltk=ON"
			"CMAKE_DISABLE_FIND_PACKAGE_Qt4=ON"
			"CMAKE_DISABLE_FIND_PACKAGE_Qt5=ON"
		)
	else
		mycmakeargs+=(
			$(cmake-utils_use_find_package fltk)
			$(cmake-utils_use_find_package qt4)
			$(cmake-utils_use_find_package qt5)
		)
	fi

	cmake-utils_src_configure
}
