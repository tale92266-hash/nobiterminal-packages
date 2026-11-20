TERMUX_PKG_HOMEPAGE=https://drobilla.net/software/lilv.html
TERMUX_PKG_DESCRIPTION="A C library to make the use of LV2 plugins as simple as possible for applications"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.28.0"
TERMUX_PKG_REVISION=1
# MIRROR (2026-11-20): download.drobilla.net times out / 403s intermittently for CI
# runners (curl 28, 30s; failed wave-1 c01/c05 for zix and w1r c05r for serd, verified 2026-11-20).
# Tarball below is byte-identical to the upstream release (SHA256 verified against the
# recipe; sourced from deb.debian.org orig tarball). Served from this repo so CI runners
# can fetch it. Regenerate on version bump.

TERMUX_PKG_SRCURL=https://raw.githubusercontent.com/tale92266-hash/nobiterminal-packages/master/mirror/lilv-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=8dcb70adb5cf072335115a6b091f4113710bdc73abaadaa3f9e9c1e55957b149
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libsndfile, libzix, lv2, serd, sord, sratom"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dbindings_py=disabled
"
