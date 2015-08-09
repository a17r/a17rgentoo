# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

COMMIT="98efb85b809215c69e878be114ce13378986195e"

inherit kde4-base vcs-snapshot

DESCRIPTION="KControl module for Oyranos CMS cross desktop settings"
HOMEPAGE="http://www.oyranos.org/wiki/index.php?title=Kolor-manager"
SRC_URI="http://quickgit.kde.org/?p=kolor-manager.git&a=snapshot&h=${COMMIT}&fmt=tgz -> ${P}.tar.gz"

LICENSE="BSD-2"
KEYWORDS=""
SLOT="4"
IUSE="debug"

DEPEND="
	media-gfx/synnefo[-qt5]
	=media-libs/oyranos-9999
	media-libs/libXcm
	x11-libs/libX11
	x11-libs/libXrandr
"
RDEPEND="${DEPEND}"
