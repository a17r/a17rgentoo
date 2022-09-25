# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PATCHLVL="git3-20180905"
MY_PV=${PV}-${PATCHLVL}
inherit cmake xdg

DESCRIPTION="Small, clear and fast audio player for Linux"
HOMEPAGE="https://sayonara-player.com/"
SRC_URI="ftp://sayonara-player.com/${PN}-${MY_PV}.tar.gz"
S="${WORKDIR}"/${PN}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-libs/glib:2
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsql:5[sqlite]
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	media-libs/taglib
	media-libs/gst-plugins-base:1.0
	media-libs/gstreamer:1.0
	media-plugins/gst-plugins-soundtouch:1.0
	sys-libs/zlib
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

pkg_postinst() {
	elog "Optionally, install as well:"
	elog "  media-sound/lame"
	elog "  media-libs/gst-plugins-good:1.0"
	elog "  media-libs/gst-plugins-bad:1.0"

	xdg_pkg_postinst
}
