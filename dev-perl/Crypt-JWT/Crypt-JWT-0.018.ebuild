# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MIK
DIST_VERSION=0.018
inherit perl-module

DESCRIPTION="JSON Web Token (JWT, JWS, JWE) as defined by RFC7519, RFC7515, RFC7516"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-perl/CryptX
	dev-perl/JSON
	dev-perl/JSON-MaybeXS
	virtual/perl-Compress-Raw-Zlib
	virtual/perl-Exporter
	virtual/perl-ExtUtils-MakeMaker
	virtual/perl-MIME-Base64
"
RDEPEND="${DEPEND}"

SRC_TEST="do"
