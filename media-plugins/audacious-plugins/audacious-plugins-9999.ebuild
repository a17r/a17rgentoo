# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit git-2
use qt5 && inherit multilib

DESCRIPTION="Audacious Player - Your music, your way, no exceptions"
HOMEPAGE="http://audacious-media-player.org/"
SRC_URI=""
EGIT_REPO_URI="git://github.com/audacious-media-player/${PN}.git"

LICENSE="BSD filewriter? ( GPL-2+ ) libnotify? ( GPL-3+ ) pulseaudio? ( GPL-2+ ) sndfile? ( GPL-2+ ) spectrum? ( GPL-2+ )"
SLOT="0"
KEYWORDS=""
IUSE="aac adplug alsa bs2b cdda cue ffmpeg filewriter flac gnome gtk
      jack lame libav libnotify libsamplerate lirc midi mms mp3 nls
      pulseaudio -qt5 scrobbler sdl sid sndfile soxr spectrum vorbis wavpack"
REQUIRED_USE=" ffmpeg? ( !libav ) qt5? ( !filewriter !spectrum )"

RDEPEND="app-arch/unzip
	>=dev-libs/dbus-glib-0.60
	dev-libs/libxml2:2
	media-libs/libmodplug
	~media-sound/audacious-9999
	>=net-libs/neon-0.26.4
	( || ( >=dev-libs/glib-2.32.2 dev-util/gdbus-codegen ) )
	aac? ( >=media-libs/faad2-2.7 )
	adplug? ( >=dev-cpp/libbinio-1.4 )
	alsa? ( >=media-libs/alsa-lib-1.0.16 )
	bs2b? ( media-libs/libbs2b )
	cdda? ( >=media-libs/libcddb-1.2.1
		|| ( dev-libs/libcdio-paranoia <dev-libs/libcdio-0.90[-minimal] ) )
	cue? ( media-libs/libcue )
	ffmpeg? ( >=virtual/ffmpeg-0.7.3 )
	flac? ( >=media-libs/libvorbis-1.0
		>=media-libs/flac-1.2.1-r1 )
	gtk? ( x11-libs/gtk+:3 )
	jack? ( >=media-libs/bio2jack-0.4
		media-sound/jack-audio-connection-kit )
	lame? ( media-sound/lame )
	libnotify? ( x11-libs/libnotify )
	libsamplerate? ( media-libs/libsamplerate )
	lirc? ( app-misc/lirc )
	mms? ( >=media-libs/libmms-0.3 )
	mp3? ( >=media-sound/mpg123-1.12.1 )
	pulseaudio? ( >=media-sound/pulseaudio-0.9.3 )
    qt5? ( dev-qt/qtcore:5
           dev-qt/qtgui:5
           dev-qt/qtwidgets:5
           media-sound/audacious[qt5] )
	scrobbler? ( net-misc/curl )
	sdl? ( media-libs/libsdl[sound] )
	sid? ( >=media-libs/libsidplayfp-1.0.0 )
	sndfile? ( >=media-libs/libsndfile-1.0.17-r1 )
        soxr? ( media-libs/soxr )
	vorbis? ( >=media-libs/libvorbis-1.2.0
		  >=media-libs/libogg-1.1.3 )
	wavpack? ( >=media-sound/wavpack-4.50.1-r1 )"

DEPEND="${RDEPEND}
	nls? ( dev-util/intltool )
	virtual/pkgconfig"

DOCS="AUTHORS"

pkg_setup() {
    use qt5 && export PATH="/usr/$(get_libdir)/qt5/bin:${PATH}"
}

src_prepare() {
	if has_version "<dev-libs/glib-2.32" ; then
		cd "${S}"/src/mpris2
		gdbus-codegen --interface-prefix org.mpris. \
			--c-namespace Mpris --generate-c-code object-core mpris2.xml
		gdbus-codegen --interface-prefix org.mpris. \
			--c-namespace Mpris \
			--generate-c-code object-player mpris2-player.xml
		cd "${S}"
    fi
}

src_configure() {
	use mp3 || ewarn "MP3 support is optional, you may want to enable the mp3 USE-flag"
	./autogen.sh
	econf \
		--enable-modplug \
		--enable-neon \
		$(use_enable adplug) \
		$(use_enable aac) \
		$(use_enable alsa) \
		$(use_enable bs2b) \
		$(use_enable cdda cdaudio) \
		$(use_enable cue) \
        $(use_with ffmpeg ffmpeg ffmpeg) \
        $(use_with libav ffmpeg libav) \
		$(use_enable filewriter) \
		$(use_enable flac flacng) \
		$(use_enable flac filewriter_flac) \
		$(use_enable spectrum glspectrum) \
		$(use_enable jack) \
		$(use_enable gnome gnomeshortcuts) \
		$(use_enable gtk gtk) \
		$(use_enable gtk ladspa) \
		$(use_enable gtk vtx) \
		$(use_enable lame filewriter_mp3) \
		$(use_enable libnotify notify) \
		$(use_enable libsamplerate resample) \
		$(use_enable lirc) \
		$(use_enable mms) \
		$(use_enable mp3) \
		$(use_enable midi amidiplug) \
		$(use_enable nls) \
		$(use_enable pulseaudio pulse) \
		$(use_enable qt5 qt) \
		$(use_enable scrobbler scrobbler2) \
		$(use_enable sdl sdlout) \
		$(use_enable sid) \
		$(use_enable sndfile) \
		$(use_enable soxr) \
		$(use_enable vorbis) \
		$(use_enable wavpack)
 
#	if use qt5 ; then
#        sed -i 's/GENERAL_PLUGINS ?= /GENERAL_PLUGINS ?= qtui/g' extra.mk
#        sed -i 's/@USE_QT@/yes/g' extra.mk
#        cd "${S}/src/qtui"
#        sed -i 's/CFLAGS += /CFLAGS += -fPIC/g' Makefile
#        sed -i 's/CPPFLAGS += /CPPFLAGS += -fPIC/g' Makefile
#        cd "${S}"
#    fi
}
