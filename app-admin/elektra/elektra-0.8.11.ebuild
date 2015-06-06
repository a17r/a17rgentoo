# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-multilib eutils java-pkg-opt-2

DESCRIPTION="Universal and secure framework to store config parameters in a hierarchical key-value pair mechanism"
HOMEPAGE="http://freedesktop.org/wiki/Software/Elektra"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://github.com/ElektraInitiative/libelektra.git"
	inherit git-2
	SRC_URI=""
	#KEYWORDS=""
else
	SRC_URI="ftp://ftp.markus-raab.org/${PN}/releases/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="BSD"
SLOT="0"
PLUGIN_IUSE="augeas iconv ini java simpleini syslog systemd tcl +uname xml yajl";
IUSE="dbus doc examples qt5 static-libs test ${PLUGIN_IUSE}"

RDEPEND="dev-libs/libltdl:0[${MULTILIB_USEDEP}]
	>=dev-libs/libxml2-2.9.1-r4[${MULTILIB_USEDEP}]
	augeas? ( app-admin/augeas )
	dbus? ( >=sys-apps/dbus-1.6.18-r1[${MULTILIB_USEDEP}] )
	iconv? ( >=virtual/libiconv-0-r1[${MULTILIB_USEDEP}] )
	java? ( >=virtual/jdk-1.8.0 )
	qt5? (
		>=dev-qt/qtdeclarative-5.3
		>=dev-qt/qtgui-5.3
		>=dev-qt/qttest-5.3
		>=dev-qt/qtwidgets-5.3
	)
	uname? ( sys-apps/coreutils )
	systemd? ( virtual/udev[systemd] )
	yajl? ( >=dev-libs/yajl-1.0.11-r1[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	test? ( >=dev-cpp/gtest-1.7.0 )
"

DOCS="README.md doc/AUTHORS doc/CODING.md doc/NEWS.md doc/todo/TODO"
# tries to write to user's home directory (and doesn't respect HOME)
RESTRICT="test"

MULTILIB_WRAPPED_HEADERS=( /usr/include/elektra/kdbconfig.h )

src_prepare() {

	epatch "${FILESDIR}/${PN}-0.8.8-conditional-glob-tests.patch"

	einfo remove bundled libs
	# TODO: Remove bundled inih from src/plugins/ini (add to portage):
	# https://code.google.com/p/inih/
	rm -rf src/external || die

	# move doc files to correct location
	sed -e "s/elektra-api/${PF}/" \
		-i cmake/ElektraCache.cmake || die

	cmake-utils_src_prepare
}

multilib_src_configure() {
	local my_plugins="ALL"

	if use augeas ; then
		multilib_is_native_abi || my_plugins+=";-augeas"	# no multilib ebuild available
	else
		my_plugins+=";-augeas"
	fi
	use dbus      || my_plugins+=";-dbus"
	use iconv     || my_plugins+=";-iconv"
	use ini       || my_plugins+=";-ini"		# bundles inih
	use simpleini || my_plugins+=";-simpleini"
	use syslog    || my_plugins+=";-syslog"
	use systemd   || my_plugins+=";-journald"
	use tcl       || my_plugins+=";-tcl"
	use uname     || my_plugins+=";-uname"
	use xml       || my_plugins+=";-xmltool"
	use yajl      || my_plugins+=";-yajl"
	use java      || my_plugins+=";-jni"

	# Disabled for good (?):
	# counter - Only useful for debugging the plugin framework
	# doc - Documentation explaining the basic makeup of a function // bug #514402;
	# noresolver - Does not resolve, but can act as one
	# template - Template for new plugin written in C
	# wresolver - Resolver for non-POSIX, e.g. w32/w64 systems
	my_plugins+=";-counter;-doc;-noresolver;-template;-wresolver"

	local my_tools="kdb"

	use qt5 && multilib_is_native_abi && my_tools+=";qt-gui"

	mycmakeargs=(
		"-DBUILD_SHARED=ON"
		"-DPLUGINS=${my_plugins}"
		"-DTOOLS=${my_tools}"
		"-DLATEX_COMPILER=OFF"
		"-DTARGET_CMAKE_FOLDER=share/cmake/Modules"
		$(multilib_is_native_abi && cmake-utils_use doc BUILD_DOCUMENTATION \
			|| echo -DBUILD_DOCUMENTATION=OFF)
		$(multilib_is_native_abi && cmake-utils_use examples BUILD_EXAMPLES \
			|| echo -DBUILD_EXAMPLES=OFF)
		$(cmake-utils_use static-libs BUILD_STATIC)
		$(cmake-utils_use test BUILD_TESTING)
		$(cmake-utils_use test ENABLE_TESTING)
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	einfo remove test_data
	rm -rvf "${D}/usr/share/${PN}" || die "Failed to remove test_data"
}
