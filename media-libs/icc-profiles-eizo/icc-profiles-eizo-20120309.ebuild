# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ICC_PROFILES="S2201W S2202W S2231W S2232W S2233W S2242W S2243W"

DESCRIPTION="ICC profiles for EIZO monitors"
HOMEPAGE="https://www.eizoglobal.com/"
BASE_SRC_URI="https://www.eizoglobal.com/global/support/db/files/software/icc/lcd"

LICENSE="Eizo"
SLOT="0"
KEYWORDS="~amd64 ~x86"

for PROFILE in ${ICC_PROFILES}; do
	SRC_URI+=" icc_profiles_${PROFILE}? ( ${BASE_SRC_URI}/${PROFILE}INF_W.zip -> ${PROFILE}.zip )"
	IUSE+=" icc_profiles_${PROFILE}"
done
unset PROFILE

RESTRICT="bindist mirror"

DEPEND="app-arch/unzip"

S="${WORKDIR}"

src_unpack() {
	local profile
	for profile in ${ICC_PROFILES}; do
		use icc_profiles_${profile} || continue
		echo ">>> Unpacking ${profile} to ${WORKDIR}"
		unzip "${DISTDIR}/${profile}.zip" -x *html *cat *inf > /dev/null \
			|| die "failed to unpack ${profile}.zip"
	done
}

src_install() {
	[[ -n ${A} ]] || return
	insinto /usr/share/color/icc/Eizo
	doins *.icm
}
