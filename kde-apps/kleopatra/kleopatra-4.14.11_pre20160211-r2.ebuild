# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="optional"
KMNAME="kdepim"
EGIT_BRANCH="KDE/4.14"
inherit kde4-meta

DESCRIPTION="Kleopatra - KDE X.509 key manager"
HOMEPAGE="https://www.kde.org/applications/utilities/kleopatra/"
COMMIT_ID="2aec255c6465676404e4694405c153e485e477d9"
SRC_URI="https://quickgit.kde.org/?p=kdepim.git&a=snapshot&h=${COMMIT_ID}&fmt=tgz -> ${KMNAME}-${PV}.tar.gz"

KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	$(add_kdeapps_dep kdepimlibs 'akonadi(+)' 4.14.11_pre20160211-r4)
	$(add_kdeapps_dep kdepim-common-libs)
	>=app-crypt/gpgme-1.3.2
	dev-libs/boost:=
	dev-libs/libassuan
	dev-libs/libgpg-error
"
RDEPEND="${DEPEND}
	app-crypt/gnupg
"

KMEXTRACTONLY="
	libkleo/
"

PATCHES=( "${FILESDIR}/${PN}-install-headers.patch" )

src_unpack() {
	if use handbook; then
		KMEXTRA="
			doc/kwatchgnupg
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
