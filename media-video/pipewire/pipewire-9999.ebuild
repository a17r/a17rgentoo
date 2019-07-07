# Copyright 1999-2019 Gentoo Authors
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

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="+alsa bluetooth debug doc ffmpeg gstreamer jack pulseaudio realtime systemd +testplugins v4l"

BDEPEND="
	app-doc/xmltoman
	doc? (
		app-doc/doxygen
		media-gfx/graphviz
	)
"
RDEPEND="
	dev-libs/glib:2[dbus]
	media-libs/alsa-lib
	media-libs/libsdl2
	media-libs/libv4l
	media-libs/sbc
	media-libs/speexdsp
	sys-apps/dbus
	virtual/libudev
	x11-libs/libX11
	ffmpeg? ( virtual/ffmpeg:= )
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
	)
	jack? ( virtual/jack )
	pulseaudio? ( media-sound/pulseaudio )
	realtime? ( sys-auth/rtkit )
	systemd? ( sys-apps/systemd )
"
DEPEND="${RDEPEND}"

src_configure() {
	local emesonargs=(
		$(meson_use alsa)
		$(meson_use alsa pipewire-alsa)
		$(meson_use bluetooth bluez5)
		$(meson_use doc docs)
		$(meson_use ffmpeg)
		$(meson_use gstreamer)
		$(meson_use jack pipewire-jack)
		$(meson_use pulseaudio pipewire-pulseaudio)
		$(meson_use systemd)
		$(meson_use testplugins audiotestsrc)
		$(meson_use testplugins test)
		$(meson_use testplugins videotestsrc)
		$(meson_use v4l v4l2)
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

# # ?: how on earth are we supposed to do this properly using doheader?!
# deepheader() {
# 	local aheader
# 	for aheader in "$@"; do
# 		[[ -f "${aheader}" ]] || die "header \"${aheader}\" not found (pwd=${PWD})"
# 		insopts -m 0644
# 		dodir /usr/include/${aheader%/*}
# 		insinto /usr/include/${aheader%/*}
# 		doins "${aheader}"
# 	done
# }
# 
# src_install() {
# 	meson_src_install
# 	# note: omitting for now but we might want to do this if problems occur.
# 	# An environment variable, DISABLE_RTKIT, can achieve this at runtime
# 
# 	# if use '!realtime'; then
# 	# 	rm "${ED%/}"/usr/$(get_libdir)/pipewire-*/libpipewire-module-rtkit.so || die
# 	# 	sed -e '/^load-module\slibpipewire-module-rtkit$/s/^/#/' -i "${ED%/}"/etc/pipewire/pipewire.conf 
# 	# fi
# 
# 	sed -e 's|^exec\sbuild/src/|exec |g' -i "${ED}"/etc/pipewire/pipewire.conf || die "build/src removal"
# 
# 	if use doc; then
# 		mv "${ED}"/usr/share/doc/pipewire/html "${ED}"/usr/share/doc/${PN}-${PVR}/html || die "moving html"
# 		rmdir "${ED}"/usr/share/doc/pipewire || die "removing usr/share/doc/pipewire dir"
# 	fi
# 	if use alsa; then
# 		dodir /usr/share/alsa/alsa.conf.d
# 		insinto /usr/share/alsa/alsa.conf.d
# 		doins pipewire-alsa/conf/50-pipewire.conf
# 		dodir /etc/alsa/conf.d
# 		dosym "${EPREFIX}"/usr/share/alsa/alsa.conf.d/50-pipewire.conf /etc/alsa/conf.d/50-pipewire.conf
# 	fi
# 	cd ${S}/spa/include
# 	deepheader spa/utils/result.h
# 	cd "${BUILD_DIR}"/src/examples
# 	dodir /usr/$(get_libdir)/pipewire-0.3/examples
# 	exeinto /usr/$(get_libdir)/pipewire-0.3/examples
# 	doexe audio-src
# 	doexe export-{sink,source,spa}
# 	doexe media-session
# 	doexe video-{play,src}
# 	use v4l && doexe local-v4l2
# }
