# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/intel-gpu-tools/intel-gpu-tools-1.0.2.ebuild,v 1.3 2009/12/10 18:16:44 fauli Exp $

EAPI=4

inherit xorg-2

DESCRIPTION="Intel GPU userland tools"

KEYWORDS="amd64 x86"

IUSE="video_cards_nouveau"
#RESTRICT="test"

DEPEND="
	x11-libs/libdrm[video_cards_intel]
	video_cards_nouveau? ( x11-libs/libdrm[video_cards_nouveau] )
	>=x11-libs/libpciaccess-0.10"
RDEPEND="${DEPEND}"

src_configure() {
	XORG_CONFIGURE_OPTIONS=(
		$(use_enable video_cards_nouveau nouveau)
	)
	xorg-2_src_configure
}
