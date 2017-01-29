# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_REQUIRED="never"
inherit kde4-base

DESCRIPTION="Generic geographical map widget"
HOMEPAGE="https://marble.kde.org/"
SRC_URI="mirror://kde/Attic/applications/${PV}/src/${P}.tar.xz"

KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
IUSE="debug test"

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
	kde-apps/marble:5
"
DEPEND="${RDEPEND}
	test? (
		dev-qt/qttest:4
		dev-util/cppunit
	)
"

PATCHES=(
	"${FILESDIR}/${P}-webkit-optional.patch"
	"${FILESDIR}/${P}-minimal.patch"
	"${FILESDIR}/${P}-marble4.patch"
	"${FILESDIR}/${P}-marbleui.patch"
)

src_prepare() {
	kde4-base_src_prepare
	cmake_comment_add_subdirectory doc
	cmake_comment_add_subdirectory data
}

src_configure() {
	local mycmakeargs=(
		-DWITH_DESIGNER_PLUGIN=OFF
		-DQTONLY=ON
		-DBUILD_MARBLE_APPS=OFF
		-DMARBLE_MINIMAL=ON
		-DWITH_Phonon=OFF
		-DMARBLE_NO_WEBKIT=ON
		-DBUILD_MARBLE_TESTS=OFF
		-DQT5BUILD=OFF
	)

	kde4-base_src_configure
}

src_test() {
	local mycmakeargs=(
		-DBUILD_MARBLE_TESTS=ON
	)
	kde4-base_src_test
}
