# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
ETYPE="sources"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="89"
K_DEBLOB_AVAILABLE="0"
inherit kernel-2
detect_version
detect_arch

#KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
HOMEPAGE="http://dev.gentoo.org/~mpagano/genpatches"
IUSE="deblob"

DESCRIPTION="Full sources including the Gentoo patchset for the ${KV_MAJOR}.${KV_MINOR} kernel tree"
SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI}"

src_prepare() {
# 	epatch "${FILESDIR}"/3.4.83-backport_direct_firmware_loading.patch

	# backport introduction of SO_REUSEPORT to fix avahi compatibility
	epatch "${FILESDIR}"/3.4.89-backport-soreuseport-01-named-constants-for-sk_reuse.patch \
		"${FILESDIR}"/3.4.89-backport-soreuseport-02-infrastructure.patch \
		"${FILESDIR}"/3.4.89-backport-soreuseport-03-udp-tcp-ipv4-ipv6-implementation.patch

	# backport kernel 3.7.10 i915 goodness
# 	epatch "${FILESDIR}"/3.4.105-backport-drm-i915-01-r1.patch \
# 		"${FILESDIR}"/3.4.105-backport-drm-i915-02-create-include_uapi.patch \
# 		"${FILESDIR}"/3.4.105-backport-drm-i915-04-update-headers-r2.patch \
# 		"${FILESDIR}"/3.4.105-backport-drm-i915-05-update-drivers_char.patch

# 		"${FILESDIR}"/3.4.105-backport-drm-i915-03-delete-include_drm.patch \

	epatch "${FILESDIR}"/3.4.105-set-i9xx-lvds-clock-limits-according-to-specification.patch

	epatch "${FILESDIR}"/relocation-issue/3.4.105-i915_initialization_teardown-for-the-aliasing-ppgtt.patch \
		"${FILESDIR}"/relocation-issue/3.4.105-i915_ppgtt-binding_unbinding-support.patch \
		"${FILESDIR}"/relocation-issue/3.4.105-i915_split-out-dma-mapping-from-global-gtt-bind_unbind-functions.patch \
		"${FILESDIR}"/relocation-issue/3.4.105-i915_drop-gtt-slowpath.patch \
		"${FILESDIR}"/relocation-issue/3.4.105-i915_move-i915_gem_do_init.patch \
		"${FILESDIR}"/relocation-issue/3.4.105-i915_clear-the-entire-gtt-when-using-gem.patch \
		"${FILESDIR}"/relocation-issue/3.4.105-i915_ring-irq-cleanups.patch \
		"${FILESDIR}"/relocation-issue/3.4.105-i915_open-code-gen6+-ring-irqs.patch \
		"${FILESDIR}"/relocation-issue/3.4.105-i915_rip-out-ring_irq_mask.patch \
		"${FILESDIR}"/relocation-issue/3.4.105-i915_set-ring_size-in-common-ring-setup-code.patch \
		"${FILESDIR}"/relocation-issue/3.4.105-i915_dynamically-set-up-the-render-ring-functions-and-params.patch \
		"${FILESDIR}"/relocation-issue/3.4.105-i915_dynamically-set-up-bsd-ring-functions-and-params.patch \
		"${FILESDIR}"/relocation-issue/3.4.105-i915_abstract-away-ring-specific-irq_get_put.patch \
		"${FILESDIR}"/relocation-issue/3.4.105-i915_split-out-the-gen5-ring-irq-get_put-functions.patch \
		"${FILESDIR}"/relocation-issue/3.4.105-i915_splitup-ring-dispatch_execbuffer-functions.patch \
		"${FILESDIR}"/relocation-issue/3.4.105-i915_replace-open-coded-MI_BATCH_GTT.patch \
		"${FILESDIR}"/relocation-issue/3.4.105-i915_remove-i915_gem_evict_inactive.patch \
		"${FILESDIR}"/relocation-issue/3.4.105-i915_add-colouring-to-the-range-allocator.patch \
		"${FILESDIR}"/relocation-issue/3.4.105-i915_segregate-memory-domains-in-the-GTT-using-coloring.patch \
		"${FILESDIR}"/relocation-issue/3.4.105-i915_only-pwrite-through-the-GTT-if-there-is-space-in-the-aperture.patch \
		"${FILESDIR}"/relocation-issue/3.4.105-i915_shutup-six-instances-of-Warray-bounds.patch

#########
# # 		"${FILESDIR}"/relocation-issue/3.4.105-i915_track-unbound-pages.patch \
# 	epatch "${FILESDIR}"/relocation-issue/3.4.105-i915_allow_DRM_ROOT_ONLY-DRM_MASTER-to-submit-privileged-batchbuffers.patch \
# 		"${FILESDIR}"/relocation-issue/3.4.105-i915_defer-assignment-of-obj_gtt_space-until-after-all-possible-mallocs.patch
# # 		"${FILESDIR}"/relocation-issue/3.4.105-i915_preallocate-the-drm_mm_node-prior-to-manipulating-the-GTT.patch \
# 	epatch "${FILESDIR}"/relocation-issue/3.4.105-i915_implement-workaround-for-broken-CS-tlb-on-i830_845.patch \
# 		"${FILESDIR}"/relocation-issue/3.4.105-i915_pre-fixes-for-checkpatch.patch \
# 		"${FILESDIR}"/relocation-issue/3.4.105-i915_use-new-bind_unbind-in-eviction-code.patch \
# 		"${FILESDIR}"/relocation-issue/3.4.105-i915_consolidate-binding-parameters-into-flags.patch \
# 		"${FILESDIR}"/relocation-issue/3.4.105-i915_split-PIN_GLOBAL-out-from-PIN_MAPPABLE.patch \
# 		"${FILESDIR}"/relocation-issue/3.4.105-prevent-negative-relocation-deltas-from-wrapping.patch \
# 		"${FILESDIR}"/relocation-issue/3.4.105-evict-CS-TLBs-between-batches.patch \
# 		"${FILESDIR}"/relocation-issue/3.4.105-disallow-pin-ioctl-completely-for-kms-drivers.patch

	# backport optimistic locking from 3.16
# 	epatch "${FILESDIR}"/3.4.105-backport-optimistic-spinning-10-move-the-mutex-code-to-kernel_locking.patch \
# 		"${FILESDIR}"/3.4.105-backport-optimistic-spinning-11-update-references-to-kernel_locking.patch

# 	epatch "${FILESDIR}"/3.4.105-backport-optimistic-spinning-01-correct-barrier-usage.patch \
# 		"${FILESDIR}"/3.4.105-backport-optimistic-spinning-02-MCS-lock-defines.patch
# 	epatch "${FILESDIR}"/3.4.105-backport-optimistic-spinning-101.patch \
# 		"${FILESDIR}"/3.4.105-backport-optimistic-spinning-102-new-documentation.patch \
# 		"${FILESDIR}"/3.4.105-backport-optimistic-spinning-103-update-doc-references.patch

}

pkg_postinst() {
	kernel-2_pkg_postinst
	einfo "For more info on this patchset, and how to report problems, see:"
	einfo "${HOMEPAGE}"
}

pkg_postrm() {
	kernel-2_pkg_postrm
}
