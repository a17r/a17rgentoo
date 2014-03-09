# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jmock/jmock-1.1.0-r2.ebuild,v 1.11 2013/09/01 09:30:29 grobian Exp $

EAPI="5"

JAVA_PKG_IUSE="doc examples source test"
inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Library for testing Java code using mock objects."
SRC_URI="http://${PN}.codehaus.org/${P}.tar.gz"
HOMEPAGE="http://jmock.codehaus.org"
LICENSE="BSD"
SLOT="1.0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

COMMON_DEPEND="
	dev-java/cglib:2.1
	dev-java/junit:0"

RDEPEND=">=virtual/jre-1.4
	${COMMON_DEPEND}"

DEPEND=">=virtual/jdk-1.4
	${COMMON_DEPEND}
	test? ( dev-java/ant-junit )"

S="${WORKDIR}/jmock"

src_prepare() {
	EANT_BUILD_TARGET="core.jar cglib.jar"
	use test && EANT_BUILD_TARGET="${EANT_BUILD_TARGET} tests.jar"

	epatch "${FILESDIR}/1.2.0-build.xml.patch"
	epatch "${FILESDIR}/1.2.0-junit-3.8.2.patch"

	cd "${S}/lib" || die
	rm -v *.jar || die
	java-pkg_jar-from cglib-2.1,junit
}

src_test() {
	ANT_TASKS="ant-junit" eant run.tests testdata
}

src_install() {
	java-pkg_newjar "build/${P}.jar"
	java-pkg_newjar "build/${PN}-cglib-${PV}.jar" "${PN}-cglib.jar"
	dohtml overview.html

	use doc && java-pkg_dojavadoc build/javadoc-*
	use examples && java-pkg_doexamples examples
	use source && java-pkg_dosrc src/org
}
