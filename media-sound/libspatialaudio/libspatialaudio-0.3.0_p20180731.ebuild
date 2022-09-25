# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT=91b642644ad3a2598cd073e8621cc10671e5a2d6
inherit cmake

DESCRIPTION="Ambisonic encoding / decoding and binauralization library"
HOMEPAGE="https://github.com/videolabs/libspatialaudio"
SRC_URI="https://github.com/videolabs/libspatialaudio/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

src_configure() {
	local mycmakeargs=(
		-DBUILD_STATIC_LIBS=OFF
	)
	cmake_src_configure
}
