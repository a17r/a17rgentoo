# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_COMMIT=19ae816330924f595be812a36dc3ed2a1e2aa29a
QT5_MODULE="qtconnectivity"
inherit qt5-build

DESCRIPTION="Bluetooth support library for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
fi

IUSE="qml"

RDEPEND="
	=dev-qt/qtconcurrent-${QT5_PV}*
	=dev-qt/qtcore-${QT5_PV}*:5=
	=dev-qt/qtdbus-${QT5_PV}*
	>=net-wireless/bluez-5:=
	qml? ( =dev-qt/qtdeclarative-${QT5_PV}* )
"
DEPEND="${RDEPEND}
	=dev-qt/qtnetwork-${QT5_PV}*
"

src_prepare() {
	sed -i -e 's/nfc//' src/src.pro || die

	qt_use_disable_mod qml quick src/src.pro

	qt5-build_src_prepare
}
