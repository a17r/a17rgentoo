# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
JAVA_PKG_IUSE="doc examples source"
JAVA_PKG_BSFIX_NAME="deploy-release.xml setup-linux.xml build.xml"

inherit eutils java-pkg-2 java-ant-2

MY_PN="Flashtool"
MY_P="${MY_PN}-${PV}"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/Androxyde/${MY_PN}.git"
	EVCS_OFFLINE=1
	inherit git-2
else
	SRC_URI="mirror://gentoo/${P}-src.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Flashtool is a S1 flashing software that works for all Sony phones from X10 to Xperia Z Ultra"
HOMEPAGE="http://www.flashtool.net/"

LICENSE="Apache-2.0"
SLOT="0"

# delete: commons-io-2.4.jar
# delete: jdom-1.1.1.jar
# delete: log4j-1.2.17.jar
# delete: jdom-1.1.1.jar
# delete: jna-4.0.0.jar jna-platform-4.0.0.jar
# delete: jopt-simple-4.3.jar
# delete: nsisant-1.3.jar	# not required for linux setup
# bundled: AXMLPrinter2.jar	http://code.google.com/p/xml-apk-parser/
# bundled: sony.jar
COMMON_DEP="
	>=dev-java/commons-io-2.4:1
	dev-java/jdom
	dev-java/jna
	dev-java/jopt-simple
	>=dev-java/log4j-1.2.16
	dev-java/swt:4.2
	>=virtual/libusb-1-r1:1"

RDEPEND=">=virtual/jre-1.6
	${COMMON_DEP}"

DEPEND=">=virtual/jdk-1.6
	${COMMON_DEP}"

INSTALL_BASE="opt/${PN}"

JAVA_ANT_REWRITE_CLASSPATH="yes"
EANT_GENTOO_CLASSPATH="commons-io-1,jdom-1.0,jna,jopt-simple-4.5,log4j,swt-4.2"

java_prepare() {
	cp "${FILESDIR}/build.xml" "${S}/" || die

	epatch "${FILESDIR}/deploy-release-1.xml.patch"
	epatch "${FILESDIR}/setup-linux-2.xml.patch"

	einfo "Remove Class-Path version atoms from setup-linux.xml"
	sed -i -e '/Class-Path/ s/\(\-[0-9.]\+.[0-9]\+\)//g' setup-linux.xml || die

	einfo "Patch libusb/jna/LibUsbLibrary.java for Gentoo libusb"
	sed -i -e '/LibUsbLibrary libUsb/ s/usbx-1.0/libusb-1.0/' src/libusb/jna/LibUsbLibrary.java || die

	# Remove bundled libusb
	rm -vrf linux/linux || die

	cd "${S}/libs"
	# Remove bundled jars
	rm -v commons-io*jar jdom*jar log4j*jar jna*jar jopt-simple*jar nsisant*.jar || die
	# remove irrelevant swt
	rm -vrf swtwin swtmac || die
	# Remove bundled swt
	rm -vrf swtlin/swt{32,64}.jar || die

# 	java-pkg_jar-from commons-io-1 commons-io.jar
# 	java-pkg_jar-from jdom-1.0 jdom.jar
# 	java-pkg_jar-from jna jna.jar
# 	java-pkg_jar-from jna platform.jar jna-platform.jar
# 	java-pkg_jar-from jopt-simple-4.5 jopt-simple.jar
# 	java-pkg_jar-from log4j log4j.jar
# 	java-pkg_jar-from swt-4.2 swt.jar
}

src_compile(){
	EANT_BUILD_XML="deploy-release.xml"
	EANT_BUILD_TARGET="all"
	java-pkg-2_src_compile

	EANT_BUILD_XML="build.xml"
	EANT_BUILD_TARGET="build"
	java-pkg-2_src_compile

	EANT_BUILD_XML="setup-linux.xml"
	EANT_BUILD_TARGET="binaries"
	java-pkg-2_src_compile
}

src_install() {
# 	java-pkg_newjar Deploy/${P}-dev.jar ${PN}.jar
	insinto /opt
	doins -r "${WORKDIR}"/Deploy/FlashTool
#        use doc && java-pkg_dojavadoc dist/api
#        use source && java-pkg_dosrc src/java/org
#        use examples && java-pkg_doexamples src/java/examples
}
