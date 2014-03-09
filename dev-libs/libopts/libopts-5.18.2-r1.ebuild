# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/autogen/autogen-5.18.1.ebuild,v 1.1 2013/12/02 10:18:43 radhermit Exp $

EAPI="5"

inherit autotools eutils

MY_PN="autogen"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="libopts stand alone library package"
HOMEPAGE="http://www.gnu.org/software/autogen/"
SRC_URI="mirror://gnu/${MY_PN}/rel${MY_PV}/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~arm-linux ~x86-linux ~x64-macos ~x86-macos"
#IUSE="libopts static-libs"

# RDEPEND=">=dev-scheme/guile-1.8
# 	dev-libs/libxml2"
DEPEND="${RDEPEND}
	sys-devel/automake:1.14"

S="${WORKDIR}/${MY_P}/autoopts"

src_prepare() {
	epatch "${FILESDIR}/Makefile.am.patch"

	# Rerun autotools
    einfo "Regenerating autotools files..."
#     WANT_AUTOCONF=2.5 eautoconf
    WANT_AUTOMAKE=1.14 eautomake
}

src_configure() {
#	# suppress possibly incorrect -R flag
#	export ag_cv_test_ldflags=

#	ECONF_SOURCE="${S}" \
# 	econf $(use_enable static-libs static)
	econf
}

src_install() {
	default
	prune_libtool_files
# 
# 	if ! use libopts ; then
# 		rm "${ED}"/usr/share/autogen/libopts-*.tar.gz || die
# 	fi
}
