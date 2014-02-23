# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/qt-gstreamer/qt-gstreamer-0.10.2.ebuild,v 1.4 2012/09/11 10:22:34 johu Exp $

EAPI=4

QT_MINIMAL="4.7.0"

MY_PN="qt-gstreamer"
MY_P="${MY_PN}-${PV}"
S=${WORKDIR}/${MY_P}

if [[ ${PV} != *9999* ]]; then
	SRC_URI="http://gstreamer.freedesktop.org/src/${PN}/${MY_P}.tar.bz2"
	KEYWORDS="amd64 x86"
else
	GIT_ECLASS="git-2"
	EGIT_REPO_URI="git://anongit.freedesktop.org/gstreamer/${PN}"
	KEYWORDS=""
fi

inherit cmake-utils ${GIT_ECLASS}

DESCRIPTION="Standalone QtGLib derived from QtGstreamer."
HOMEPAGE="http://gstreamer.freedesktop.org/wiki/QtGStreamer"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="test"

RDEPEND="
	dev-libs/glib
	>=dev-libs/boost-1.40
	>=dev-util/boost-build-1.40
	>=dev-qt/qtcore-${QT_MINIMAL}:4
	>=dev-qt/qtdeclarative-${QT_MINIMAL}:4
	>=dev-qt/qtgui-${QT_MINIMAL}:4
	>=dev-qt/qtopengl-${QT_MINIMAL}:4
"
DEPEND="
	${RDEPEND}
	!<media-libs/qt-gstreamer-0.10.2-r1
	test? ( >=dev-qt/qttest-${QT_MINIMAL}:4 )
"

src_prepare(){
	#patches to rip out QtGstreamer
	epatch "${FILESDIR}/${P}-rip-out-gstreamer.patch"
	
	#fix for boost-1.50
	epatch "${FILESDIR}/${P}-fix-for-boost-1.50.patch"
}

src_configure() {
#	local mycmakeargs=(
#		$(cmake-utils_use test QTGSTREAMER_TESTS)
#	)

	cmake-utils_src_configure
}
