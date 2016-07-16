# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit kde4-base

DESCRIPTION="Plasma 4 integration for Firefox"
HOMEPAGE="https://build.opensuse.org/package/show/mozilla:Factory/mozilla-kde4-integration"
SRC_URI="https://build.opensuse.org/source/mozilla:Factory/mozilla-kde4-integration/${P}.tar.bz2?rev=b88c72dfdc858f6209feb123227bd7df -> ${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"

PATCHES=( "${FILESDIR}/CMakeLists.txt.diff" )

S="${WORKDIR}/${PN}"
