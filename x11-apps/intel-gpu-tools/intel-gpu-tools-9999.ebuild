# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

inherit xorg-3

DESCRIPTION="Intel GPU userland tools"

KEYWORDS=""
IUSE="doc test video_cards_nouveau"

RESTRICT="test"

BDEPEND="
	doc? ( dev-util/gtk-doc )
	test? ( sys-libs/libunwind )
"
RDEPEND="
	dev-libs/glib:2
	>=x11-libs/cairo-1.12.0
	>=x11-libs/libdrm-2.4.47[video_cards_intel,video_cards_nouveau?]
	>=x11-libs/libpciaccess-0.10
"
DEPEND="${RDEPEND}"

src_prepare() {
	# automake expects gtk-doc.make, but file is in .gitignore
	# replicate autogen.sh output
	if ! use doc; then
		echo -e "EXTRA_DIST =\nCLEANFILES =" > ./gtk-doc.make || die
	fi

	xorg-3_src_prepare
}

src_configure() {
	XORG_CONFIGURE_OPTIONS=(
		$(use_enable doc gtk-doc)
		$(use_enable video_cards_nouveau nouveau)
		$(use_with test libunwind)
	)
	xorg-3_src_configure
}
