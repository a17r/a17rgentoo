# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=ETHER
MODULE_VERSION=1.003009
inherit perl-module

DESCRIPTION="Use Cpanel::JSON::XS with a fallback to JSON::XS and JSON::PP"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	|| (
		dev-perl/Cpanel-JSON-XS
		dev-perl/JSON-XS
		virtual/perl-JSON-PP
	)
	virtual/perl-ExtUtils-CBuilder
	virtual/perl-ExtUtils-MakeMaker
"
RDEPEND="${DEPEND}"

SRC_TEST="do"
