# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit cmake-utils eutils 

DESCRIPTION="universal and secure framework to store config parameters in a hierarchical key-value pair mechanism"
HOMEPAGE="http://freedesktop.org/wiki/Software/Elektra"

if [[ ${PV} == "9999" ]] ; then
        EGIT_REPO_URI="git://gitorious.org/elektra-initiative/libelektra.git"
        inherit git-2
        SRC_URI=""
        #KEYWORDS=""
else
        SRC_URI="ftp://ftp.markus-raab.org/${PN}/releases/${P}.tar.gz"
fi

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="dbus doc examples iconv inifile static-libs syslog tcl test xml yajl"

RDEPEND="dev-libs/libxml2"
DEPEND="${RDEPEND}
	sys-devel/libtool
	doc? ( app-doc/doxygen )
	iconv? ( virtual/libiconv )
	test? ( dev-libs/libxml2[static-libs] )
	yajl? ( <dev-libs/yajl-2 )"

src_configure() {
	local my_plugins="ccode;dump;error;fstab;glob;hexcode;hidden;hosts;network;ni;null;path;resolver;struct;success;template;timeofday;tracer;type;validation"

	#move doc files to correct location
	sed -e "s/elektra-api/${PF}/" \
		-i cmake/ElektraCache.cmake || die

	use dbus    && my_plugins+=";dbus"
	use doc     && my_plugins+=";doc"
	use iconv   && my_plugins+=";iconv"
	use inifile && my_plugins+=";simpleini"
	use syslog  && my_plugins+=";syslog"
	use tcl     && my_plugins+=";tcl"
	use xml     && my_plugins+=";xmltool"
	use yajl    && my_plugins+=";yajl"

	local mycmakeargs=(
		"-DPLUGINS=${my_plugins}"
		"-DLATEX_COMPILER=OFF"
		$(cmake-utils_use doc BUILD_DOCUMENTATION)
		$(cmake-utils_use examples BUILD_EXAMPLES)
		$(cmake-utils_use static-libs BUILD_STATIC)
		$(cmake-utils_use test BUILD_TESTING)
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	dodoc doc/{AUTHORS,CHANGES,NEWS,README,todo/TODO}

	if use doc ; then
		rm -rf "${D}/usr/share/doc/${PF}/man" || die
		pushd ${CMAKE_BUILD_DIR}/doc/man/man3
		local my_f
		for my_f in *.3 ; do
			newman ${my_f} ${PN}-${my_f}
			elog "installed /usr/share/man/man3/${my_f} as ${PN}-${my_f}"
		done
		popd
	fi
}
