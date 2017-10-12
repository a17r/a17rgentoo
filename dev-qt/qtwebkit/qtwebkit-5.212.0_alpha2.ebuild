# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CMAKE_MAKEFILE_GENERATOR="ninja"
PYTHON_COMPAT=( python2_7 )
QT_MIN_VER="5.9.2:5" # Minimum Qt version
USE_RUBY="ruby22 ruby23 ruby24"
inherit check-reqs cmake-utils flag-o-matic python-any-r1 qmake-utils ruby-single toolchain-funcs

DESCRIPTION="Open source web browser engine"
HOMEPAGE="https://www.qt.io/"
SRC_URI="https://github.com/annulen/webkit/releases/download/${P/_/-}/${P/_/-}.tar.xz"

SLOT=5

LICENSE="LGPL-2+ BSD"
KEYWORDS="~amd64 ~x86"

IUSE="+geolocation +gstreamer +hyphen +jit multimedia nsplugin opengl orientation +printsupport qml +webp X"

REQUIRED_USE="
	nsplugin? ( X )
	qml? ( opengl )
	?? ( gstreamer multimedia )
"

# Dependencies found at Source/cmake/OptionsQt.cmake
RDEPEND="
	dev-db/sqlite:3
	dev-libs/icu:=
	dev-libs/libxml2:2
	dev-libs/libxslt
	>=dev-qt/qtcore-${QT_MIN_VER}=[icu]
	>=dev-qt/qtgui-${QT_MIN_VER}
	>=dev-qt/qtnetwork-${QT_MIN_VER}
	>=dev-qt/qtwidgets-${QT_MIN_VER}
	media-libs/libpng:0=
	media-libs/libwebp:=
	virtual/jpeg:0
	geolocation? ( >=dev-qt/qtpositioning-${QT_MIN_VER} )
	gstreamer? (
		dev-libs/glib:2
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
		media-libs/gst-plugins-bad:1.0
	)
	hyphen? ( dev-libs/hyphen )
	multimedia? ( >=dev-qt/qtmultimedia-${QT_MIN_VER}[widgets] )
	opengl? ( >=dev-qt/qtopengl-${QT_MIN_VER} )
	orientation? ( >=dev-qt/qtsensors-${QT_MIN_VER} )
	printsupport? ( >=dev-qt/qtprintsupport-${QT_MIN_VER} )
	qml? (
		>=dev-qt/qtdeclarative-${QT_MIN_VER}
		>=dev-qt/qtwebchannel-${QT_MIN_VER}[qml]
	)
	X? (
		x11-libs/libX11
		x11-libs/libXcomposite
		x11-libs/libXrender
	)
"

# Need real bison, not yacc
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	${RUBY_DEPS}
	>=dev-lang/perl-5.10
	dev-util/gperf
	>=sys-devel/bison-2.4.3
	sys-devel/flex
	virtual/pkgconfig
"

S="${WORKDIR}/${P/_/-}"

CHECKREQS_DISK_BUILD="1G" # Debug build requires much more see bug #417307

pkg_pretend() {
	if [[ ${MERGE_TYPE} != "binary" ]] ; then
		if is-flagq "-g*" && ! is-flagq "-g*0" ; then
			einfo "Checking for sufficient disk space to build ${PN} with debugging CFLAGS"
			check-reqs_pkg_pretend
		fi
	fi
}

pkg_setup() {
	if [[ ${MERGE_TYPE} != "binary" ]] && is-flagq "-g*" && ! is-flagq "-g*0" ; then
		check-reqs_pkg_setup
	fi

	python-any-r1_pkg_setup
}

src_configure() {
	# Respect CC, otherwise fails on prefix #395875
	tc-export CC

	# older glibc needs this for INTPTR_MAX, bug #533976
	if has_version "<sys-libs/glibc-2.18" ; then
		append-cppflags "-D__STDC_LIMIT_MACROS"
	fi

	# Multiple rendering bugs on youtube, github, etc without this, bug #547224
	append-flags $(test-flags -fno-strict-aliasing)

	local ruby_interpreter=""

	if has_version "virtual/rubygems[ruby_targets_ruby24]"; then
		ruby_interpreter="-DRUBY_EXECUTABLE=$(type -P ruby24)"
	elif has_version "virtual/rubygems[ruby_targets_ruby23]"; then
		ruby_interpreter="-DRUBY_EXECUTABLE=$(type -P ruby23)"
	else
		ruby_interpreter="-DRUBY_EXECUTABLE=$(type -P ruby22)"
	fi

	local mycmakeargs=(
		-DENABLE_API_TESTS=OFF
		-DENABLE_GEOLOCATION=$(usex geolocation)
		-DUSE_GSTREAMER=$(usex gstreamer)
		-DENABLE_JIT=$(usex jit)
		-DUSE_QT_MULTIMEDIA=$(usex multimedia)
		-DENABLE_NETSCAPE_PLUGIN_API=$(usex nsplugin)
		-DENABLE_OPENGL=$(usex opengl)
		-DENABLE_DEVICE_ORIENTATION=$(usex orientation)
		-DENABLE_WEBKIT2=$(usex qml)
		-DENABLE_X11_TARGET=$(usex X)
		-DCMAKE_BUILD_TYPE=Release
		-DPORT=Qt
		${ruby_interpreter}
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install

	# bug 572056
	if [[ ! -f ${D%/}$(qt5_get_libdir)/libQt5WebKit.so ]]; then
		eerror "${CATEGORY}/${PF} could not build due to a broken ruby environment."
		die 'Check "eselect ruby" and ensure you have a working ruby in your $PATH'
	fi
}
