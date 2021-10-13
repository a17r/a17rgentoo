# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Environment setting required for all KDE Frameworks apps to run"
HOMEPAGE="https://community.kde.org/Frameworks"
SRC_URI=""

LICENSE="GPL-2"
SLOT="5"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND=">=x11-misc/xdg-utils-1.1.1-r1"

S=${WORKDIR}

src_install() {
	einfo "Installing environment file..."

	cat <<-EOF >> "${T}/78kf"
CONFIG_PROTECT=${EPREFIX}/usr/share/config
GTK_USE_PORTAL=1
EOF

	doenvd "${T}/78kf"
}
