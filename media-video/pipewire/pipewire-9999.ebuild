# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/PipeWire/pipewire.git"
	EGIT_BRANCH="work"
	inherit git-r3
else
	SRC_URI="https://github.com/PipeWire/${PN}/archive/${PV}.tar.gz -> ${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Multimedia processing graphs"
HOMEPAGE="https://pipewire.org/"

LICENSE="LGPL-2.1+"
SLOT="0/0.3"
IUSE="+alsa bluetooth debug doc ffmpeg gstreamer jack libav pulseaudio realtime sdl systemd +testplugins v4l vaapi vulkan X"

BDEPEND="
	app-doc/xmltoman
	doc? (
		app-doc/doxygen
		media-gfx/graphviz
	)
"
# 	dev-libs/glib:2[dbus]
# 	media-libs/speexdsp
RDEPEND="
	media-libs/alsa-lib
	sys-apps/dbus
	virtual/libudev
	bluetooth? ( media-libs/sbc )
	ffmpeg? (
		!libav? ( media-video/ffmpeg:= )
		libav? ( media-video/libav:= )
	)
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
	)
	jack? ( virtual/jack )
	pulseaudio? ( media-sound/pulseaudio )
	realtime? ( sys-auth/rtkit )
	sdl? ( media-libs/libsdl2 )
	systemd? ( sys-apps/systemd )
	vaapi? ( x11-libs/libva )
	v4l? ( media-libs/libv4l )
	X? ( x11-libs/libX11 )
"
DEPEND="${RDEPEND}
	vulkan? (
		dev-util/vulkan-headers
		media-libs/vulkan-loader
	)
"

src_prepare() {
	spa_use() {
		if ! use ${1}; then
			sed -e "/.*dependency.*'${2-$1}'/s/'${2-$1}'/'${2-$1}-disabled-by-USE-no-${1}'/" \
				-i spa/meson.build || die
		fi
	}

	default
	spa_use bluetooth sbc
	spa_use ffmpeg libavcodec
	spa_use ffmpeg libavformat
	spa_use ffmpeg libavfilter
	spa_use vaapi libva
	spa_use sdl sdl2
	spa_use X x11
}

src_configure() {
	local emesonargs=(
		$(meson_use alsa)
		$(meson_use alsa pipewire-alsa)
		$(meson_use bluetooth bluez5)
		$(meson_use doc docs)
		$(meson_use ffmpeg)
		$(meson_use gstreamer)
		$(meson_use jack)
		$(meson_use jack pipewire-jack)
		$(meson_use pulseaudio pipewire-pulseaudio)
		$(meson_use systemd)
		$(meson_use testplugins audiotestsrc)
		$(meson_use testplugins test)
		$(meson_use testplugins videotestsrc)
		$(meson_use v4l v4l2)
		$(meson_use vulkan)
		-Daudioconvert=true
		-Daudiomixer=true
		-Dman=true
		-Dspa=true
		-Dspa-plugins=true
		-Dsupport=true
		-Dvolume=true
		--buildtype=$(usex debug debugoptimized plain)
	)
	meson_src_configure
}

pkg_postinst() {
	elog "Package has optional sys-auth/rtkit RUNTIME support that may be"
	elog "disabled by setting DISABLE_RTKIT env var."
}
