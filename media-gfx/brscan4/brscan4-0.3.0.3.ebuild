# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit versionator

MY_PV=$(replace_version_separator 3 '-')
DESCRIPTION="Brothers brscan4 scanner driver"
HOMEPAGE="http://welcome.solutions.brother.com/bsc/public_s/id/linux/en/download_scn.html#brscan4"
SRC_URI="
	amd64? ( http://www.brother.com/pub/bsc/linux/dlf/brscan4-${MY_PV}.amd64.deb )
	x86?   ( http://www.brother.com/pub/bsc/linux/dlf/brscan4-${MY_PV}.i386.deb )
"

LICENSE="Brother"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="fetch strip"

DEPEND=""
RDEPEND="${DEPEND}"

S="$WORKDIR"

pkg_nofetch() {
	use x86   && DOWNLOAD_URL="http://www.brother.com/cgi-bin/agreement/agreement.cgi?dlfile=http://www.brother.com/pub/bsc/linux/dlf/brscan4-${MY_PV}.i386.deb&lang=English_lpr"
	use amd64 && DOWNLOAD_URL="http://www.brother.com/cgi-bin/agreement/agreement.cgi?dlfile=http://www.brother.com/pub/bsc/linux/dlf/brscan4-${MY_PV}.amd64.deb&lang=English_lpr"
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
	# Don't overwrite the users configuration file. the default one is empty anyways
	if [[ -e "${ROOT}/usr/local/Brother/sane/brsanenetdevice4.cfg" ]]; then
		mv "./usr/local/Brother/sane/brsanenetdevice4.cfg" "./usr/local/Brother/sane/brsanenetdevice4.cfg.dist"
		cp "${ROOT}/usr/local/Brother/sane/brsanenetdevice4.cfg" "./usr/local/Brother/sane/brsanenetdevice4.cfg"
	fi

	# not needed, handled by this ebuild:
	rm ./usr/local/Brother/sane/setupSaneScan4 || die

	dodoc ./usr/local/Brother/sane/doc/brscan4/readme.txt
	rm -rf ./usr/local/Brother/sane/doc/ || die
}

src_install() {
	cp -r * "$D/"
	if ! grep -q ^brother4\$ "${ROOT}/etc/sane.d/dll.conf" ; then
		mkdir -p "$D/etc/sane.d/" || die
		cp "${ROOT}/etc/sane.d/dll.conf" "$D/etc/sane.d/" || die
		echo "brother4" >> "$D/etc/sane.d/dll.conf"
		NEED_ETC_UPDATE=true
	fi
}

pkg_postinst() {
	einfo "To be able to scan via USB as a non-root user, add the following line to"
	einfo "your udev configuration:"
	einfo "ATTRS{idVendor}==\"04f9\", MODE=\"0666\", ENV{libsane_matched}=\"yes\""
	einfo
	einfo "For network scanning, execute the following as root:"
	einfo "# brsaneconfig4 -a name=(choose a name)  model=(model name) ip=xx.xx.xx.xx"
	einfo "Detailed Instuctions can be found on:"
	einfo "http://welcome.solutions.brother.com/bsc/public_s/id/linux/en/instruction_scn1b.html"
	if [[ "$NEED_ETC_UPDATE" == true ]]; then
		ewarn
		ewarn "Note: You need to update /etc/sane.d/dll.conf with etc-update before you can use the scanner"
	fi
}
