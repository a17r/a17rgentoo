# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

QTMIN=5.14.2
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Framework providing access to properties and features of the window manager"
LICENSE="|| ( LGPL-2.1 LGPL-3 ) MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="nls X"

BDEPEND="
	nls? ( >=dev-qt/linguist-tools-${QTMIN}:5 )
"
RDEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	X? (
		>=dev-qt/qtx11extras-${QTMIN}:5
		x11-libs/libX11
		x11-libs/libXfixes
		x11-libs/libxcb
		x11-libs/xcb-util-keysyms
	)
"
DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto )
"

DOCS=( docs/README.kstartupinfo )

PATCHES=( "${FILESDIR}/${PN}-5.74.0-no-qtwidgets.patch" ) # not all tests were ported

src_configure() {
	local mycmakeargs=(
		-DKWINDOWSYSTEM_NO_WIDGETS=ON
		$(cmake_use_find_package X X11)
	)

	ecm_src_configure
}
