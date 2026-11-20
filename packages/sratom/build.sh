TERMUX_PKG_HOMEPAGE=https://drobilla.net/software/sratom.html
TERMUX_PKG_DESCRIPTION="A small library for serialising LV2 atoms to and from RDF"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.6.22"
TERMUX_PKG_REVISION=1
# MIRROR (2026-11-20): download.drobilla.net times out / 403s intermittently for CI
# runners (curl 28, 30s; failed wave-1 c01/c05 for zix and w1r c05r for serd, verified 2026-11-20).
# Tarball below is byte-identical to the upstream release (SHA256 verified against the
# recipe; sourced from deb.debian.org orig tarball). Served from this repo so CI runners
# can fetch it. Regenerate on version bump.

TERMUX_PKG_SRCURL=https://raw.githubusercontent.com/tale92266-hash/nobiterminal-packages/master/mirror/sratom-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=0209b7d0f22c96abb416722ed735b0933be47931ecff4aa4b26ded7760b4f252
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="lv2, serd, sord"
