# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit kde4-base

DESCRIPTION="KCM module for SDDM - Simple Desktop Display Manager"
HOMEPAGE="https://github.com/sddm/sddm-kcm"
EGIT_REPO_URI="git://github.com/sddm/sddm-kcm.git"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="x11-misc/sddm
	dev-qt/qtdeclarative:4"
RDEPEND="${DEPEND}"
