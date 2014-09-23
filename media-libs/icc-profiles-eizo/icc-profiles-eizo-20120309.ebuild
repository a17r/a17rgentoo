# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

DESCRIPTION="ICC color profiles by Eizo"
HOMEPAGE="http://www.eizo.com/"
SRC_URI="http://www.eizo.com/global/support/db/files/software/icc/lcd/S2243WINF_W.zip
	http://www.eizo.com/global/support/db/files/software/icc/lcd/S2242WINF_W.zip"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

#USE_EXPAND="DISPLAY_DEVICES"
#DISPLAY_DEVICES="s2242w s2243w"

DEPEND="app-arch/unzip"

#TODO:
#install path /usr/share/color/icc/
#				  eizo/

src_unpack() {
	for zip in ${A} ; do
		echo ">>> Unpacking ${zip} to ${WORKDIR}"
		unzip "${DISTDIR}"/${zip} -x *html *cat *inf > /dev/null \
			|| die "failed to unpack ${zip}"
	done
}

S="${WORKDIR}"

src_install() {
	dodir /usr/share/color/icc/Eizo
	insinto /usr/share/color/icc/Eizo
	doins *.icm
}