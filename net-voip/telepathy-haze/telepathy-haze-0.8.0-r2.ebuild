# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
inherit autotools python-any-r1

DESCRIPTION="Telepathy connection manager providing libpurple supported protocols"
HOMEPAGE="https://telepathy.freedesktop.org https://developer.pidgin.im/wiki/TelepathyHaze"
SRC_URI="https://telepathy.freedesktop.org/releases/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
RESTRICT="test"

BDEPEND="${PYTHON_DEPS}
	dev-libs/libxslt
	dev-util/glib-utils
	virtual/pkgconfig
"
RDEPEND="
	>=dev-libs/dbus-glib-0.73
	>=dev-libs/glib-2.30:2
	>=net-im/pidgin-2.7[dbus]
	>=net-libs/telepathy-glib-0.15.1
"
DEPEND="${RDEPEND}"

PATCHES=(
	# contact-list: Don't crash if a contact is already in the roster
	# (fixed in next version)
	"${FILESDIR}"/${P}-crash.patch

	# Fix compat with newer pidgin versions, bug #572296
	"${FILESDIR}"/${P}-pidgin-2.10.12-compat.patch
	
	"${FILESDIR}"/${P}-disable-tests.patch # bug #728960
	"${FILESDIR}"/${P}-tools-py3.patch # bug #714636
)

src_prepare() {
	default
	eautoreconf

	# Disable failing test
	sed -i 's|simple-caps.py||' -i tests/twisted/Makefile.{am,in} || die
}
