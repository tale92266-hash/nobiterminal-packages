TERMUX_PKG_HOMEPAGE=https://drobilla.net/software/serd.html
TERMUX_PKG_DESCRIPTION="A lightweight C library for RDF syntax"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.32.10"
TERMUX_PKG_REVISION=1
# MIRROR (2026-11-20): download.drobilla.net times out / 403s intermittently for CI
# runners (curl 28, 30s; failed wave-1 c01/c05 for zix and w1r c05r for serd, verified 2026-11-20).
# Tarball below is byte-identical to the upstream release (SHA256 verified against the
# recipe; sourced from deb.debian.org orig tarball). Served from this repo so CI runners
# can fetch it. Regenerate on version bump.

TERMUX_PKG_SRCURL=https://raw.githubusercontent.com/tale92266-hash/nobiterminal-packages/master/mirror/serd-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=b0e93b49e52f01a049475b7886ef140407115a32d3b1e5dc5f95141c88275d1c
TERMUX_PKG_AUTO_UPDATE=true
