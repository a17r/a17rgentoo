# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils

DESCRIPTION="Lightweight video thumbnailer that can be used by file managers"
HOMEPAGE="https://github.com/dirkvdb/ffmpegthumbnailer"
SRC_URI="https://github.com/dirkvdb/${PN}/releases/download/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gnome gtk jpeg libav png test"

RDEPEND="
	gtk? ( >=dev-libs/glib-2.30 )
	jpeg? ( virtual/jpeg:0 )
	!libav? ( >=media-video/ffmpeg-2.7:0= )
	libav? ( >=media-video/libav-11:0= )
	png? ( media-libs/libpng:0= )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"
REQUIRED_USE="gnome? ( gtk )"

PATCHES=(
	"${FILESDIR}/${P}-config-summary.patch"
	"${FILESDIR}/${P}-installdirs.patch"
)

DOCS=( "AUTHORS" "ChangeLog" "README.md" )

RESTRICT="test" # "Locale not specified"

src_prepare() {
	rm -rf "${S}"/out* || die

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use png HAVE_PNG)
		$(cmake-utils_use jpeg HAVE_JPEG)
		-DENABLE_THUMBNAILER=$(usex gnome)
		-DENABLE_GIO=$(usex gtk)
		-DENABLE_TESTS=$(usex test)
	)
	cmake-utils_src_configure
}
