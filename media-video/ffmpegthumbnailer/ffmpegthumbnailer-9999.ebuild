# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="Lightweight video thumbnailer that can be used by file managers"
HOMEPAGE="https://github.com/dirkvdb/ffmpegthumbnailer"
if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/dirkvdb/${PN}.git"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/dirkvdb/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-2"
SLOT="0"
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

DOCS=( "AUTHORS" "ChangeLog" "README.md" )

RESTRICT="test" # "Locale not specified"

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
