# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="JFreeSVG is a fast, light-weight, vector graphics library for the Java platform"
HOMEPAGE="http://www.jfree.org/${PN}/"
SRC_URI="mirror://sourceforge/${PN}/${P}.zip"

LICENSE="GPL-3"
SLOT="2.0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

RDEPEND="
	>=virtual/jdk-1.5"
DEPEND="
	>=virtual/jdk-1.5
	app-arch/unzip"

java_prepare() {
	find "${WORKDIR}" -name '*.jar' -print -delete || die
}

src_compile() {
	if ! use debug; then
		antflags="-Dbuild.debug=false -Dbuild.optimize=true"
	fi
	eant -f ant/build.xml compile $(use_doc) $antflags
}

src_install() {
	java-pkg_newjar "./lib/${P}.jar" ${PN}.jar
	dodoc README.md
	use doc && java-pkg_dojavadoc javadoc
	use source && java-pkg_dosrc src/main/java
}