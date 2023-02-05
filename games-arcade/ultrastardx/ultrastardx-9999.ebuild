# Copyright 1999-2023 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1,2,3} )
inherit git-r3 autotools desktop flag-o-matic lua-single xdg-utils

DESCRIPTION="Open-source karaoke game"
HOMEPAGE="https://usdx.eu/"
EGIT_REPO_URI="https://github.com/UltraStar-Deluxe/USDX/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug midi portaudio projectm webcam"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="${LUA_DEPS}
	dev-db/sqlite
	media-libs/freetype
	media-libs/libsdl2[opengl]
	media-libs/sdl2-image[png,jpeg]
	media-video/ffmpeg:=
	virtual/opengl
	midi? ( media-libs/portmidi )
	portaudio? ( =media-libs/portaudio-19* )
	projectm? ( media-libs/libprojectm:= )
	webcam? ( media-libs/opencv:= )
"
DEPEND="${RDEPEND}
	dev-lang/fpc
"
BDEPEND="
	sys-devel/autoconf-archive
	virtual/pkgconfig
"

DOCS=( {ChangeLog,COPYRIGHT}.txt README.md )

pkg_setup() {
	lua-single_pkg_setup
}

src_prepare() {
	default
	./autogen.sh || die
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_with portaudio)
		$(use_with projectm libprojectM)
		$(use_with webcam opencv-cxx-api)
		$(use_enable midi portmidi)
		$(use_enable debug)
	)
	econf ${myeconfargs[@]} || die "econf failed"
}

src_compile() {
	emake LDFLAGS="$(raw-ldflags)"
}

src_install() {
	emake DESTDIR="${D}" install

	einstalldocs

	doicon -s scalable icons/${PN}-icon.svg
	doicon icons/${PN}-icon.svg
	make_desktop_entry ${PN} "UltraStar Deluxe"
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
