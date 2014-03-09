# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

MY_PN="Caledonia"
MY_PV=${PV}
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="Caledonia is an elegant and minimalistic dark theme for Plasma-KDE."
HOMEPAGE="http://caledonia.sourceforge.net/get.html"
SRC_URI="mirror://sourceforge/caledonia/Caledonia%20%28Plasma-KDE%20Theme%29/${MY_P}.tar.gz"

LICENSE="CC-BY-SA-3.0"
KEYWORDS="~amd64 ~x86"
SLOT="0"

S="${WORKDIR}/${MY_PN}"

DOCS="AUTHORS CHANGELOG INSTALL LICENSE"

src_install() {
	rm GET\ MORE\ CALEDONIA\ STUFF || die

	dodoc ${DOCS}
	rm ${DOCS} || die

	local my_d="usr/share/apps/desktoptheme/${PN}"
	mkdir -p "${D}/${my_d}" || die "Install failed!"
	cp -R "${S}/"* "${D}/${my_d}" || die "Install failed!"
}
