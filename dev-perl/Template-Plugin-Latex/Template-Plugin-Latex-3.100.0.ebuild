# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=EHUELS
MODULE_VERSION=3.1
inherit perl-module eutils

DESCRIPTION="LaTeX support for the Template Toolkit"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/LaTeX-Driver
	dev-perl/LaTeX-Encode
	dev-perl/LaTeX-Table
	>=dev-perl/Template-Toolkit-2.16
	virtual/latex-base
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Harness )
"

SRC_TEST="do"
