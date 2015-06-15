# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2 eutils

MY_PN="${PN}4"
MY_PV="${PV%.*}"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="Jakarta-Commons Collections Component"
HOMEPAGE="http://commons.apache.org/collections/"
SRC_URI="mirror://apache/${PN/-//}/source/${MY_P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="test-framework"

DEPEND="
	>=virtual/jdk-1.5
	test? (
		dev-java/junit:4
		dev-java/ant-junit:0
		dev-java/easymock:3.2
		dev-java/hamcrest-core:1.3
	)
"
RDEPEND="
	>=virtual/jre-1.5
"

S="${WORKDIR}/${MY_P}-src"

src_compile() {
	local antflags
	if use test-framework; then
		antflags="test-jar -Djunit.jar=$(java-pkg_getjars junit-4)"
		#no support for installing two sets of javadocs via dojavadoc atm
		#use doc && antflags="${antflags} tf.javadoc"
	fi
	eant jar $(use_doc) ${antflags}
}

src_test() {
	if [[ "${ARCH}" = "ppc" ]]; then
		einfo "Tests are disabled on ppc"
	else
		ANT_TASKS="ant-junit" eant test -Djunit.jar="$(java-pkg_getjars junit-4)"
	fi
}

src_install() {
	java-pkg_newjar target/${MY_P}-SNAPSHOT.jar ${PN}.jar
	use test-framework && \
		java-pkg_newjar target/${MY_P}-SNAPSHOT-tests.jar ${PN}-tests.jar

	dodoc README.txt || die
	java-pkg_dohtml *.html || die
	if use doc; then
		java-pkg_dojavadoc target/apidocs
		#use test-framework && java-pkg_dojavadoc build/docs/testframework
	fi
	use source && java-pkg_dosrc src/main/java/*
}
