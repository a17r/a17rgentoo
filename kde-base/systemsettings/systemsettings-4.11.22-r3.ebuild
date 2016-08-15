# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_HANDBOOK="optional"
KMNAME="kde-workspace"
OPENGL_REQUIRED="optional"
VIRTUALX_REQUIRED="test"
VIRTUALDBUS_TEST="true"
inherit kde4-meta

DESCRIPTION="System settings utility"
HOMEPAGE+=" https://userbase.kde.org/System_Settings"
IUSE="debug gtk +kscreen +usb"
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"

COMMONDEPEND="
	dev-libs/glib:2
	$(add_kdebase_dep kwin)
	$(add_kdebase_dep libkworkspace)
	media-libs/fontconfig
	>=media-libs/freetype-2
	>=x11-libs/libxklavier-3.2
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXft
	x11-libs/libXi
	x11-libs/libxkbfile
	x11-libs/libXrandr
	x11-libs/libXtst
	opengl? ( virtual/opengl )
	usb? ( virtual/libusb:0 )
"
DEPEND="${COMMONDEPEND}
	x11-proto/kbproto
	x11-proto/xextproto
"
RDEPEND="${COMMONDEPEND}
	sys-libs/timezone-data
	x11-apps/setxkbmap
	x11-misc/xkeyboard-config
	gtk? ( kde-misc/kde-gtk-config )
	kscreen? ( kde-misc/kscreen:4 )
	!<kde-base/legacy-icons-4.11.22-r2
	!=kde-frameworks/oxygen-icons-5.19.0:5
	!=kde-frameworks/oxygen-icons-5.20.0:5
	!kde-base/kstyles:4
"

KMEXTRA="
	kcontrol/
	kstyles/
"
KMEXTRACTONLY="
	krunner/dbus/org.kde.krunner.App.xml
	krunner/dbus/org.kde.screensaver.xml
	ksmserver/screenlocker/dbus/org.kde.screensaver.xml
	kwin/
	libs/
	plasma/
"
# fails to connect to a kded instance
RESTRICT="test"

PATCHES=(
	"${FILESDIR}/${PN}-kcm-randr.patch"
)

src_unpack() {
	if use handbook; then
		KMEXTRA+="
			doc/kcontrol
			doc/kfontview
		"
	fi

	kde4-meta_src_unpack
}

src_prepare() {
	eapply "${FILESDIR}/${P}-strigi-removal.patch"

	sed -i -e 's/systemsettingsrc DESTINATION ${SYSCONF_INSTALL_DIR}/systemsettingsrc DESTINATION ${CONFIG_INSTALL_DIR}/' \
		systemsettings/CMakeLists.txt \
		|| die "Failed to fix systemsettingsrc install location"

	cat <<-EOF > kstyles/oxygen/config/CMakeLists.txt || die
include_directories( \${KDE4_KDEUI_INCLUDES} )
set( oxygen_settings_SOURCES oxygenconfigdialog.cpp main.cpp)
kde4_add_executable( oxygen-settings \${oxygen_settings_SOURCES} )
target_link_libraries( oxygen-settings \${KDE4_KDEUI_LIBS} \${QT_QTCORE_LIBRARY} \${QT_QTGUI_LIBRARY})
install (TARGETS oxygen-settings \${INSTALL_TARGETS_DEFAULT_ARGS} )
EOF

	cat <<-EOF > kstyles/oxygen/CMakeLists.txt
project(kstyle-oxygen)
add_subdirectory( config )
EOF

	kde4-meta_src_prepare
}

# FIXME: is have_openglxvisual found without screensaver
src_configure() {
	# Old keyboard-detection code is unmaintained,
	# so we force the new stuff, using libxklavier.
	local mycmakeargs=(
		-DUSE_XKLAVIER=ON
		-DWITH_LibXKlavier=ON
		-DWITH_GLIB2=ON
		-DWITH_GObject=ON
		-DBUILD_KCM_RANDR=$(usex !kscreen)
		-DWITH_OpenGL=$(usex opengl)
		-DWITH_USB=$(usex usb)
	)

	kde4-meta_src_configure
}
