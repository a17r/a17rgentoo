# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KMNAME="kdepim"
KDE_HANDBOOK=optional
inherit kde4-meta

DESCRIPTION="The KDE Address Book (noakonadi branch)"
HOMEPAGE="https://launchpad.net/~pali/+archive/ubuntu/kdepim-noakonadi"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	$(add_kdeapps_dep kdepimlibs '' 4.14.10-r4)
	$(add_kdeapps_dep libkdepim '' 4.4.2015)
	$(add_kdeapps_dep libkleo '' 4.4.2015)
	kde-frameworks/kdelibs:4
"
RDEPEND="${DEPEND}"

KMEXTRA="
	plugins/kaddressbook/
	plugins/ktexteditor/
"
KMEXTRACTONLY="
	libkleo/
"

KMLOADLIBS="libkdepim"

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

src_install() {
	kde4-meta_src_install

	# file collision with kde-apps/kdepimlibs-4.14.9
	rm -f "${ED}usr/share/kde4/servicetypes/kaddressbookimprotocol.desktop" || die

	# install additional headers needed by kresources
	insinto "${KDEDIR}"/include/${PN}
	doins "${CMAKE_BUILD_DIR}"/${PN}/common/*.h
	doins "${S}"/${PN}/common/*.h
}

pkg_postinst() {
	kde4-meta_pkg_postinst

	if ! has_version kde-apps/kdepim-kresources:${SLOT}; then
		echo
		elog "For groupware functionality, please install kde-apps/kdepim-kresources:${SLOT}"
		echo
	fi
}
