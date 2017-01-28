# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_HANDBOOK="optional"
KDE_REQUIRED="optional"
CPPUNIT_REQUIRED="optional"
PYTHON_COMPAT=( python2_7 )
WEBKIT_REQUIRED="optional"
inherit kde4-base python-single-r1

DESCRIPTION="Generic geographical map widget"
HOMEPAGE="https://marble.kde.org/"
SRC_URI+=" https://dev.gentoo.org/~asturm/${P}-patches.tar.xz"

KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
IUSE="debug designer gps minimal phonon plasma python shapefile test zip"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# tests fail / segfault. Last checked for 4.9.0
RESTRICT="test"

RDEPEND="
	dev-qt/qtcore:4
	dev-qt/qtdbus:4
	dev-qt/qtdeclarative:4
	dev-qt/qtgui:4
	dev-qt/qtscript:4
	dev-qt/qtsql:4
	dev-qt/qtsvg:4
	designer? ( dev-qt/designer:4 )
	gps? ( >=sci-geosciences/gpsd-2.95[qt4] )
	phonon? ( media-libs/phonon[qt4] )
	python? (
		${PYTHON_DEPS}
		>=dev-python/PyQt4-4.4.4-r1[${PYTHON_USEDEP}]
		$(add_kdeapps_dep pykde4 "${PYTHON_USEDEP}" )
	)
	shapefile? ( sci-libs/shapelib:= )
	webkit? ( dev-qt/qtwebkit:4 )
	zip? ( dev-libs/quazip[qt4] )
"
DEPEND="${RDEPEND}
	test? ( dev-qt/qttest:4 )
"
# the qt dependencies are needed because with USE=-kde nothing is pulled in
# by default... bugs 414165 & 429346

REQUIRED_USE="plasma? ( kde )"

PATCHES=( "${WORKDIR}"/${P}-patches )

pkg_setup() {
	kde4-base_pkg_setup
	use python && python-single-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DWITH_DESIGNER_PLUGIN=$(usex designer)
		-DEXPERIMENTAL_PYTHON_BINDINGS=$(usex python)
		-DWITH_PythonLibrary=$(usex python)
		-DWITH_PyQt4=$(usex python)
		-DWITH_SIP=$(usex python)
		-DWITH_libgps=$(usex gps)
		-DQTONLY=$(usex !kde)
		-DWITH_Phonon=$(usex phonon)
		-DMARBLE_NO_PLASMA=$(usex !plasma)
		-DWITH_libshp=$(usex shapefile)
		-DMARBLE_NO_WEBKIT=$(usex !webkit)
		-DWITH_quazip=$(usex zip)
		-DBUILD_MARBLE_TESTS=OFF
		-DWITH_liblocation=0
		-DWITH_QextSerialPort=OFF
	)

	kde4-base_src_configure
}

src_test() {
	if use kde; then
		elog "Marble tests can only be run in the qt-only version"
	else
		local mycmakeargs=(
			-DBUILD_MARBLE_TESTS=ON
		)
		kde4-base_src_test
	fi
}
