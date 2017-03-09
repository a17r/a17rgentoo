# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KMNAME="kdepim"
KMMODULE="wizards"
inherit kde4-meta

DESCRIPTION="KDE PIM wizards (noakonadi branch)"
HOMEPAGE="https://launchpad.net/~pali/+archive/ubuntu/kdepim-noakonadi"
IUSE="debug"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

DEPEND="
	$(add_kdeapps_dep kdepimlibs '' 4.14.10-r4)
	$(add_kdeapps_dep kdepim-kresources '' 4.4.2015)
	$(add_kdeapps_dep libkdepim '' 4.4.2015)
"
RDEPEND="${DEPEND}"

KMEXTRACTONLY="
	kmail/
	knotes/
	kresources/groupwise/
	kresources/kolab/
	kresources/slox/
"

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

	ln -s "${EKDEDIR}"/include/kdepim-kresources/{kabcsloxprefs.h,kcalsloxprefs.h} \
		kresources/slox/ \
		|| die "Failed to link extra_headers."
	ln -s "${EKDEDIR}"/include/kdepim-kresources/{kabc_groupwiseprefs,kcal_groupwiseprefsbase}.h \
		kresources/groupwise/ \
		|| die "Failed to link extra_headers."

	kde4-meta_src_prepare
}
