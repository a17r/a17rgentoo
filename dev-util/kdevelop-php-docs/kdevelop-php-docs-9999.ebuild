# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

KDE_LINGUAS="ca ca@valencia da de en_GB es et fi fr gl it nb nds nl pl pt pt_BR
ru sv uk zh_CN zh_TW"
KMNAME="kdevelop"
KMMODULE="php-docs"
KDE_SCM="git"
EGIT_REPONAME="kdev-php-docs"

inherit kde4-base

DESCRIPTION="PHP documentation plugin for KDevelop 4"
LICENSE="GPL-2 LGPL-2"
IUSE="debug"

if [[ $PV == *9999* ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi

RDEPEND="
	!=dev-util/kdevelop-plugins-1.0.0
"
