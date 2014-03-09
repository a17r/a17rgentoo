# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

JAVA_PKG_IUSE="doc source test"

inherit eutils java-pkg-2 java-ant-2

MY_PN="${PN}2"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Provides general purpose object pooling API"
HOMEPAGE="http://commons.apache.org/pool/"
SRC_URI="mirror://apache/commons/pool/source/${MY_P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"

COMMON_DEP="dev-java/cglib:3
	dev-java/asm:4"
RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.6"
DEPEND="${COMMON_DEP}
	>=virtual/jdk-1.6
	test? (
		dev-java/ant-junit
		dev-java/junit:0
	)"

S="${WORKDIR}/${MY_P}-src"

JAVA_ANT_REWRITE_CLASSPATH="yes"

EANT_BUILD_TARGET="build-jar"
EANT_GENTOO_CLASSPATH="cglib-3,asm-4"

src_test() {
	ANT_TASKS="ant-junit" eant -Dclasspath="$(java-pkg_getjars junit)" test
}

src_install() {
	java-pkg_newjar dist/${MY_P}-SNAPSHOT.jar ${PN}.jar
	dodoc README.txt RELEASE-NOTES.txt

	use doc && java-pkg_dojavadoc dist/docs/api
	use source && java-pkg_dosrc src/main/java/org
}
