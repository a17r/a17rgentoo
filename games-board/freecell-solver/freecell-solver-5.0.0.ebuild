# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{5,6,7} )
inherit cmake-utils python-single-r1

DESCRIPTION="Solver for layouts of Freecell and similar variants of card solitaire"
HOMEPAGE="https://fc-solve.shlomifish.org/"
SRC_URI="https://fc-solve.shlomifish.org/downloads/fc-solve/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	dev-perl/Path-Tiny
	dev-perl/Template-Toolkit
	dev-python/six
	dev-util/gperf
"
RDEPEND="${PYTHON_DEPS}
	dev-python/random2
"

src_configure() {
	local mycmakeargs=(
		-DFCS_WITH_TEST_SUITE=OFF
		-DBUILD_STATIC_LIBRARY=OFF
	)

	cmake-utils_src_configure
}
