# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

FORTRAN_NEEDED=fortran
# NOTE:The build for multiple python versions should be possible but complicated for the build system
PYTHON_COMPAT=( python2_7 python3_{3,4,5} )

inherit toolchain-funcs fortran-2 python-single-r1

MY_P="med-${PV}"

DESCRIPTION="A library to store and exchange meshed data or computation results"
HOMEPAGE="http://www.salome-platform.org/"
SRC_URI="http://files.salome-platform.org/Salome/other/${MY_P}.tar.gz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc fortran python static-libs test"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
RDEPEND="
	=sci-libs/hdf5-1.8*:0=[fortran=]
	sys-cluster/openmpi[fortran=]
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}
	python? ( >=dev-lang/swig-2.0.9:0 )
"

S=${WORKDIR}/${MY_P}_SRC

PATCHES=( "${FILESDIR}/${P}-cmake-fortran.patch" )

DOCS=( AUTHORS ChangeLog NEWS README TODO )

pkg_setup() {
	use python && python-single-r1_pkg_setup
	use fortran && fortran-2_pkg_setup
}

src_configure() {
	econf \
		$(use_enable fortran) \
		$(use_enable python) \
		$(use_enable static-libs static) \
		$(use_enable test installtest)
}

src_install() {
# 	emake DESTDIR="${D}" install
	default

	# Remove documentation
	if !use doc; then
		rm -r "${D}/usr/share/doc" || die
	fi

	# Prevent test executables being installed
	if use test; then
		rm -r "${D}/usr/bin/"{testc,testf,usescases} || die
	fi
}
