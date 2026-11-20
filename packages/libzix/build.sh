TERMUX_PKG_HOMEPAGE=https://drobilla.net/category/zix
TERMUX_PKG_DESCRIPTION="lightweight C99 portability and data structure library"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.6.2"
TERMUX_PKG_REVISION=2
# MIRROR (2026-11-20): download.drobilla.net times out intermittently for CI
# runners (curl 28, 30s; failed wave-1 c01 and c05, verified 2026-11-20).
# Tarball below is byte-identical to the upstream release (SHA256 verified
# against the recipe; sourced from deb.debian.org zix_0.6.2.orig.tar.xz).
# Served from this repo so CI runners can fetch it. Regenerate on version bump.
TERMUX_PKG_SRCURL=https://raw.githubusercontent.com/tale92266-hash/nobiterminal-packages/master/mirror/zix-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=4bc771abf4fcf399ea969a1da6b375f0117784f8fd0e2db356a859f635f616a7
TERMUX_PKG_AUTO_UPDATE=true
