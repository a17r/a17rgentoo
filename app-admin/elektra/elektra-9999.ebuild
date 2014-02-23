# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/elektra/elektra-0.8.3-r2.ebuild,v 1.1 2013/04/22 14:17:35 xmw Exp $

EAPI=5

inherit cmake-multilib eutils

DESCRIPTION="universal and secure framework to store config parameters in a hierarchical key-value pair mechanism"
HOMEPAGE="http://freedesktop.org/wiki/Software/Elektra"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://gitorious.org/elektra-initiative/libelektra.git"
	inherit git-2
	SRC_URI=""
	#KEYWORDS=""
else
	SRC_URI="ftp://ftp.markus-raab.org/${PN}/releases/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="BSD"
SLOT="0"
IUSE="dbus doc examples iconv simpleini static-libs syslog tcl test +uname xml yajl"

RDEPEND="dev-libs/libxml2[${MULTILIB_USEDEP}]
	uname? ( sys-apps/coreutils )"
DEPEND="${RDEPEND}
	!amd64? ( sys-devel/libtool )
	doc? ( app-doc/doxygen )
	iconv? ( virtual/libiconv )
	test? ( dev-libs/libxml2[static-libs,${MULTILIB_USEDEP}] )
	yajl? ( <dev-libs/yajl-2 )"

DOCS="doc/AUTHORS doc/CHANGES doc/NEWS doc/README doc/todo/TODO"

src_prepare() {
	# Various upstream patches to fix stuff and make ebuild hacks obsolete
	epatch	"${FILESDIR}/${PN}-0.8.4-install-header-correctly.patch"
	epatch	"${FILESDIR}/${PN}-0.8.4-fix-man-pages-name-collision.patch"
	epatch	"${FILESDIR}/${PN}-0.8.4-fix-dependency-to-correct-man-page.patch"
	# Fix manpage install dir once and for all
	epatch	"${FILESDIR}/${PN}-0.8.4-finally-fix-manpage-install-dir.patch"
}

src_configure() {
	local my_plugins="ccode;dump;error;fstab;glob;hexcode;hidden;hosts;network;ni;null;path;resolver;struct;success;template;timeofday;tracer;type;validation"

	#move doc files to correct location
	sed -e "s/elektra-api/${PF}/" \
		-i cmake/ElektraCache.cmake || die

	use dbus      && my_plugins+=";dbus"
	use doc       && my_plugins+=";doc"
	use iconv     && my_plugins+=";iconv"
	use simpleini && my_plugins+=";simpleini"
	use syslog    && my_plugins+=";syslog"
	use tcl       && my_plugins+=";tcl"
	use uname     && my_plugins+=";uname"
	use xml       && my_plugins+=";xmltool"
	use yajl      && my_plugins+=";yajl"

	mycmakeargs=(
		"-DPLUGINS=${my_plugins}"
		"-DLATEX_COMPILER=OFF"
		"-DTARGET_CMAKE_FOLDER=share/cmake/Modules"
		$(cmake-utils_use doc BUILD_DOCUMENTATION)
		$(cmake-utils_use examples BUILD_EXAMPLES)
		$(cmake-utils_use static-libs BUILD_STATIC)
		$(cmake-utils_use test BUILD_TESTING)
	)

	cmake-multilib_src_configure
}

src_install() {
	cmake-multilib_src_install

	if use doc ; then
		# Remove bogus files
		rm -rf "${D}"/usr/share/man/man3elektra/_var_tmp_portage* || die
	fi
}
