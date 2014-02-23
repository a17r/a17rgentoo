# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

MY_PN="Caledonia_Official_Wallpaper_Collection"
MY_PV=""
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="This is the Caledonia KSplash theme."
HOMEPAGE="http://caledonia.sourceforge.net/get.html"
SRC_URI="http://sourceforge.net/projects/caledonia/files/Caledonia%20Official%20Wallpapers/${MY_PN}.tar.gz/download
	-> ${PF}.tar.gz"

LICENSE="CC-BY-SA-3.0"
KEYWORDS="~amd64 ~x86"
SLOT="0"

S="${WORKDIR}/${MY_PN}"

DOCS="README CHANGELOG"

src_install() {
	dodoc ${DOCS}
	rm ${DOCS} || die

	local my_d="/usr/share/wallpapers/"
	mkdir -p "${D}/${my_d}" || die "Install failed!"
	cp -R "${S}/"* "${D}/${my_d}" || die "Install failed!"
}
