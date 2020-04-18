# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eapi7-ver

MY_PV=$(ver_rs 3 '-')

DESCRIPTION="Scan documents over the network using the Scan key on Brother MFC devices"
HOMEPAGE="http://welcome.solutions.brother.com/bsc/public_s/id/linux/en/download_scn.html"
SRC_URI="
	amd64? ( http://www.brother.com/pub/bsc/linux/dlf/brscan-skey-${MY_PV}.amd64.deb )
	x86?   ( http://www.brother.com/pub/bsc/linux/dlf/brscan-skey-${MY_PV}.i386.deb )
"

LICENSE="Brother"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RESTRICT="fetch strip"

S="$WORKDIR"

pkg_nofetch() {
	use x86   && DOWNLOAD_URL="http://www.brother.com/cgi-bin/agreement/agreement.cgi?dlfile=http://www.brother.com/pub/bsc/linux/dlf/brscan-skey-${MY_PV}.i386.deb&lang=English_lpr"
	use amd64 && DOWNLOAD_URL="http://www.brother.com/cgi-bin/agreement/agreement.cgi?dlfile=http://www.brother.com/pub/bsc/linux/dlf/brscan-skey-${MY_PV}.amd64.deb&lang=English_lpr"
	einfo "Please download ${A} from:"
	einfo "  ${DOWNLOAD_URL}"
	einfo "Select 'I Accept' and move the file to ${DISTDIR}."
}

src_unpack() {
	unpack ${A}
	unpack ./data.tar.gz
	rm -f control.tar.gz data.tar.gz debian-binary || die
}

src_compile() {
	# empty?
	rmdir ./usr/share/doc/ || die
	rmdir ./usr/share || die
}

src_install() {
	cp -r * "${D}/" || die
}

pkg_postinst() {
	einfo "For configuration instructions, please refer to"
	einfo "  http://welcome.solutions.brother.com/bsc/public_s/id/linux/en/instruction_scn4.html"
	einfo "and"
	einfo "  http://welcome.solutions.brother.com/bsc/public_s/id/linux/en/instruction_scn5.html"
}
