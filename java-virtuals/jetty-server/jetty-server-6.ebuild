# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit java-virtuals-2

DESCRIPTION="Virtual for Jetty www server"
HOMEPAGE="http://www.gentoo.org"
SRC_URI=""

LICENSE=""
SLOT="${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="|| (
	www-servers/jetty:${SLOT}
	www-servers/jetty-bin:${SLOT}
	www-servers/jetty-eclipse:${SLOT}
	www-servers/jetty-eclipse-bin:${SLOT}
	)
	>=dev-java/java-config-2.1.8"

JAVA_VIRTUAL_PROVIDES="jetty-${SLOT} jetty-bin-${SLOT} jetty-eclipse-${SLOT} jetty-eclipse-bin-${SLOT}"
