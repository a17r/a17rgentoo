# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN/lucene-}"
MY_P="${P/-${MY_PN}}"
JAVA_PKG_IUSE="source"
inherit java-pkg-2 java-ant-2 java-osgi

DESCRIPTION="Lucene Analyzers additions"
HOMEPAGE="https://lucene.apache.org/core/"
SRC_URI="https://archive.apache.org/dist/lucene/java/${PV}/${MY_P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="2.9"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND=">=virtual/jdk-1.7"
RDEPEND=">=virtual/jre-1.7"

S="${WORKDIR}/${MY_P}/contrib/${MY_PN}/common"

src_install() {
	java-osgi_newjar-fromfile "${WORKDIR}/${MY_P}/build/contrib/${MY_PN}/common/${P}-dev.jar" \
			"${FILESDIR}/manifest" "Apache Lucene Analysis"

	use source && java-pkg_dosrc "${S}/src/java/org"
}
