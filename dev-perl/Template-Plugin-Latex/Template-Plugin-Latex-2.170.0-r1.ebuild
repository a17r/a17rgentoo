# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=ANDREWF
MODULE_VERSION=2.17
MY_PN=Template-Latex
MY_P=${MY_PN}-${MODULE_VERSION}
S=${WORKDIR}/${MY_P}
inherit perl-module eutils

DESCRIPTION="Template::Latex - Latex support for the Template Toolkit"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86"
IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND=">=dev-perl/Template-Toolkit-2.15
	virtual/perl-File-Spec
	virtual/latex-base"
DEPEND="${RDEPEND}
	test? ( virtual/perl-Test-Harness )"

SRC_TEST="do"
PATCHES=( "${FILESDIR}/Makefile.patch" )
