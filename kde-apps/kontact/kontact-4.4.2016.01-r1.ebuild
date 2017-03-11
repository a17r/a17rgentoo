# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KMNAME="kdepim"
KDE_HANDBOOK=optional
inherit kde4-meta

DESCRIPTION="KDE personal information manager (noakonadi branch)"
HOMEPAGE="https://launchpad.net/~pali/+archive/ubuntu/kdepim-noakonadi"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	$(add_kdeapps_dep kdepimlibs '' 4.14.10_p20160516)
	$(add_kdeapps_dep libkdepim '' 4.4.2015)
"
RDEPEND="${DEPEND}"

KMLOADLIBS="libkdepim"
KMSAVELIBS="true"

# We remove plugins that are related to external kdepim programs. This way
# kontact doesn't have to depend on all programs it has plugins for.
# kcontactmanager gone from kdesvn
#
# xml targets from kmail/ are being uncommented by kde4-meta.eclass
KMEXTRACTONLY="
	kmail/
	kontact/plugins/akregator/
	kontact/plugins/kaddressbook/
	kontact/plugins/kjots/
	kontact/plugins/kmail/
	kontact/plugins/knode/
	kontact/plugins/knotes/
	kontact/plugins/korganizer/
	kontact/plugins/ktimetracker/
	kontact/plugins/planner/
	kontact/plugins/specialdates/
"

src_unpack() {
	if use handbook; then
		KMEXTRA+="
			doc/kontact-admin/
		"
	fi

	kde4-meta_src_unpack
}

strip_patch_hunks_for_nonexistent_files() {
	local input_file="$1"
	local output_file="$2"

	local line changed_file
	while IFS=$'\n' read -r line; do
		[[ "${line}" == "--- "* ]] && changed_file="${line#--- /}"
		if [[ -f "${changed_file}" ]]; then
			echo "${line}" >> "${output_file}" || die "Writing to '${output_file}' failed"
		fi
	done < "${input_file}" || die "Reading from '${input_file}' failed"
}

src_prepare() {
	find "(" -name "*.cpp" -o -name "*.h" ")" -exec \
		sed -e 's:\(#[[:space:]]*include[[:space:]]\+[<"]\)\(gpgme++\|qgpgme\)\(/\):\1kde4_\2\3:' -i {} + || die
	strip_patch_hunks_for_nonexistent_files "${FILESDIR}/kdepim-${PV}-update_gpgme++_and_qgpgme_references.patch" "${T}/${P}-update_gpgme++_and_qgpgme_references.patch"
	eapply "${T}/${P}-update_gpgme++_and_qgpgme_references.patch"

	kde4-meta_src_prepare
}
