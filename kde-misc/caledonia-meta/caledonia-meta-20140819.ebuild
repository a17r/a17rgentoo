# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Merge this to pull in all Caledonia Suite packages"
HOMEPAGE="http://caledonia.sourceforge.net/get.html"
LICENSE="metapackage"
KEYWORDS="~amd64 ~x86"
SLOT=0

IUSE="+kdmtheme"

RDEPEND="=kde-misc/caledonia-colorscheme-20121121
	=kde-misc/caledonia-ksplash-1.3
	=kde-misc/caledonia-plasmatheme-1.9
	=kde-misc/caledonia-wallpapers-1.5
	kdmtheme? ( =kde-misc/caledonia-kdmtheme-1.3 )"
