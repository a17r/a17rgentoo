# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
EBZR_REPO_URI="lp:bzr-fastimport"
[[ ${PV} == 9999* ]] && inherit bzr
inherit distutils-r1

DESCRIPTION="Plugin providing fast loading of revision control data into Bazaar"
HOMEPAGE="https://launchpad.net/bzr-fastimport http://wiki.bazaar.canonical.com/BzrFastImport"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=">=dev-vcs/bzr-1.18
	>=dev-python/python-fastimport-0.9"
DEPEND=""

DOCS=( NEWS README.txt doc/notes.txt )

pkg_postinst() {
	elog "These commands need additional dependencies:"
	elog
	elog "bzr fast-export-from-darcs:  dev-vcs/darcs"
	elog "bzr fast-export-from-git:    dev-vcs/git"
	elog "bzr fast-export-from-hg:     dev-vcs/mercurial"
	elog "bzr fast-export-from-mtn:    dev-vcs/monotone"
	elog "bzr fast-export-from-svn:    dev-vcs/subversion[python]"
}
