# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{3_4,3_5} )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1 python-utils-r1

MY_PV="${PV/_}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="PyQt5 launcher for FS-UAE"
HOMEPAGE="https://fs-uae.net/"
SRC_URI="https://fs-uae.net/fs-uae/stable/${MY_PV}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-python/pygame
	dev-python/python-lhafile
	dev-python/six
"
RDEPEND="${DEPEND}
	|| (
		dev-python/PyQt5
		dev-python/pyside
	)
"

PATCHES=("${FILESDIR}/${P}-drop-bundled-six.patch")

S="${WORKDIR}/${MY_P}"

python_install() {
	distutils-r1_python_install \
		--install-lib="$(python_get_sitedir)/fs-uae-launcher"
}

src_compile() {
	distutils-r1_src_compile
	emake mo
}

src_install() {
	distutils-r1_src_install
	emake DESTDIR="${D}" install mo
}
