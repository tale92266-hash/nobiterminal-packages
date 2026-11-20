TERMUX_PKG_HOMEPAGE=https://mpg123.org/
TERMUX_PKG_DESCRIPTION="Fast console MPEG Audio Player and decoder library"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.33.7"
TERMUX_PKG_REVISION=1
# Flaky https://mpg123.org/download/mpg123-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/sourceforge/mpg123/mpg123-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=31d0e35a4ca567ec9b5ebda6c3062bb4435d6d3eacd6ef0d95cadd7854dc03ee
TERMUX_PKG_AUTO_UPDATE=true
# NOTE (NobiTerminal nightly 2026-10-21): pulseaudio BUILD_DEPENDS removed.
# It creates a dependency cycle (libsndfile -> libmpg123 -> pulseaudio -> libsndfile)
# that breaks from-source topological ordering: pulseaudio hard-requires libsndfile
# (meson fails without it), while libmpg123 only uses pulseaudio for an optional
# output plugin (builds fine without it, verified). Removing this edge breaks the
# cycle at the correct (soft) place.
# TERMUX_PKG_BUILD_DEPENDS="pulseaudio"
# NOTE (NobiTerminal B-cycle trial 2026-11-20): the cycle SURVIVED via the mpg123
# subpackage (mpg123.subpackage.sh TERMUX_SUBPKG_DEPENDS="pulseaudio") — buildorder.py
# merges subpackage deps into the parent, so the pulseaudio BUILD_DEPENDS fix alone
# changed nothing (libsndfile was already in pulseaudio's DEPENDS; ffmpeg order kept
# pulseaudio 109 before libsndfile 114). ANTI_BUILD_DEPENDS below cuts the soft edge
# for build ordering only; the mpg123 CLI still declares pulseaudio as a runtime dep.
TERMUX_PKG_ANTI_BUILD_DEPENDS="pulseaudio"
TERMUX_PKG_BREAKS="mpg123 (<< 1.33.1-1)"
TERMUX_PKG_REPLACES="mpg123 (<< 1.33.1-1)"
