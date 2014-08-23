# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/itext/itext-5.2.0.ebuild,v 1.1 2012/03/26 07:21:27 sera Exp $

EAPI="4"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DISTFILE="${PN}pdf-${PV}-sources.jar"

DESCRIPTION="A Java library that generate documents in the Portable Document Format (PDF) and/or HTML"
HOMEPAGE="http://www.lowagie.com/iText/"
SRC_URI="mirror://sourceforge/${PN}/${P}.zip"

LICENSE="AGPL-3"
SLOT="5"
KEYWORDS=""
IUSE=""

BCV="1.45"

COMMON_DEPEND="
	dev-java/bcmail:${BCV}
	dev-java/bcprov:${BCV}
	dev-java/bctsp"
RDEPEND="${COMMON_DEPEND}
	>=virtual/jre-1.5"
DEPEND="${COMMON_DEPEND}
	>=virtual/jdk-1.5
	app-arch/unzip"

src_unpack() {
	#default
	unpack ${DISTFILE}
}

java_prepare() {
	# Extract resources from precompiled jar
	mkdir target/classes -p || die
	pushd target/classes > /dev/null || die
		declare -a resources
		resources=( $(jar -tf "${WORKDIR}"/${PN}pdf-${PV}.jar \
			| sed -e '/class$/d' -e '/\/$/d' -e '/META-INF/d') )
		assert
		jar -xf "${WORKDIR}"/${PN}pdf-${PV}.jar "${resources[@]}" || die
	popd > /dev/null

	find "${WORKDIR}" -name '*.jar' -exec rm -v {} + || die

	java-ant_bsfix_files ant/*.xml || die "failed to rewrite build xml files"
}

JAVA_ANT_REWRITE_CLASSPATH="true"
JAVA_ANT_ENCODING="utf8"

src_compile() {
	EANT_GENTOO_CLASSPATH="bcmail-${BCV},bcprov-${BCV}"
	#use rups && EANT_GENTOO_CLASSPATH+=",dom4j-1,pdf-renderer"

	java-pkg-2_src_compile
	#	$(use rtf && echo "jar.rtf") \
	#	$(use rups && echo "jar.rups")
}

src_install() {
	#java-pkg-simple_src_install
	cd "${WORKDIR}"
	java-pkg_dojar lib/iText.jar
	#use rtf && java-pkg_dojar lib/iText-rtf.jar
	#use rups && java-pkg_dojar lib/iText-rups.jar
	#if use cjk; then
	#	java-pkg_dojar "${DISTDIR}/${ASIANJAR}"
	#	java-pkg_dojar "${DISTDIR}/${ASIANCMAPSJAR}"
	#fi

	use source && java-pkg_dosrc src/core/com src/rups/com
	use doc && java-pkg_dojavadoc build/docs
}
