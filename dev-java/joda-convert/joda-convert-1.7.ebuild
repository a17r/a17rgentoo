# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
inherit java-pkg-2 java-ant-2

DESCRIPTION="Java library for conversion between Object and String"
HOMEPAGE="https://www.joda.org/joda-convert/"
SRC_URI="https://github.com/JodaOrg/${PN}/releases/download/v${PV}/${P}-dist.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=virtual/jdk-1.7
	test? (
		dev-java/junit:4
		dev-java/ant-junit:0
		dev-java/hamcrest-core:1.3
	)"
RDEPEND=">=virtual/jre-1.7"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_TEST_GENTOO_CLASSPATH="junit-4,hamcrest-core-1.3"
EANT_EXTRA_ARGS="-Dmaven.build.finalName=${PN}"

java_prepare() {
	cp "${FILESDIR}"/${P}-build.xml build.xml || die
}

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_dojar target/${PN}.jar
	dodoc NOTICE.txt RELEASE-NOTES.txt

	use doc && java-pkg_dojavadoc target/site/apidocs
	use source && java-pkg_dosrc src/main/java/*
}
