# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="JFreeChart is a free Java class library for generating charts"
HOMEPAGE="http://www.jfree.org/jfreechart"
SRC_URI="mirror://sourceforge/${PN}/${P}.zip"

LICENSE="LGPL-2.1"
SLOT="1.0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="+servlet"

COMMON_DEPEND="
	>=virtual/jdk-1.6
	>=dev-java/jcommon-1.0.23:1.0
	>=dev-java/jfreesvg-2.0
	servlet? ( java-virtuals/servlet-api:2.3 )"

DEPEND="
	${COMMON_DEPEND}
	app-arch/unzip
	test? (
		dev-java/ant-junit:0
		dev-java/junit:4
	)"

RDEPEND="${COMMON_DEPEND}"

JAVA_PKG_FILTER_COMPILER="jikes"

src_prepare() {
	epatch "${FILESDIR}/${PN}-1.0.19-build.xml.patch"

	# Fix test failure, obtained from
	# http://sourceforge.net/p/jfreechart/bugs/1100/
	epatch "${FILESDIR}/${PN}-1.0.19-fix-TimeSeriesCollectionTest.patch"

	rm -v lib/*.jar || die

	# links to orsonpdf which is only available for purchase under a commercial license
	rm -v "${P}-demo.jar" || die

	if ! use servlet; then
		rm -rf source/org/jfree/chart/servlet || die
	fi
}

src_compile() {
	# Note that compile-experimental depends on compile so it is sufficient to run
	# just compile-experimental
	eant -f ant/build.xml compile-experimental $(use_doc) $(get_jars)
}

src_test() {
	# X11 tests are disabled using java.awt.headless=true
	ANT_TASKS="ant-junit" \
	ANT_OPTS="-Djava.awt.headless=true -Duser.timezone=UTC" \
		eant -f ant/build.xml test $(get_jars)
}

src_install() {
	java-pkg_newjar lib/${P}.jar ${PN}.jar
	java-pkg_newjar lib/${P}-experimental.jar ${PN}-experimental.jar

	dodoc README.txt ChangeLog NEWS

	use doc && java-pkg_dojavadoc javadoc

	use source && java-pkg_dosrc source/org
}

get_jars() {
	local antflags="
		-Djcommon.jar=$(java-pkg_getjar jcommon-1.0 jcommon.jar) \
		-Djfreesvg.jar=$(java-pkg_getjar jfreesvg-2.0 jfreesvg.jar)"

	use servlet && antflags="${antflags} \
		-Dservlet.jar=$(java-pkg_getjars servlet-api-2.3)"

	use test && antflags="${antflags} \
		-Djunit.jar=$(java-pkg_getjars --build-only junit-4)"

	echo "${antflags}"
}
