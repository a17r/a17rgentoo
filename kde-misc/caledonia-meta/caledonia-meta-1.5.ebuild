# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Merge this to pull in all Caledonia related packages"
HOMEPAGE="http://caledonia.sourceforge.net/get.html"
KEYWORDS=" ~amd64 ~x86"
SLOT=0

RDEPEND="=kde-misc/caledonia-colorscheme-${PV}
	=kde-misc/caledonia-kdmtheme-${PV}
	=kde-misc/caledonia-ksplash-${PV}
	=kde-misc/caledonia-plasmatheme-${PV}
	=kde-misc/caledonia-wallpapers-${PV}
	"
