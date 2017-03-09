# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MULTIMEDIA_REQUIRED="optional"
KDE_HANDBOOK="optional"

KDE_LINGUAS="ast be bg bs ca ca@valencia cs csb da de el en_GB eo es et eu fi fr
ga gl he hi hne hr hu is it ja kk km ko ku lt lv mai mr ms nb nds nl nn oc pa pl
pt pt_BR ro ru se sk sl sr sr@ijekavian sr@ijekavianlatin sr@latin sv th tr ug uk
zh_CN zh_TW"

inherit kde4-base

DESCRIPTION="Full-featured burning and ripping application by KDE"
HOMEPAGE="http://www.k3b.org/"
SRC_URI="https://dev.gentoo.org/~asturm/${P}.tar.xz"

LICENSE="GPL-2 FDL-1.2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug dvd emovix encode ffmpeg flac libav mad mp3 musepack sndfile sox taglib vcd vorbis"

CDEPEND="
	$(add_kdeapps_dep libkcddb)
	media-libs/libsamplerate
	dvd? ( media-libs/libdvdread )
	ffmpeg? (
		libav? ( media-video/libav:= )
		!libav? ( media-video/ffmpeg:0= )
	)
	flac? ( media-libs/flac[cxx] )
	mad? ( media-libs/libmad )
	mp3? ( media-sound/lame )
	musepack? ( media-sound/musepack-tools )
	sndfile? ( media-libs/libsndfile )
	taglib? ( media-libs/taglib )
	vorbis? ( media-libs/libvorbis )
"
DEPEND="${CDEPEND}
	sys-devel/gettext
"
RDEPEND="${CDEPEND}
	app-cdr/cdrdao
	kde-frameworks/kdelibs:4[udev,udisks(+)]
	media-sound/cdparanoia
	virtual/cdrtools
	dvd? (
		app-cdr/dvd+rw-tools
		encode? ( media-video/transcode[dvd] )
	)
	emovix? ( media-video/emovix )
	sox? ( media-sound/sox )
	vcd? ( media-video/vcdimager )
"

REQUIRED_USE="
	mp3? ( encode )
	sox? ( encode )
"

DOCS=( ChangeLog {FAQ,PERMISSIONS,README}.txt )

src_configure() {
	local mycmakeargs=(
		-DK3B_BUILD_API_DOCS=OFF
		-DK3B_BUILD_WAVE_DECODER_PLUGIN=ON
		-DK3B_ENABLE_HAL_SUPPORT=OFF
		-DK3B_ENABLE_MUSICBRAINZ=OFF
		-DK3B_DEBUG=$(usex debug)
		-DK3B_ENABLE_DVD_RIPPING=$(usex dvd)
		-DK3B_BUILD_EXTERNAL_ENCODER_PLUGIN=$(usex encode)
		-DK3B_BUILD_FFMPEG_DECODER_PLUGIN=$(usex ffmpeg)
		-DK3B_BUILD_FLAC_DECODER_PLUGIN=$(usex flac)
		-DK3B_BUILD_LAME_ENCODER_PLUGIN=$(usex mp3)
		-DK3B_BUILD_MAD_DECODER_PLUGIN=$(usex mad)
		-DK3B_BUILD_MUSE_DECODER_PLUGIN=$(usex musepack)
		-DK3B_BUILD_SNDFILE_DECODER_PLUGIN=$(usex sndfile)
		-DK3B_BUILD_SOX_ENCODER_PLUGIN=$(usex sox)
		-DK3B_ENABLE_TAGLIB=$(usex taglib)
		-DK3B_BUILD_OGGVORBIS_DECODER_PLUGIN=$(usex vorbis)
		-DK3B_BUILD_OGGVORBIS_ENCODER_PLUGIN=$(usex vorbis)
	)

	kde4-base_src_configure
}

pkg_postinst() {
	kde4-base_pkg_postinst

	echo
	elog "If you get warnings on start-up, uncheck the \"Check system"
	elog "configuration\" option in the \"Misc\" settings window."
	echo

	local group=cdrom
	use kernel_linux || group=operator
	elog "Make sure you have proper read/write permissions on optical device(s)."
	elog "Usually, it is sufficient to be in the ${group} group."
	echo
}
