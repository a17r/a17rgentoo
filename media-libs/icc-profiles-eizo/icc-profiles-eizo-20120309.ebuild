# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils

DESCRIPTION="ICC profiles for EIZO monitors"
HOMEPAGE="http://www.eizo.com/"
BASE_SRC_URI="http://www.eizo.com/global/support/db/files/software/icc/lcd"

LICENSE="Eizo"
SLOT="0"
KEYWORDS="~amd64 ~x86"

ICC_PROFILES="S2201W S2202W S2231W S2232W S2233W S2242W S2243W"

for profile in ${ICC_PROFILES}; do
	SRC_URI+=" icc_profiles_${profile}? ( ${BASE_SRC_URI}/${profile}INF_W.zip -> ${profile}.zip )"
	IUSE+=" icc_profiles_${profile}"
done
unset profile

RESTRICT="mirror"

DEPEND="app-arch/unzip"

src_unpack() {
	for profile in ${ICC_PROFILES}; do
		use_if_iuse icc_profiles_${profile} || continue
		echo ">>> Unpacking ${profile} to ${WORKDIR}"
		unzip "${DISTDIR}/${profile}.zip" -x *html *cat *inf > /dev/null \
			|| die "failed to unpack ${profile}.zip"
	done
}

S="${WORKDIR}"

src_install() {
	dodir /usr/share/color/icc/Eizo
	insinto /usr/share/color/icc/Eizo
	doins *.icm
}