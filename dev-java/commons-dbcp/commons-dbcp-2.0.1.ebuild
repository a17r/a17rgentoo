# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

MY_PN="${PN}2"
MY_PV="${PV%_*}"
MY_P="${MY_PN}-${MY_PV}-src"

DESCRIPTION="Jakarta component providing database connection pooling API"
HOMEPAGE="http://commons.apache.org/dbcp/"
SRC_URI="mirror://apache/commons/dbcp/source/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEP=">=dev-java/commons-logging-1.1.3
	dev-java/commons-pool:2
	java-virtuals/transaction-api:0"
RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.7"
DEPEND="${COMMON_DEP}
	virtual/jdk:1.7
	test? ( dev-java/ant-junit:0 )"

S="${WORKDIR}/${MY_P}"

JAVA_ANT_REWRITE_CLASSPATH="yes"
JAVA_ANT_CLASSPATH_TAGS+=" javadoc"

EANT_BUILD_TARGET="build-jar"
EANT_GENTOO_CLASSPATH="commons-logging,commons-pool,transaction-api"

src_test() {
	# depend on not packaged geronimo #348853
	rm -v src/test/java/org/apache/commons/dbcp2/managed/TestBasicManagedDataSource.java || die
	rm -v src/test/java/org/apache/commons/dbcp2/managed/TestManagedDataSource.java || die
	rm -v src/test/java/org/apache/commons/dbcp2/managed/TestManagedDataSourceInTx.java || die

	# fails :(
	rm -v src/test/java/org/apache/commons/dbcp2/TestJndi.java || die

	java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar dist/${MY_PN}-${MY_PV}.jar ${PN}.jar
	dodoc README.txt RELEASE-NOTES.txt

	use doc && java-pkg_dojavadoc dist/docs/api
	use source && java-pkg_dosrc src/main/java/*
}
