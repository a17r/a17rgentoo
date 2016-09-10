# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_AUTODEPS="false"
KDE_HANDBOOK="optional"
KDE_L10N=(
	ar ast bg bs ca ca-valencia cs da de el en-GB eo es et eu fa fi fr ga gl he
	hi hr hu ia id is it ja kk km ko lt lv mr nb nds nl nn pa pl pt pt-BR ro ru
	sk sl sv tr ug uk wa zh-CN zh-TW
)
inherit kde4-base

DESCRIPTION="KDE Plasma 4 internationalization package"

SLOT="4"
KEYWORDS="~amd64 ~arm ~x86"

DEPEND="
	kde-base/kdelibs:4
	sys-devel/gettext
"
RDEPEND="
	kde-apps/kde4-l10n:4
"

REMOVE_DIRS="${FILESDIR}/${PN}-4.11.22-remove-dirs"
REMOVE_MSGS="${FILESDIR}/${PN}-4.11.22-remove-messages"

IUSE="aqua test $(printf 'l10n_%s ' ${KDE_L10N[@]})" # TODO: Drop aqua as soon as possible

_kde_l10n2lingua() {
	local l
	for l; do
		case ${l} in
			ca-valencia) echo ca@valencia;;
			sr-ijekavsk) echo sr@ijekavian;;
			sr-Latn-ijekavsk) echo sr@ijekavianlatin;;
			sr-Latn) echo sr@latin;;
			uz-Cyrl) echo uz@cyrillic;;
			*) echo "${l/-/_}";;
		esac
	done
}

URI_BASE="mirror://kde/unstable/kde-workspace/${PV}/kde-l10n/${PN/plasma/kde}"
SRC_URI=""
for my_l10n in ${KDE_L10N[@]} ; do
	case ${my_l10n} in
		sr | sr-ijekavsk | sr-Latn-ijekavsk | sr-Latn)
			SRC_URI="${SRC_URI} l10n_${my_l10n}? ( ${URI_BASE}-sr-${PV}.tar.xz )"
			;;
		*)
			SRC_URI="${SRC_URI} l10n_${my_l10n}? ( ${URI_BASE}-$(_kde_l10n2lingua ${my_l10n})-${PV}.tar.xz )"
			;;
	esac
done
unset my_l10n

pkg_setup() {
	if [[ -z ${A} ]]; then
		elog
		elog "None of the requested L10N are supported by ${P}."
		elog
		elog "${P} supports these language codes:"
		elog "${KDE_L10N[@]}"
		elog
	fi
	[[ -n ${A} ]] && kde4-base_pkg_setup
}

src_unpack() {
	mkdir -p "${S}" || die "Failed to create source dir ${S}"
	cd "${S}"
	for my_tar in ${A}; do
		tar -xpf "${DISTDIR}/${my_tar}" --xz 2> /dev/null ||
			elog "${my_tar}: tar extract command failed at least partially - continuing"
	done
}

src_prepare() {
	default
	[[ -n ${A} ]] || return

	# add all l10n directories to cmake
	cat <<-EOF > CMakeLists.txt || die
project(${PN})
cmake_minimum_required(VERSION 2.8.12)
$(printf "add_subdirectory( %s )\n" \
	`find . -mindepth 1 -maxdepth 1 -type d | sed -e "s:^\./::"`)
EOF

	# this collides with kde4-l10n
	find -mindepth 5 -maxdepth 5 -type f -name CMakeLists.txt -exec \
		sed -i -e '/entry.desktop/ s/^/#DONT/' {} + || die

	_l10n_conflict_removal
}

_l10n_conflict_removal() {
	einfo "Removing file collisions with KDE Frameworks"
	[[ -f ${REMOVE_DIRS} ]] || die "Error: ${REMOVE_DIRS} not found!"
	[[ -f ${REMOVE_MSGS} ]] || die "Error: ${REMOVE_MSGS} not found!"

	use test && einfo "Tests enabled: Listing LINGUAS causing file collisions"

	einfo "Directories..."
	while read path; do
		if use test ; then	# build a report w/ L10N="*" to submit @upstream
			local lngs
			for lng in $(_kde_l10n2lingua ${KDE_L10N[@]}); do
				SDIR="${S}/${PN/plasma/kde}-${lng}-${PV}/4/${lng}"
				if [[ -d "${SDIR}"/${path%\ *}/${path#*\ } ]] ; then
					lngs+=" ${lng}"
				fi
			done
			[[ -n "${lngs}" ]] && einfo "${path%\ *}/${path#*\ }${lngs}"
			unset lngs
		fi
		if ls -U ./*/4/*/${path%\ *}/${path#*\ } > /dev/null 2>&1; then
			sed -e "\:add_subdirectory(\s*${path#*\ }\s*): s:^:#:" \
				-i ./*/4/*/${path%\ *}/CMakeLists.txt || \
				die "Failed to comment out ${path}"
		else
			einfo "F: ${path}"	# run with L10N="*" to cut down list
		fi
	done < <(grep -ve "^$\|^\s*\#" "${REMOVE_DIRS}")
	einfo
	einfo "Messages..."
	while read path; do
		if use test ; then	# build a report w/ L10N="*" to submit @upstream
			local lngs
			for lng in $(_kde_l10n2lingua ${KDE_L10N[@]}); do
				SDIR="${S}/${PN/plasma/kde}-${lng}-${PV}/4/${lng}"
				if [[ -e "${SDIR}"/messages/${path} ]] ; then
					lngs+=" ${lng}"
				fi
			done
			[[ -n "${lngs}" ]] && einfo "${path}${lngs}"
			unset lngs
		fi
		if ls -U ./*/4/*/messages/${path} > /dev/null 2>&1; then
			rm ./*/4/*/messages/${path} || die "Failed to remove ${path}"
		else
			einfo "F: ${path}"	# run with L10N="*" to cut down list
		fi
	done < <(grep -ve "^$\|^\s*\#" "${REMOVE_MSGS}")
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_docs=$(usex handbook)
	)
	[[ -n ${A} ]] && kde4-base_src_configure
}

src_compile() {
	[[ -n ${A} ]] && kde4-base_src_compile
}

src_test() { :; }

src_install() {
	[[ -n ${A} ]] && kde4-base_src_install
}
