# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
ETYPE="sources"
#K_NOUSENAME="yes"
#K_NOSETEXTRAVERSION="yes"
K_SECURITY_UNSUPPORTED="1"
K_DEBLOB_AVAILABLE="0"
inherit kernel-2
detect_version
#detect_arch

DESCRIPTION="Own modified sources for the Linux kernel"
HOMEPAGE="http://www.kernel.org"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~sh ~sparc ~x86"
IUSE="deblob"

#OWNAGE_SNAPSHOT=""
#OWNAGE_VERSION="36rc6"
#OWNAGE_TARGET="3.5.4"

if [[ -n "${OWNAGE_SNAPSHOT}" ]]; then
	if [[ -n "${OWNAGE_VERSION}" ]]; then
        	OWNAGE_SRC="current-ownage-for-${OWNAGE_TARGET}.patch-${OWNAGE_SNAPSHOT}"
		OWNAGE_URI="http://www.ownage.net/files/${OWNAGE_SRC}.bz2"
		UNIPATCH_LIST="${DISTDIR}/${OWNAGE_SRC}.bz2"
	fi
else
	if [[ -n "${OWNAGE_VERSION}" ]]; then
        	OWNAGE_SRC="ownage-${OWNAGE_VERSION}-for-${OWNAGE_TARGET}.patch"
		OWNAGE_URI="http://www.ownage.net/files/${OWNAGE_SRC}.bz2"
		UNIPATCH_LIST="${DISTDIR}/${OWNAGE_SRC}.bz2"
	fi
fi

SRC_URI="${KERNEL_URI} ${OWNAGE_URI}"

UNIPATCH_LIST="${UNIPATCH_LIST} ${FILESDIR}/3.9_fix-false-timeouts-for-gmbus_wait_idle.patch"
UNIPATCH_LIST="${UNIPATCH_LIST} ${FILESDIR}/3.9_fix-DP-AUX-errors-due-to-false-timeouts-when-using-wait_event_timeout.patch"
UNIPATCH_STRICTORDER="yes"

#SRC_URI="${KERNEL_URI} ${ARCH_URI} ${OWNAGE_URI}"

#src_unpack() {
#        unpack ${A}
#        cd "${S}"
#        touch "${S}/usr/src/linux-${KV_FULL}/drivers/staging/rt2860/2860_main_dev.c"
#}

#pkg_preinst() {
#        einfo "Temporary fix: rename file ${D}/usr/src/linux-${KV_FULL}/drivers/gpu/drm/i915/i915_gem_debugfs.c to i915_debugfs.c"
#        mv "${D}/usr/src/linux-${KV_FULL}/drivers/gpu/drm/i915/i915_gem_debugfs.c" "${D}/usr/src/linux-${KV_FULL}/drivers/gpu/drm/i915/i915_debugfs.c"
#}

#STABLE QUEUE DIR:
#git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git

pkg_postinst() {
        kernel-2_pkg_postinst
}

pkg_postrm() {
        kernel-2_pkg_postrm
}
