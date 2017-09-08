# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="optional"
CPPUNIT_REQUIRED="optional"
SQL_REQUIRED="always"
inherit kde4-base

DESCRIPTION="Common library for KDE PIM apps"
SRC_URI="https://dev.gentoo.org/~asturm/distfiles/${P/10_p/11_pre}.tar.xz"

KEYWORDS="~amd64 ~arm ~x86"
LICENSE="LGPL-2.1"
IUSE="akonadi debug ldap"

# some akonadi tests timeout, that probably needs more work as its ~700 tests
RESTRICT="test"

DEPEND="
	>=app-crypt/gpgme-1.8.0
	dev-libs/boost:=
	dev-libs/cyrus-sasl
	dev-libs/libgpg-error
	dev-libs/libical:=
	dev-libs/qjson
	media-libs/phonon[qt4]
	x11-misc/shared-mime-info
	akonadi? ( kde-apps/akonadi:4 )
	ldap? ( net-nds/openldap )
"
# boost is not linked to, but headers which include it are installed
# bug #418071
RDEPEND="${DEPEND}"

PATCHES=(
	# breaks veryoldpim POP3, see also: https://git.reviewboard.kde.org/r/124987/
	"${FILESDIR}/${P}-revert-544410c90.patch"
	"${FILESDIR}/${P}-build-w-recent-qt4.patch"
	"${FILESDIR}/${P}-noakonadi.patch"
	"${FILESDIR}/${P}-mailtransport-noakonadi.patch"
	"${FILESDIR}/${P}-rename-kcfg.patch"
)

S="${WORKDIR}/${P/10_p/11_pre}"

src_configure() {
	local mycmakeargs=(
		-DKDEPIM_NO_AKONADI=$(usex !akonadi)
		-DBUILD_doc=$(usex handbook)
		$(cmake-utils_use_find_package ldap Ldap)
	)

	if use akonadi; then
		mycmakeargs+=(
			-DCMAKE_DISABLE_FIND_PACKAGE_Prison=ON
			-DBUILD_TOOLS=OFF
		)
	fi

	kde4-base_src_configure
}

src_install() {
	kde4-base_src_install

	# Collides with net-im/choqok
	rm "${ED}"usr/share/apps/cmake/modules/FindQtOAuth.cmake || die

	# contains constants/defines only
	QA_DT_NEEDED="$(find "${ED}" -type f -name 'libakonadi-kabc.so.*' -printf '/%P\n')"
}
