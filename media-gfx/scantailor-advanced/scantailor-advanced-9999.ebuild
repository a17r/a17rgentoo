# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop git-r3 virtualx

DESCRIPTION="Interactive post-processing tool for scanned pages"
HOMEPAGE="http://scantailor.org/ https://github.com/4lex4/scantailor-advanced"
EGIT_REPO_URI="https://github.com/4lex4/scantailor-advanced"
EGIT_BRANCH="develop"

LICENSE="GPL-2 GPL-3 public-domain"
SLOT="0"
KEYWORDS=""
IUSE=""

COMMON_DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtopengl:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	media-libs/libjpeg-turbo:=
	media-libs/libpng:0=
	media-libs/tiff:0
	sys-libs/zlib
	x11-libs/libXrender
"
DEPEND="${COMMON_DEPEND}
	dev-libs/boost
"
RDEPEND="${COMMON_DEPEND}
	!media-gfx/scantailor
"
BDEPEND="dev-qt/linguist-tools:5"

src_test() {
	cd "${CMAKE_BUILD_DIR}" || die
	virtx emake test
}

src_install() {
	cmake_src_install

	newicon resources/appicon.svg ${PN}.svg
	make_desktop_entry ${PN} "Scan Tailor Advanced"
}
