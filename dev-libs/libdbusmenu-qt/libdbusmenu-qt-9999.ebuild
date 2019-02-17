# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_REPO_URI="https://github.com/a17r/${PN/-/}.git"
inherit cmake-utils git-r3

DESCRIPTION="Library providing Qt implementation of DBusMenu specification"
HOMEPAGE="https://launchpad.net/libdbusmenu-qt/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

BDEPEND="kde-frameworks/extra-cmake-modules:5"
DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
"
RDEPEND="${DEPEND}"
