# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

KDE_HANDBOOK="true"
EGIT_BRANCH="applications/kate/kwrite"
#KMEXTRACTONLY="doc/kate"
inherit kde5

DESCRIPTION="KDE MDI editor/IDE"
HOMEPAGE="http://www.kde.org/applications/utilities/kwrite"

KEYWORDS=""
IUSE="X"

DEPEND="
	$(add_frameworks_dep katepart)
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtscript:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5"
RDEPEND="${DEPEND}
	!kde-base/kwrite:4"

src_configure() {
	kde5_src_configure
}
