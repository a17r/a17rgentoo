# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P="pgl-${PV}"
inherit autotools ltprune gnome2-utils linux-info systemd

DESCRIPTION="Privacy oriented firewall application"
HOMEPAGE="https://sourceforge.net/projects/peerguardian/"
SRC_URI="mirror://sourceforge/peerguardian/${MY_P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="cron dbus logrotate networkmanager qt5 zlib"
REQUIRED_USE="qt5? ( dbus )"

COMMON_DEPEND="
	net-libs/libnetfilter_queue
	net-libs/libnfnetlink
	dbus? ( sys-apps/dbus )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtgui:5
		sys-auth/polkit-qt
	)
	zlib? ( sys-libs/zlib:= )
"
DEPEND="${COMMON_DEPEND}
	sys-devel/libtool:2
	virtual/pkgconfig
"
RDEPEND="${COMMON_DEPEND}
	net-firewall/iptables
	sys-apps/sysvinit
	cron? ( virtual/cron )
	logrotate? ( app-admin/logrotate )
	networkmanager? ( net-misc/networkmanager:= )
	qt5? ( || ( kde-plasma/kde-cli-tools:5[kdesu] x11-misc/ktsuss ) )
"

CONFIG_CHECK="~NETFILTER_NETLINK
	~NETFILTER_NETLINK_QUEUE
	~NETFILTER_XTABLES
	~NETFILTER_XT_TARGET_NFQUEUE
	~NETFILTER_XT_MATCH_IPRANGE
	~NETFILTER_XT_MARK
	~NETFILTER_XT_MATCH_MULTIPORT
	~NETFILTER_XT_MATCH_STATE
	~NF_CONNTRACK
	~NF_CONNTRACK_IPV4
	~NF_DEFRAG_IPV4
	~IP_NF_FILTER
	~IP_NF_IPTABLES
	~IP_NF_TARGET_REJECT"

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}"/${P}-qt5.patch )

src_prepare() {
	default
	sed -i -e 's:/sbin/runscript:/sbin/openrc-run:' pglcmd/init/pgl.gentoo.in || die
	rm m4/qt4.m4 || die
	cp ${FILESDIR}/${P}-qt5.m4 m4/ || die
	eautoreconf
}

src_configure() {
	econf \
		--localstatedir=/var \
		$(use_enable logrotate) \
		$(use_enable cron) \
		$(use_enable networkmanager) \
		$(use_enable zlib) \
		$(use_enable dbus) \
		--disable-lowmem \
		--with-iconsdir=/usr/share/icons/hicolor/128x128/apps \
		--with-gentoo-init \
		$(use_with qt5) \
		--with-systemd="$(systemd_get_systemunitdir)"
}

src_install() {
	default
	keepdir /var/{lib,log,spool}/pgl
	rm -rf "${ED%/}"/tmp || die
	prune_libtool_files --modules
}

pkg_postinst() {
	elog "optional dependencies:"
	elog "  app-arch/p7zip (needed for blocklists packed as .7z)"
	elog "  app-arch/unzip (needed for blocklists packed as .zip)"
	elog "  virtual/mta (needed to send informational (blocklist updates) and"
	elog "    warning mails (if pglcmd.wd detects a problem.))"

	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
