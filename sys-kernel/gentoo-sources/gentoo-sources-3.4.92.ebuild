# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/gentoo-sources/gentoo-sources-3.4.86.ebuild,v 1.1 2014/04/04 00:33:39 mpagano Exp $

EAPI="5"
ETYPE="sources"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="75"
K_DEBLOB_AVAILABLE="1"
inherit kernel-2
detect_version
detect_arch

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
HOMEPAGE="http://dev.gentoo.org/~mpagano/genpatches"
IUSE="deblob"

DESCRIPTION="Full sources including the Gentoo patchset for the ${KV_MAJOR}.${KV_MINOR} kernel tree"
SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI}"

src_prepare() {
	epatch "${FILESDIR}"/3.4.83-backport_direct_firmware_loading.patch
# 		"${FILESDIR}"/3.4.83a-limit-the-scope-of-the-async-probe-domain.patch \
# 		"${FILESDIR}"/3.4.83b-fix-sd_probe_domain-config-problem.patch \
# 		"${FILESDIR}"/3.4.83ca-revert-fix-dead-loop-in-async_synchronize_full.patch \
# 		"${FILESDIR}"/3.4.83cb-introduce-async_domain-type.patch \
# 		"${FILESDIR}"/3.4.83d-make-async_synchronize_full-flush-all-work-regardless-of-domain.patch \
# 		"${FILESDIR}"/3.4.83ea-rename-kernel-workqueue_sched-to-workqueue_internal.patch \
# 		"${FILESDIR}"/3.4.83eb-move-struct-worker-definition-to-workqueue_internal.patch \
# 		"${FILESDIR}"/3.4.83ec-implement-current_is_async.patch \
# 		"${FILESDIR}"/3.4.83f-bring-sanity-to-use-of-words-domain-and-running.patch \
# 		"${FILESDIR}"/3.4.83ga-keep-pending-tasks-on-async_domain-and-remove-async_pending.patch \
# 		"${FILESDIR}"/3.4.83gb-use-ULLONG_MAX-for-infinity-cookie-value \
# 		"${FILESDIR}"/3.4.83h-remove-unused-node-from-struct-async_domain.patch \
# 		"${FILESDIR}"/3.4.83i-rename-and-redefine-async_func_ptr.patch \
# 		"${FILESDIR}"/3.4.83j-introduce-devres_for_each_res.patch \
# 		"${FILESDIR}"/3.4.83k-introduce-dpm_for_each_dev.patch \

	EPATCH_SOURCE="${FILESDIR}/async" EPATCH_SUFFIX="patch" \
        EPATCH_FORCE="yes" epatch

	# backport introduction of SO_REUSEPORT to fix avahi compatibility
	epatch "${FILESDIR}"/3.4.89-backport-01-named-constants-for-sk_reuse.patch \
		"${FILESDIR}"/3.4.89-backport-02-merge-branch-soreuseport.patch \
		"${FILESDIR}"/3.4.89-backport-03-remove-leftover-endif.patch
}

pkg_postinst() {
	kernel-2_pkg_postinst
	einfo "For more info on this patchset, and how to report problems, see:"
	einfo "${HOMEPAGE}"
}

pkg_postrm() {
	kernel-2_pkg_postrm
}
