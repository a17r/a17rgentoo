# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Qt5 documentation, for use with Qt Creator and other tools"
HOMEPAGE="https://doc.qt.io/"
SRC_URI=""

LICENSE="metapackage"
SLOT="5"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND=">=dev-qt/qtcore-${PV}:5[doc]"

pkg_postinst() {
	elog "With 5.12.4, Qt documentation was split into individual tarballs upstream."
	elog "Qt packages from now on provide USE doc where available."
	elog "This is a transitional package that will be removed after 5.12.5."
}
