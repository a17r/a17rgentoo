# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KMNAME="akonadi"
inherit kde5

DESCRIPTION="Common Akonadi DBus interfaces and kcfg files"
HOMEPAGE="https://pim.kde.org/akonadi"

LICENSE="LGPL-2.1+"
KEYWORDS=""
SLOT="0"
IUSE=""

DEPEND="$(add_qt_dep qtdbus)"
RDEPEND=""

src_prepare() {
	cat <<-EOF > CMakeLists.txt || die
		cmake_minimum_required(VERSION 3.0)
		project(akonadi-data)
		find_package(ECM CONFIG REQUIRED)
		set(CMAKE_MODULE_PATH \${ECM_MODULE_PATH})
		include(KDEInstallDirs)
		if (IS_ABSOLUTE "\${DBUS_INTERFACES_INSTALL_DIR}")
			set(AKONADI_DBUS_INTERFACES_INSTALL_DIR "\${DBUS_INTERFACES_INSTALL_DIR}")
		else()
			set(AKONADI_DBUS_INTERFACES_INSTALL_DIR "\${CMAKE_INSTALL_PREFIX}/\${DBUS_INTERFACES_INSTALL_DIR}")
		endif()
		add_subdirectory( src/interfaces )
		install(FILES src/agentbase/resourcebase.kcfg DESTINATION \${KDE_INSTALL_KCFGDIR})
EOF

	kde5_src_prepare
}
