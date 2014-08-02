# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils multilib multilib-minimal autotools-utils

DESCRIPTION="A helper library for REVerses ENGineered formats filters"
HOMEPAGE="http://sf.net/p/libwpd/librevenge"
if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://git.code.sf.net/p/libwpd/librevenge"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="http://sf.net/projects/libwpd/files/${PN}/${P}/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MPL-2.0"
SLOT="0"
IUSE="doc"

RDEPEND="dev-util/cppunit"
DEPEND="
	${RDEPEND}
	sys-libs/zlib
"
RDEPEND="
	${RDEPEND}
"
AUTOTOOLS_AUTORECONF=yes

src_configure() {
	myeconfargs=(
		"--disable-static"
		"--disable-werror"
		"$(use_with doc docs)"
		"--docdir=${EPREFIX}/usr/share/doc/${PF}"
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	prune_libtool_files --all
}

#pkg_postinst() {
#	if use tools; then
#		alternatives_auto_makesym /usr/bin/wpd2html "/usr/bin/wpd2html-[0-9].[0-9]"
#		alternatives_auto_makesym /usr/bin/wpd2raw "/usr/bin/wpd2raw-[0-9].[0-9]"
#		alternatives_auto_makesym /usr/bin/wpd2text "/usr/bin/wpd2text-[0-9].[0-9]"
#	fi
#}
#
#pkg_postrm() {
#	if use tools; then
#		alternatives_auto_makesym /usr/bin/wpd2html "/usr/bin/wpd2html-[0-9].[0-9]"
#		alternatives_auto_makesym /usr/bin/wpd2raw "/usr/bin/wpd2raw-[0-9].[0-9]"
#		alternatives_auto_makesym /usr/bin/wpd2text "/usr/bin/wpd2text-[0-9].[0-9]"
#	fi
#}
