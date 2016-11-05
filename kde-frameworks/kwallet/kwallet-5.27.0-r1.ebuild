# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit kde5

DESCRIPTION="Framework providing desktop-wide storage for passwords"
LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="gpg +man"

RDEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	dev-libs/libgcrypt:0=
	gpg? ( app-crypt/gpgme[cxx,qt5] )
"
DEPEND="${RDEPEND}
	man? ( $(add_frameworks_dep kdoctools) )
"

PATCHES=(
	"${FILESDIR}/${P}-gpgme.patch"
	"${FILESDIR}/${P}-nomoreboost.patch"
)

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package gpg Gpgmepp)
		$(cmake-utils_use_find_package man KF5DocTools)
	)
	use gpg || mycmakeargs+=( -DCMAKE_DISABLE_FIND_PACKAGE_KF5Gpgmepp=ON )

	kde5_src_configure
}

pkg_postinst() {
	if ! has_version "kde-plasma/kwallet-pam" || ! has_version "kde-apps/kwalletmanager:5" ; then
		elog
		elog "Install kde-plasma/kwallet-pam for auto-unlocking after account login."
		elog "Install kde-apps/kwalletmanager:5 to manage your kwallet."
		elog
	fi
}
