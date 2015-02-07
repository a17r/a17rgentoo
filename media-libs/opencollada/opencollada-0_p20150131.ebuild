# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils multilib cmake-utils vcs-snapshot

DESCRIPTION="Stream based read/write library for COLLADA files"
HOMEPAGE="http://www.opencollada.org/"
COMMIT="ceb409cabdccda3000aa2e5c065850b8fde60b0f"
SRC_URI="https://github.com/KhronosGroup/OpenCOLLADA/tarball/${COMMIT} -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="expat"

RDEPEND="dev-libs/libpcre
	dev-libs/zziplib
	media-libs/lib3ds
	sys-libs/zlib
	>=sys-devel/gcc-4.7
	expat? ( dev-libs/expat )
	!expat? ( dev-libs/libxml2 )"
DEPEND="${RDEPEND}
	sys-apps/findutils
	sys-apps/sed"

BUILD_DIR="${S}"/build

src_prepare() {
	# Remove some bundled dependencies
	edos2unix CMakeLists.txt || die
	epatch "${FILESDIR}"/${PN}-0_p864-expat.patch
	rm -R Externals/{expat,lib3ds,LibXML,pcre,zlib,zziplib} || die
	ewarn "$(echo "Remaining bundled dependencies:";
		find Externals -mindepth 1 -maxdepth 1 -type d | sed 's|^|- |')"

	# Remove unused build systems
	rm Makefile scripts/{unixbuild.sh,vcproj2cmake.rb} || die
	find "${S}" -name SConscript -delete || die
}

src_configure() {
	local mycmakeargs=" -DUSE_SHARED=ON -DUSE_STATIC=OFF"

	# Master CMakeLists.txt says "EXPAT support not implemented"
	# Something like "set(LIBEXPAT_LIBRARIES expat)" is missing to make it build
	use expat \
		&& mycmakeargs+=' -DUSE_EXPAT=ON -DUSE_LIBXML=OFF' \
		|| mycmakeargs+=' -DUSE_EXPAT=OFF -DUSE_LIBXML=ON'
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	if [[ $(get_libdir) != 'lib' ]]; then
		mv "${D}"/usr/{lib,$(get_libdir)} || die
	fi

	dodir /etc/env.d || die
	echo "LDPATH=/usr/$(get_libdir)/opencollada" \
			> "${D}"/etc/env.d/99opencollada || die

	dobin build/bin/OpenCOLLADAValidator || die

	local l
	cd "${D}"/usr/$(get_libdir)/opencollada || die
	for l in lib{Open,Gen}*.so; do
		dosym opencollada/${l} /usr/$(get_libdir)/${l}
	done
}
