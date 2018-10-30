# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

COMMIT=91b642644ad3a2598cd073e8621cc10671e5a2d6
inherit cmake-utils

DESCRIPTION="Ambisonic encoding / decoding and binauralization library"
HOMEPAGE="https://github.com/videolabs/libspatialaudio"
SRC_URI="https://github.com/videolabs/libspatialaudio/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S="${WORKDIR}/${PN}-${COMMIT}"

src_configure() {
	local mycmakeargs=(
		-DBUILD_STATIC_LIBS=OFF
	)
	cmake-utils_src_configure
}
