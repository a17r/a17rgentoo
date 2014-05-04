# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/autogen/autogen-5.15.ebuild,v 1.8 2013/02/21 03:43:49 zmedico Exp $

EAPI="4"

AUTOTOOLS_AUTORECONF=1

inherit eutils autotools-utils multilib-minimal

DESCRIPTION="Program and text file generation"
HOMEPAGE="http://www.gnu.org/software/autogen/"
SRC_URI="mirror://gnu/${PN}/rel${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~arm-linux ~x86-linux ~x64-macos 
~x86-macos"
IUSE="static-libs"

RDEPEND=">=dev-scheme/guile-1.8
	dev-libs/libxml2"
DEPEND="${RDEPEND}"

src_prepare() {
	DOCS=( NOTES TODO )
	sed -i -e '/Cannot find libguile/d' config/ag_macros.m4
	autotools-utils_src_prepare
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf $(use_enable static-libs static)

	if ! multilib_build_binaries; then
		sed -i -e '/^nodist_pkgdata_DATA/s:\$(libsrc)::' autoopts/Makefile || die
	fi
}

multilib_src_compile() {
	if multilib_build_binaries; then
		emake
	else
		emake -C "${BUILD_DIR}"/snprintfv
		emake -C "${BUILD_DIR}"/autoopts
	fi
}

multilib_src_install() {
	if multilib_build_binaries; then
		emake DESTDIR="${D}" install
	else
		emake -C "${BUILD_DIR}"/autoopts DESTDIR="${D}" install
	fi
}

multilib_src_install_all() {
	einstalldocs
	rm "${ED}"/usr/share/autogen/libopts-*.tar.gz || die
	prune_libtool_files
}
