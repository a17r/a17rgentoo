# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="forceoptional"
KMNAME="${PN}5"
inherit kde5

DESCRIPTION="Screen gamma values kcontrol module"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

COMMON_DEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	x11-libs/libX11
	x11-libs/libXxf86vm
"
DEPEND="${COMMON_DEPEND}
	x11-proto/xf86vidmodeproto
"
RDEPEND="${COMMON_DEPEND}
	!<kde-apps/kde4-l10n-16.04.0
"
