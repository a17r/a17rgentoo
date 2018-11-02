# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{5,6,7} )
inherit cmake-utils python-single-r1

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/shlomif/fc-solve.git"
	S="${S}/fc-solve/source"
	# stopped there, as the repo build needs to fetch cmake file from different location...
else
	SRC_URI="https://fc-solve.shlomifish.org/downloads/fc-solve/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Solver for layouts of Freecell and similar variants of card solitaire"
HOMEPAGE="https://fc-solve.shlomifish.org/"

LICENSE="MIT"
SLOT="0"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	dev-lang/perl:=
	dev-python/six
	dev-util/gperf
"
RDEPEND="
	dev-python/random2
	${PYTHON_DEPS}
"

src_configure() {
	local mycmakeargs=(
		-DFCS_WITH_TEST_SUITE=OFF
		-DBUILD_STATIC_LIBRARY=OFF
	)

	cmake-utils_src_configure
}
