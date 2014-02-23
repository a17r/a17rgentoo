# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

MY_PN="Xcm"

DESCRIPTION="Tools based on libXcm, a library for colour management on X"
HOMEPAGE="http://www.freedesktop.org/wiki/OpenIcc"
SRC_URI="mirror://sourceforge/oyranos/${MY_PN}/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X doc +oyranos static-libs"

RDEPEND="=media-libs/libXcm-${PV}*
	oyranos? ( media-libs/oyranos )
	X? ( x11-libs/libXmu
		x11-libs/libXfixes
		x11-libs/libX11
		x11-proto/xproto )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_configure() {
	econf --disable-silent-rules \
		$(use_with X x11) \
		$(use_with oyranos oyranos) \
		$(use_enable static-libs static)
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
