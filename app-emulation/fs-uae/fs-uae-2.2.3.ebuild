# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Amiga emulator based on WinUAE emulation code"
HOMEPAGE="http://fs-uae.net/"
SRC_URI="http://fs-uae.net/fs-uae/stable/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-libs/libsdl-1.2[joystick,opengl,X]
	media-libs/openal
	media-libs/libpng
	dev-libs/glib:2
	sys-libs/zlib
	media-libs/freetype:2"
RDEPEND="${DEPEND}"
