# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

DESCRIPTION="xcalib is a tiny monitor calibration loader for X.org"
HOMEPAGE="https://github.com/OpenICC/config"
SRC_URI="https://github.com/OpenICC/config/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="
	dev-libs/yajl
"
DEPEND="${RDEPEND}
	dev-libs/libiconv
	dev-libs/libintl
	sys-devel/gettext
	doc? ( app-doc/doxygen )
"

S="${WORKDIR}/config-${PV}"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=$(usex !doc)
	)

	cmake-utils_src_configure
}
