# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_COMMIT=68f420ebdfb226e3d0c09ebed06d5454cc6c3a7f
inherit qt5-build

DESCRIPTION="Translation files for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
	SRC_URI="
	pre-generated? (
		https://dev.gentoo.org/~asturm/distfiles/${P}-${KDE_ORG_COMMIT:0:8}-qm.tar.xz
	) !pre-generated? (
		https://invent.kde.org/qt/qt/${PN}/-/archive/${KDE_ORG_COMMIT}/${P}-${KDE_ORG_COMMIT:0:8}.tar.gz
	)"
fi

IUSE="+pre-generated"

DEPEND="!pre-generated? ( =dev-qt/qtcore-${QT5_PV}* )"
BDEPEND="!pre-generated? ( =dev-qt/linguist-tools-${QT5_PV}* )"

src_install() {
	if use !pre-generated; then
		qt5_foreach_target_subdir emake INSTALL_ROOT="${D}" install
		pushd "${D}" || die
			tar -cJf ${P}-${KDE_ORG_COMMIT:0:8}-qm.tar.xz "${D}" || die
		popd || die
	else
		doins "${S}"
	fi
}
