# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

MY_PN="Caledonia-KDM"
MY_PV=""
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="This is the Caledonia KDM theme."
HOMEPAGE="http://caledonia.sourceforge.net/get.html"
SRC_URI="http://sourceforge.net/projects/caledonia/files/Caledonia%20KDM/${MY_PN}.tar.gz/download
	-> ${PF}.tar.gz"

LICENSE="CC-BY-SA-3.0"
KEYWORDS="~amd64 ~x86"
SLOT="0"

RDEPEND="kde-base/kdm"

S="${WORKDIR}/${MY_PN}"

DOCS="INSTALL LICENSE"

src_install() {
	rm GET\ MORE\ CALEDONIA\ STUFF || die

	dodoc ${DOCS}
	rm ${DOCS} || die

	insinto "/usr/share/apps/kdm/themes/${PN}"
	doins *
}
