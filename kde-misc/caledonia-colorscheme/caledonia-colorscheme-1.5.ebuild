# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

MY_PN="Caledonia.colors"
MY_PV="${PV}"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="This is the Caledonia KSplash theme."
HOMEPAGE="http://caledonia.sourceforge.net/get.html"
SRC_URI="http://sourceforge.net/projects/caledonia/files/Caledonia%20Color%20Scheme/${MY_PN}/download
	-> ${MY_P}"

LICENSE="CCPL-Attribution-ShareAlike-3.0"
KEYWORDS="~amd64 ~x86"
SLOT="0"

RDEPEND="kde-base/ksplash"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_unpack() {
	cp "${DISTDIR}/${A}" "${S}" || die "Copy failed!"
}

src_install() {
	local my_d="/usr/share/apps/color-schemes/"
	mkdir -p "${D}/${my_d}" || die "Install failed!"
	cp "${S}/${MY_P}" "${D}/${my_d}/${MY_PN}" || die "Install failed!"
}
