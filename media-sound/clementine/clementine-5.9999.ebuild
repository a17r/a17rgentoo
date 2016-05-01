# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

EGIT_BRANCH="qt5"
KDE_TEST="forceoptional"
QT_MINIMAL="5.5.1"
VIRTUALX_REQUIRED="test"
inherit kde5 flag-o-matic
[[ ${PV} == *9999* ]] && \
EGIT_REPO_URI="https://github.com/clementine-player/Clementine.git"

DESCRIPTION="A modern music player and library organizer based on Amarok 1.4 and Qt5"
HOMEPAGE="http://www.clementine-player.org https://github.com/clementine-player/Clementine"
[[ ${PV} == *9999* ]] || \
SRC_URI="https://github.com/clementine-player/Clementine/archive/${PV/_}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
[[ ${PV} == *9999* ]] || \
KEYWORDS="~amd64 ~x86"
IUSE="amazoncloud box cdda +dbus dropbox googledrive ipod lastfm mms moodbar mtp projectm pulseaudio skydrive +udisks vkontakte webkit wiimote X"

LANGS=" af ar be bg bn br bs ca cs cy da de el en_CA en_GB eo es et eu fa fi fr ga gl he he_IL hi hr hu hy ia id is it ja ka kk ko lt lv mr ms my nb nl oc pa pl pt pt_BR ro ru si_LK sk sl sr sr@latin sv te tr tr_TR uk uz vi zh_CN zh_TW"
IUSE+="${LANGS// / linguas_}"

REQUIRED_USE="
	udisks? ( dbus )
	wiimote? ( dbus )
"

COMMON_DEPEND="
	$(add_qt_dep linguist-tools)
	$(add_qt_dep qtconcurrent)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtopengl)
	$(add_qt_dep qtsql 'sqlite')
	$(add_qt_dep qttranslations)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	app-crypt/qca:2[qt5]
	dev-db/sqlite:=
	dev-libs/crypto++
	>=dev-libs/glib-2.24.1-r1
	dev-libs/libxml2
	dev-libs/protobuf:=
	media-libs/chromaprint
	media-libs/gst-plugins-base:1.0
	media-libs/gstreamer:1.0
	media-libs/libechonest[qt5]
	media-libs/libmygpo-qt[qt5]
	media-libs/taglib[mp4]
	sys-libs/zlib
	x11-libs/libX11
	virtual/glu
	virtual/opengl
	cdda? ( dev-libs/libcdio )
	dbus? ( $(add_qt_dep qtdbus) )
	ipod? ( media-libs/libgpod )
	lastfm? ( media-libs/liblastfm[qt5] )
	moodbar? ( sci-libs/fftw:3.0 )
	mtp? ( media-libs/libmtp )
	projectm? (
		media-libs/glew:=
		media-libs/libprojectm
	)
	webkit? ( $(add_qt_dep qtwebkit) )
	X? ( $(add_qt_dep qtx11extras) )
"
DEPEND="${COMMON_DEPEND}
	dev-cpp/gmock
	dev-libs/boost
	sys-devel/gettext
	virtual/pkgconfig
	amazoncloud? ( dev-cpp/sparsehash )
	box? ( dev-cpp/sparsehash )
	dropbox? ( dev-cpp/sparsehash )
	googledrive? ( dev-cpp/sparsehash )
	pulseaudio? ( media-sound/pulseaudio )
	skydrive? ( dev-cpp/sparsehash )
	test? ( gnome-base/gsettings-desktop-schemas )
"
# Note: sqlite driver of dev-qt/qtsql is bundled, so no sqlite use is required; check if this can be overcome someway;
# Libprojectm-1.2 seams to work fine, so no reasons to use bundled version; check the clementine's patches:
# https://github.com/clementine-player/Clementine/tree/master/3rdparty/libprojectm/patches
# Still possibly essential but not applied yet patches are:
# 06-fix-numeric-locale.patch
# 08-stdlib.h-for-rand.patch
RDEPEND="${COMMON_DEPEND}
	!media-sound/clementine:0
	media-plugins/gst-plugins-meta:1.0
	media-plugins/gst-plugins-soup:1.0
	media-plugins/gst-plugins-taglib:1.0
	mms? ( media-plugins/gst-plugins-libmms:1.0 )
	mtp? ( gnome-base/gvfs )
	udisks? ( sys-fs/udisks:2 )
"

MY_P="${P/_}"
[[ ${PV} == *9999* ]] || \
S="${WORKDIR}/${MY_P^}"

src_prepare() {
	# some tests fail or hang
	sed -i \
		-e '/add_test_file(translations_test.cpp/d' \
		tests/CMakeLists.txt || die
	# upstream sets minimum 5.6.0 for no apparent reason
	sed -i \
		-e ':set(QT_MIN_VERSION: s:5.6.0:5.5.0:' \
		CMakeLists.txt

	kde5_src_prepare
}

src_configure() {
	local langs
	for x in ${LANGS}; do
		use linguas_${x} && langs+=" ${x}"
	done

	# spotify is not in portage
	local mycmakeargs=(
		$(cmake-utils_use_find_package webkit Qt5WebkitWidgets)
		$(cmake-utils_use_find_package X Qt5X11Extras)
		-DBUILD_WERROR=OFF
		# -DLINGUAS="${langs}"
		-DLINGUAS="None"	# disable until fixed upstream
		-DENABLE_AMAZON_CLOUD_DRIVE=$(usex amazoncloud)
		-DENABLE_AUDIOCD=$(usex cdda)
		-DENABLE_BOX=$(usex box)
		-DENABLE_DBUS=$(usex dbus)
		-DENABLE_DEVICEKIT=$(usex udisks)
		-DENABLE_DROPBOX=$(usex dropbox)
		-DENABLE_GIO=ON
		-DENABLE_GOOGLE_DRIVE=$(usex googledrive)
		-DENABLE_LIBGPOD=$(usex ipod)
		-DENABLE_LIBLASTFM=$(usex lastfm)
		-DENABLE_LIBMTP=$(usex mtp)
		-DENABLE_LIBPULSE=$(usex pulseaudio)
		-DENABLE_MOODBAR=$(usex moodbar)
		-DENABLE_SKYDRIVE=$(usex skydrive)
		-DENABLE_VISUALISATIONS=$(usex projectm)
		-DENABLE_VK=$(usex vkontakte)
		-DENABLE_WIIMOTEDEV=$(usex wiimote)
		-DENABLE_SPOTIFY_BLOB=OFF
		-DENABLE_BREAKPAD=OFF  #< disable crash reporting
		-DUSE_BUILTIN_TAGLIB=OFF
		-DUSE_SYSTEM_GMOCK=ON
		-DUSE_SYSTEM_PROJECTM=ON
		-DBUNDLE_PROJECTM_PRESETS=OFF
		# force to find crypto++ see bug #548544
		-DCRYPTOPP_LIBRARIES="crypto++"
		-DCRYPTOPP_FOUND=ON
	)

	use !debug && append-cppflags -DQT_NO_DEBUG_OUTPUT

	kde5_src_configure
}
