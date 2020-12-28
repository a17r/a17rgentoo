# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="GNU ccRTP - Implementation of the IETF real-time transport protocol"
HOMEPAGE="https://www.gnu.org/software/ccrtp/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/2"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="doc"

RDEPEND="
	>=dev-cpp/commoncpp2-1.3.0:0=
	dev-libs/libgcrypt:0=
	>=dev-libs/ucommon-6.2.2:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

src_configure() {
	econf --disable-static
}

src_install() {
	use doc && local HTML_DOCS=( doc/html/. )
	default
	find "${D}" -name '*.la' -delete || die
}
