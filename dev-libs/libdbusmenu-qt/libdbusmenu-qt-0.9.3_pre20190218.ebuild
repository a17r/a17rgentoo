# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

COMMIT=22f13a378a9842ce3534877a2175bf6e7f0d0cbd
MY_PN=${PN/-/}
inherit cmake

DESCRIPTION="Library providing Qt implementation of DBusMenu specification"
HOMEPAGE="https://launchpad.net/libdbusmenu-qt/ https://github.com/a17r/libdbusmenuqt"
SRC_URI="https://github.com/a17r/${MY_PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}-${COMMIT}"

src_prepare() {
	cmake_src_prepare

	cmake_comment_add_subdirectory tools
	# tests fail due to missing connection to dbus
	cmake_comment_add_subdirectory tests
}
