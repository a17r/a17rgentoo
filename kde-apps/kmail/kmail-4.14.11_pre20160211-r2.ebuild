# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="optional"
KMNAME="kdepim"
EGIT_BRANCH="KDE/4.14"
VIRTUALX_REQUIRED="test"
WEBKIT_REQUIRED="always"
inherit flag-o-matic kde4-meta

DESCRIPTION="Email component of Kontact, the integrated personal information manager of KDE"
HOMEPAGE="https://www.kde.org/applications/internet/kmail/"
COMMIT_ID="2aec255c6465676404e4694405c153e485e477d9"
SRC_URI="https://quickgit.kde.org/?p=kdepim.git&a=snapshot&h=${COMMIT_ID}&fmt=tgz -> ${KMNAME}-${PV}.tar.gz"

KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	$(add_kdeapps_dep kdepimlibs '' 4.14.11_pre20160516)
	$(add_kdeapps_dep kdepim-common-libs)
	$(add_kdeapps_dep korganizer)
"
RDEPEND="${DEPEND}"

RESTRICT="test"
# bug 393147

KMEXTRACTONLY="
	agents/folderarchiveagent.desktop
	agents/sendlateragent/
	akonadi_next/
	calendarviews/
	grantleeeditor/grantleethemeeditor/
	kdgantt2/
	korganizer/
	kresources/
	libkdepimdbusinterfaces/
	libkleo/
	libkpgp/
"
KMCOMPILEONLY="
	calendarsupport/
	grantleetheme/
	incidenceeditor-ng/
	kaddressbookgrantlee/
	mailcommon/
	mailimporter/
	messagecomposer/
	messagecore/
	messagelist/
	messageviewer/
	mailcommon/
	mailimporter/
	noteshared/
	pimcommon/
	templateparser/
"
KMEXTRA="
	agents/archivemailagent/
	agents/followupreminderagent/
	agents/mailfilteragent/
	grantleeeditor/headerthemeeditor/
	importwizard/
	kmailcvt/
	ksendemail/
	libksieve/
	mboximporter/
	pimsettingexporter/
	plugins/messageviewer/
"

KMLOADLIBS="kdepim-common-libs"

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

src_compile() {
	kde4-meta_src_compile kmail_xml
	kde4-meta_src_compile
}

pkg_postinst() {
	kde4-meta_pkg_postinst

	if ! has_version kde-apps/kdepim-kresources:${SLOT}; then
		echo
		elog "For groupware functionality, please install kde-apps/kdepim-kresources:${SLOT}"
		echo
	fi
	if ! has_version kde-apps/kleopatra:${SLOT}; then
		echo
		elog "For certificate management and the gnupg log viewer, please install kde-apps/kleopatra:${SLOT}"
		echo
	fi

	if has_version "kde-apps/akonadi[sqlite]"; then
		ewarn
		ewarn "We strongly recommend you set your Akonadi database backend to QMYSQL in your"
		ewarn "user configuration. This is the backend recommended by KDE upstream."
		ewarn "Reports indicate that kde-apps/kmail-4.10 does not work properly with the sqlite"
		ewarn "backend anymore."
		if has_version "kde-apps/akonadi[-mysql]"; then
			ewarn "FOR THAT, YOU WILL HAVE TO RE-BUILD kde-apps/akonadi WITH mysql USEFLAG ENABLED."
		fi
		ewarn "You can select the backend in your ~/.config/akonadi/akonadiserverrc."
		ewarn
	fi
}
