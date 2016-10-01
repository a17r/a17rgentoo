# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_LINGUAS="ar be bg bs ca cs da de el en_GB eo es et eu fa fi fr ga gl he hi
hr hu is it ja km ko lt lv ms nb nds ne nl nn pa pl pt pt_BR ro ru se sk sl sq
sv th tr uk vi zh_CN zh_TW"
KDE_HANDBOOK="optional"
KDE_DOC_DIRS="doc-digikam doc-showfoto"
inherit kde4-base

MY_PV=${PV/_/-}
MY_P=${PN}-${MY_PV}

DESCRIPTION="Digital photo management application"
HOMEPAGE="http://www.digikam.org/"
SRC_URI="mirror://kde/stable/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2
	handbook? ( FDL-1.2 )"
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="addressbook debug doc gphoto2 +lensfun marble mysql semantic-desktop"

CDEPEND="
	$(add_kdebase_dep kdelibs)
	kde-apps/kdebase-kioslaves:4
	kde-apps/libkdcraw:4=
	kde-apps/libkexiv2:4=
	>=kde-apps/libkface-15.08.2-r1:4
	kde-apps/libkipi:4
	kde-apps/kcmshell:4
	dev-qt/qtgui:4
	|| ( dev-qt/qtsql:4[mysql] dev-qt/qtsql:4[sqlite] )
	media-libs/jasper
	media-libs/lcms:2
	media-libs/liblqr
	>=media-libs/libpgf-6.12.27
	media-libs/libpng:0=
	media-libs/opencv:=[-qt5(-),contrib(+)]
	media-libs/phonon[qt4]
	>=media-libs/tiff-3.8.2:0
	virtual/jpeg:0
	x11-libs/libX11
	addressbook? ( $(add_kdeapps_dep kdepimlibs) )
	gphoto2? ( media-libs/libgphoto2:= )
	lensfun? ( media-libs/lensfun )
	marble? ( kde-apps/libkgeomap:4= )
	mysql? ( virtual/mysql )
	semantic-desktop? ( $(add_kdebase_dep baloo) )
"
RDEPEND="${CDEPEND}
	$(add_kdeapps_dep kreadconfig)
	media-plugins/kipi-plugins:4
"
DEPEND="${CDEPEND}
	dev-cpp/eigen:3
	dev-libs/boost
	sys-devel/gettext
	doc? ( app-doc/doxygen )
"

S="${WORKDIR}/${MY_P}/core"

RESTRICT=test
# bug 366505

PATCHES=( "${FILESDIR}/${PN}-4.14.0-lensfun.patch" ) # bug 566624

src_prepare() {
	# just to make absolutely sure
	rm -rf "${WORKDIR}/${MY_P}/extra" || die

	# prepare the handbook
	mkdir doc-digikam doc-showfoto || die
	echo "add_subdirectory( en )" > doc-digikam/CMakeLists.txt || die
	mv "${WORKDIR}/${MY_P}/doc/${PN}/digikam" doc-digikam/en || die
	echo "add_subdirectory( en )" > doc-showfoto/CMakeLists.txt || die
	mv "${WORKDIR}/${MY_P}/doc/${PN}/showfoto" doc-showfoto/en || die
	sed -i -e 's:../digikam/:../../doc-digikam/en/:g' doc-showfoto/en/index.docbook || die

	# prepare the translations
	mv "${WORKDIR}/${MY_P}/po" po || die
	find po -name "*.po" -and -not -name "digikam.po" -delete || die

	echo "find_package(Msgfmt REQUIRED)" >> CMakeLists.txt || die
	echo "find_package(Gettext REQUIRED)" >> CMakeLists.txt || die
	echo "add_subdirectory( po )" >> CMakeLists.txt || die

	kde4-base_src_prepare

	if use handbook; then
		echo "add_subdirectory( doc-digikam )" >> CMakeLists.txt || die
		echo "add_subdirectory( doc-showfoto )" >> CMakeLists.txt || die
	fi
}

src_configure() {
	# LQR = only allows to choose between bundled/external
	local mycmakeargs=(
		-DENABLE_LCMS2=ON
		-DWITH_Lqr-1=ON
		-DWITH_Doxygen=$(usex doc)
		-DWITH_LensFun=$(usex lensfun)
		-DENABLE_OPENCV3=$(has_version ">=media-libs/opencv-3" && echo yes || echo no)
		-DENABLE_KDEPIMLIBSSUPPORT=$(usex addressbook)
		-DENABLE_DEBUG_MESSAGES=$(usex debug)
		-DWITH_Gphoto2=$(usex gphoto2)
		$(cmake-utils_use_find_package marble KGeoMap)
		-DENABLE_INTERNALMYSQL=$(usex mysql)
		-DENABLE_MYSQLSUPPORT=$(usex mysql)
		-DENABLE_BALOOSUPPORT=$(usex semantic-desktop)
	)

	kde4-base_src_configure
}

src_compile() {
	local mytargets="all"
	use doc && mytargets+=" doc"

	kde4-base_src_compile ${mytargets}
}

src_install() {
	kde4-base_src_install

	# install the api documentation
	use doc && dodoc -r ${CMAKE_BUILD_DIR}/api/html
}

pkg_postinst() {
	kde5_pkg_postinst

	if ! has_version "kde-apps/ffmpegthumbs:${SLOT}" ; then
		echo
		elog "For video thumbnails, please install kde-apps/ffmpegthumbs:${SLOT}"
		echo
	fi
}
