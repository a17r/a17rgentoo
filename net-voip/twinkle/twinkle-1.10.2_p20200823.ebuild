# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

COMMIT=b7965d023cb68bce6d9495eb6afbc73206c1afef
inherit xdg cmake

DESCRIPTION="Softphone for VoIP communcations using SIP protocol"
HOMEPAGE="http://twinkle.dolezel.info/"
SRC_URI="https://github.com/LubosD/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="alsa g729 gsm gui speex"

RDEPEND="
	dev-cpp/commoncpp2
	dev-libs/boost:=
	dev-libs/libxml2:2
	dev-libs/ucommon:=
	media-libs/fontconfig
	media-libs/libsndfile
	net-libs/ccrtp:=
	sys-apps/file
	sys-libs/readline:=
	alsa? ( media-libs/alsa-lib )
	g729? ( media-libs/bcg729 )
	gsm? ( media-sound/gsm )
	gui? (
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtdeclarative:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
	speex? (
		media-libs/speex
		media-libs/speexdsp
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/bison
	sys-devel/flex
	gui? ( dev-qt/linguist-tools:5 )
"

src_configure() {
	local mycmakeargs=(
		-DWITH_ILBC=OFF # build fails with libilbc
		-DWITH_ZRTP=OFF # not packaged
		-DWITH_ALSA=$(usex alsa)
		-DWITH_G729=$(usex g729)
		-DWITH_GSM=$(usex gsm)
		-DWITH_QT5=$(usex gui)
		-DWITH_SPEEX=$(usex speex)
	)
	cmake_src_configure
}
