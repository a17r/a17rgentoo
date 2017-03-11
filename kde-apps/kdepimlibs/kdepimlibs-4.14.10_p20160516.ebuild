# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="optional"
CPPUNIT_REQUIRED="optional"
BASE_TARBALL="${PN}-4.14.11_pre20160211"
PATCHSET="${PN}-4.14.11_pre20160516"
inherit kde4-base

DESCRIPTION="Common library for KDE PIM apps"
COMMIT_ID="a791b69599c3571ff2f4b1cc9033d8fb30f1bc33"
SRC_URI="https://quickgit.kde.org/?p=kdepimlibs.git&a=snapshot&h=${COMMIT_ID}&fmt=tgz -> ${BASE_TARBALL}.tar.gz
	https://dev.gentoo.org/~asturm/${PATCHSET}.tar.xz
"
S=${WORKDIR}/${PN}

KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
LICENSE="LGPL-2.1"
IUSE="debug ldap prison"

# some akonadi tests timeout, that probaly needs more work as its ~700 tests
RESTRICT="test"

DEPEND="
	>=app-crypt/gpgme-1.8.0
	>=dev-libs/boost-1.35.0-r5:=
	dev-libs/cyrus-sasl
	dev-libs/libgpg-error
	>=dev-libs/libical-0.48-r2:=
	>=dev-libs/qjson-0.8.1
	kde-apps/akonadi:4
	media-libs/phonon[qt4]
	x11-misc/shared-mime-info
	ldap? ( net-nds/openldap )
	prison? ( kde-frameworks/prison:4 )
"
# boost is not linked to, but headers which include it are installed
# bug #418071
RDEPEND="${DEPEND}"

PATCHES=(
	"${WORKDIR}/${PATCHSET}"
	"${FILESDIR}/${P}-revert-544410c90.patch" # breaks veryoldpim POP3
	# see also: https://git.reviewboard.kde.org/r/124987/
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_TOOLS=OFF
		-DBUILD_doc=$(usex handbook)
		$(cmake-utils_use_find_package ldap Ldap)
		$(cmake-utils_use_find_package prison Prison)
	)

	kde4-base_src_configure
}

src_install() {
	kde4-base_src_install

	# Collides with net-im/choqok
	rm "${ED}"usr/share/apps/cmake/modules/FindQtOAuth.cmake || die

	# contains constants/defines only
	QA_DT_NEEDED="$(find "${ED}" -type f -name 'libakonadi-kabc.so.*' -printf '/%P\n')"
}
