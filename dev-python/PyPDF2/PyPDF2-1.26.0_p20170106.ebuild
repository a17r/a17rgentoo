# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )
COMMIT="2a9d76d1244444f7bdd1e8f42eaeee159eadf7fa"
inherit distutils-r1 vcs-snapshot

DESCRIPTION="Python library to work with pdf files"
HOMEPAGE="https://pypi.python.org/pypi/${PN}/ https://github.com/mstamy2/PyPDF2"
SRC_URI="https://github.com/mstamy2/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

PATCHES=( "${FILESDIR}/${PN}-1.26.0-py3-tests.patch" )

python_test() {
	"${PYTHON}" -m unittest Tests.tests || die "Tests failed under ${EPYTHON}"
}

python_install_all() {
	use examples && local EXAMPLES=( Sample_Code/. )
	distutils-r1_python_install_all
}
