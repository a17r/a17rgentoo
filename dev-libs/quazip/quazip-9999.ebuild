# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake flag-o-matic qmake-utils

DESCRIPTION="Simple C++ wrapper over Gilles Vollant's ZIP/UNZIP package"
HOMEPAGE="https://stachenov.github.io/quazip/"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/stachenov/quazip.git"
	inherit git-r3
else
	SRC_URI="https://github.com/stachenov/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
fi

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0"
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5
	sys-libs/zlib[minizip]
"
DEPEND="${RDEPEND}"

PATCHES=(
# 	"${FILESDIR}/${PN}-1.0.0-no-static-lib.patch" # Gentoo specific for now
	"${FILESDIR}/${PN}-1.0.0-pkgconfig.patch" # pending upstream
)

src_install() {
	cmake_src_install

	# compatibility with not yet fixed rdeps (Gentoo bug #598136)
	dosym libQt5Quazip.so /usr/$(get_libdir)/libquazip.so
}
