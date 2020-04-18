# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Tools based on libXcm, a library for colour management on X"
HOMEPAGE="https://www.freedesktop.org/wiki/OpenIcc"
SRC_URI="httpss://github.com/oyranos-cms/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc +oyranos static-libs X"

BDEPEND="doc? ( app-doc/doxygen )"
RDEPEND="
	=media-libs/libXcm-${PV}*
	oyranos? ( media-libs/oyranos )
	X? (
		x11-base/xorg-proto
		x11-libs/libXmu
		x11-libs/libXfixes
		x11-libs/libX11
	)
"
DEPEND="${RDEPEND}"

src_configure() {
	local myeconfargs=(
		$(use_with oyranos oyranos)
		$(use_enable static-libs static)
		$(use_with X x11)
	)
	econf "${myeconfargs[@]}"
}

#src_compile() {
#	default
#	use doc && doxygen
#}

#src_install() {
#	default
#
#	use doc && dohtml doc/html/*
#}
