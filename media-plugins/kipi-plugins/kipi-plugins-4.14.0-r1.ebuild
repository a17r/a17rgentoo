# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

OPENGL_REQUIRED="optional"
KDE_HANDBOOK="optional"
KDE_LINGUAS="ar be bg bs ca cs da de el en_GB eo es et eu fi fr ga gl he hi hr
hu id is it ja km ko lt lv ms nb nds nl nn oc pa pl pt pt_BR ro ru se sk sl sq
sv th tr uk zh_CN zh_TW"
inherit flag-o-matic kde4-base

MY_PV=${PV/_/-}
MY_P="digikam-${MY_PV}"

DESCRIPTION="Plugins for the KDE Image Plugin Interface"
HOMEPAGE="http://www.digikam.org/"
SRC_URI="mirror://kde/stable/digikam/${MY_P}.tar.bz2"

LICENSE="GPL-2
	handbook? ( FDL-1.2 )"
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="cdr calendar crypt debug expoblending gpssync +imagemagick ipod mediawiki panorama redeyes scanner upnp videoslideshow vkontakte"

COMMONDEPEND="
	$(add_kdebase_dep kdelibs)
	kde-apps/libkipi:4
	kde-apps/libkdcraw:4=
	kde-apps/libkexiv2:4=
	dev-libs/expat
	dev-libs/kqoauth
	dev-libs/libxml2
	dev-libs/libxslt
	dev-libs/qjson
	dev-qt/qtxmlpatterns:4
	gpssync? ( kde-apps/libkgeomap:4 )
	media-libs/libpng:0=
	media-libs/tiff:0
	virtual/jpeg:0
	calendar? ( $(add_kdeapps_dep kdepimlibs) )
	crypt? ( app-crypt/qca:2[qt4(+)] )
	ipod? (
		media-libs/libgpod
		x11-libs/gtk+:2
	)
	mediawiki? ( >=net-libs/libmediawiki-3.0.0:4 )
	opengl? (
		media-libs/phonon[qt4]
		x11-libs/libXrandr
	)
	redeyes? ( media-libs/opencv:=[contrib(+)] )
	scanner? (
		$(add_kdeapps_dep libksane)
		media-gfx/sane-backends
	)
	upnp? ( media-libs/herqq )
	videoslideshow?	(
		>=media-libs/qt-gstreamer-0.9.0[qt4(+)]
		|| ( media-gfx/imagemagick media-gfx/graphicsmagick[imagemagick] )
	)
	vkontakte? ( >=net-libs/libkvkontakte-4.12.0:4 )
"
DEPEND="${COMMONDEPEND}
	sys-devel/gettext
	panorama? (
		sys-devel/bison
		sys-devel/flex
	)
"
RDEPEND="${COMMONDEPEND}
	cdr? ( app-cdr/k3b )
	expoblending? ( media-gfx/hugin )
	imagemagick? ( || ( media-gfx/imagemagick media-gfx/graphicsmagick[imagemagick] ) )
	panorama? (
		media-gfx/enblend
		>=media-gfx/hugin-2011.0.0
	)
"

S=${WORKDIR}/${MY_P}/extra/${PN}

RESTRICT=test
# bug 420203

PATCHES=(
	"${FILESDIR}/${PN}-4.6.0-options.patch"
	"${FILESDIR}/${PN}-4.10.0-jpeg.patch"
)

src_prepare() {
	# prepare the handbook
	mv "${WORKDIR}/${MY_P}/doc/${PN}" "${WORKDIR}/${MY_P}/extra/${PN}/doc" || die
	if use handbook; then
		echo "add_subdirectory( doc )" >> CMakeLists.txt || die
	fi

	# prepare the translations
	mv "${WORKDIR}/${MY_P}/po" po || die
	find po -name "*.po" -and -not -name "kipiplugin*.po" -delete || die
	echo "find_package(Msgfmt REQUIRED)" >> CMakeLists.txt || die
	echo "find_package(Gettext REQUIRED)" >> CMakeLists.txt || die
	echo "add_subdirectory( po )" >> CMakeLists.txt || die

	if ! use redeyes ; then
		sed -i -e "/DETECT_OPENCV/d" CMakeLists.txt || die
	fi

	kde4-base_src_prepare
}

src_configure() {
	# Remove flags -floop-block -floop-interchange
	# -floop-strip-mine due to bug #305443.
	filter-flags -floop-block
	filter-flags -floop-interchange
	filter-flags -floop-strip-mine

	mycmakeargs+=(
		-DENABLE_OPENCV3=$(has_version ">=media-libs/opencv-3" && echo yes || echo no)
		-DWITH_GLIB2=$(usex ipod)
		-DWITH_GObject=$(usex ipod)
		-DWITH_Gdk=$(usex ipod)
		-DWITH_Ipod=$(usex ipod)
		-DWITH_KdepimLibs=$(usex calendar)
		-DWITH_KGeoMap=$(usex gpssync)
		-DWITH_Mediawiki=$(usex mediawiki)
		$(cmake-utils_use_find_package redeyes OpenCV)
		-DWITH_OpenGL=$(usex opengl)
		-DWITH_QCA2=$(usex crypt)
		-DWITH_KSane=$(usex scanner)
		-DWITH_Hupnp=$(usex upnp)
		-DWITH_LibKVkontakte=$(usex vkontakte)
		-DWITH_QtGStreamer=$(usex videoslideshow)
		-DENABLE_expoblending=$(usex expoblending)
		-DENABLE_panorama=$(usex panorama)
	)

	kde4-base_src_configure
}
