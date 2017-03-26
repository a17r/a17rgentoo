# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_HANDBOOK="optional"
KMNAME="kde-baseapps"
inherit flag-o-matic kde4-base pax-utils

DESCRIPTION="Web browser and file manager"
HOMEPAGE="
	https://www.kde.org/applications/internet/konqueror/
	https://konqueror.org/
"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+bookmarks debug +filemanager nsplugin svg"
# 4 of 4 tests fail. Last checked for 4.0.3
RESTRICT="test"

DEPEND="
	media-libs/phonon[qt4]
	filemanager? ( x11-libs/libXrender )
	nsplugin? ( x11-libs/libXt )
"
# bug #544630: evince[nsplugin] crashes konqueror
RDEPEND="${DEPEND}
	kde-apps/kfind:*
	$(add_kdeapps_dep kurifilter-plugins)
	bookmarks? ( kde-apps/keditbookmarks:* )
	filemanager? (
		$(add_kdeapps_dep kdebase-kioslaves)
		$(add_kdeapps_dep konsolepart)
		!kde-apps/dolphin:4
	)
	svg? ( $(add_kdeapps_dep svgpart) )
	!app-text/evince[nsplugin]
	!kde-apps/kfmclient:4
	!kde-apps/libkonq
	nsplugin? ( !kde-apps/nsplugins )
"

PATCHES=(
	"${FILESDIR}/${PN}-16.08.0-kactivities.patch"
	"${FILESDIR}/${P}-copytomenu.patch"
)

S="${WORKDIR}/${KMNAME}-${PV}"

src_prepare() {
	[[ ${CHOST} == *-solaris* ]] && append-ldflags -lmalloc

	kde4-base_src_prepare

	cmake_comment_add_subdirectory kdepasswd
	cmake_comment_add_subdirectory kdialog
	cmake_comment_add_subdirectory keditbookmarks
	cmake_comment_add_subdirectory kfind
	cmake_comment_add_subdirectory plasma

	# Avoid doc file collisions
	echo "add_subdirectory(konqueror)" > doc/CMakeLists.txt || die
	sed -e "/man-kbookmarkmerger/d" -i doc/konqueror/CMakeLists.txt || die

	use filemanager || cmake_comment_add_subdirectory dolphin
	use nsplugin || cmake_comment_add_subdirectory nsplugins
}

src_configure() {
	local mycmakeargs

	if use filemanager ; then
		mycmakeargs=(
			-DWITH_Baloo=OFF
			-DWITH_BalooWidgets=OFF
			-DWITH_KFileMetaData=OFF
			-DCMAKE_DISABLE_FIND_PACKAGE_KActivities=ON
		)
	fi

	kde4-base_src_configure
}

src_install() {
	kde4-base_src_install

	# bug 419513
	pax-mark m "${ED}"usr/bin/nspluginviewer
}

pkg_postinst() {
	kde4-base_pkg_postinst

	if use filemanager && ! has_version media-gfx/icoutils ; then
		elog "For .exe file preview support, install media-gfx/icoutils."
	fi

	if ! has_version virtual/jre ; then
		elog "To use Java on webpages install virtual/jre."
	fi
}
