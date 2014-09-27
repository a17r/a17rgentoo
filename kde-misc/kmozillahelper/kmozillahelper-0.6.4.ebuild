# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit kde4-base

DESCRIPTION="KDE4 integration for Firefox"
HOMEPAGE="https://build.opensuse.org/package/show/mozilla:Factory/mozilla-kde4-integration"
SRC_URI="https://build.opensuse.org/source/mozilla:Factory/mozilla-kde4-integration/${P}.tar.bz2?rev=b88c72dfdc858f6209feb123227bd7df -> ${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86 ~ppc"

IUSE=""

S="${WORKDIR}/${PN}"

src_prepare() {
	epatch "${FILESDIR}/CMakeLists.txt.diff"
	kde4-base_src_prepare
}
