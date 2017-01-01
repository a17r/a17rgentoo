# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_HANDBOOK="forceoptional"
inherit kde5

DESCRIPTION="Advanced network neighborhood browser"
HOMEPAGE="https://sourceforge.net/p/smb4k/home/Home/"
[[ ${PV} != 9999 ]] && \
SRC_URI="mirror://sourceforge/${PN}/${PN}-${PV/_p*/}.tar.xz
	http://dev.gentoo.org/~asturm/${PF}-patch.tar.xz"

[[ ${PV} != 9999 ]] && KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2"
IUSE=""

COMMON_DEPEND="
	$(add_frameworks_dep kauth)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kjobwidgets)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep kwallet)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep solid)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtprintsupport)
	$(add_qt_dep qtwidgets)
"
DEPEND="${COMMON_DEPEND}
	sys-devel/gettext
"
RDEPEND="${COMMON_DEPEND}
	net-fs/samba[cups]
	!net-misc/smb4k:4
"

DOCS=( AUTHORS BUGS ChangeLog README )

PATCHES=( "${WORKDIR}/${PF}".patch )

S="${WORKDIR}/${PN}-${PV/_p*/}"
