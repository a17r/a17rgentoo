# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-2

DESCRIPTION="Audacious Player - Your music, your way, no exceptions"
HOMEPAGE="http://audacious-media-player.org/"
EGIT_REPO_URI="git://github.com/audacious-media-player/${PN}.git"
SRC_URI="mirror://gentoo/gentoo_ice-xmms-0.2.tar.bz2"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS=""

IUSE="chardet +gtk nls qt5"

RDEPEND=">=dev-libs/dbus-glib-0.60
	>=dev-libs/glib-2.28
	dev-libs/libxml2
	>=x11-libs/cairo-1.2.6
	>=x11-libs/pango-1.8.0
	"

DEPEND="${RDEPEND}
    dev-util/gdbus-codegen
	virtual/pkgconfig
	chardet? ( >=app-i18n/libguess-1.1 )
    gtk? ( x11-libs/gtk+:2 )
	nls? ( dev-util/intltool )
    qt5? ( dev-qt/qtcore:5
           dev-qt/qtgui:5
           dev-qt/qtwidgets:5 )
    "

PDEPEND="
    ~media-plugins/audacious-plugins-9999
    qt5? ( media-plugins/audacious-plugins[qt5] )
    "

pkg_setup() {
    use qt5 && export PATH="/usr/$(get_libdir)/qt5/bin:${PATH}"
}

src_configure() {
	./autogen.sh
	econf \
		--enable-dbus \
		$(use_enable chardet) \
		$(use_enable gtk) \
		$(use_enable nls) \
		$(use_enable qt5 qt)
}

src_install() {
	default
	dodoc AUTHORS

	# Gentoo_ice skin installation; bug #109772
	insinto /usr/share/audacious/Skins/gentoo_ice
	doins "${WORKDIR}"/gentoo_ice/*
	docinto gentoo_ice
	dodoc "${WORKDIR}"/README
}

pkg_postinst() {
    if use qt5 && ( use gtk || use gtk3 ) ; then
        ewarn 'It is not possible to switch between GTK+ and Qt while Audacious is running.'
        ewarn 'Run audacious --qt to get the Qt interface.'
    fi
}
