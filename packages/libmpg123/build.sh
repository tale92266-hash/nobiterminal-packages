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
TERMUX_PKG_BREAKS="mpg123 (<< 1.33.1-1)"
TERMUX_PKG_REPLACES="mpg123 (<< 1.33.1-1)"
