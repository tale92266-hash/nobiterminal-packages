TERMUX_PKG_HOMEPAGE=https://drobilla.net/software/suil.html
TERMUX_PKG_DESCRIPTION="A library for loading and wrapping LV2 plugin UIs"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.10.26"
TERMUX_PKG_REVISION=1
# MIRROR (2026-11-20): download.drobilla.net times out / 403s intermittently for CI
# runners (curl 28, 30s; failed wave-1 c01/c05 for zix and w1r c05r for serd, verified 2026-11-20).
# Tarball below is byte-identical to the upstream release (SHA256 verified against the
# recipe; sourced from deb.debian.org orig tarball). Served from this repo so CI runners
# can fetch it. Regenerate on version bump.

TERMUX_PKG_SRCURL=https://raw.githubusercontent.com/tale92266-hash/nobiterminal-packages/master/mirror/suil-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=62808916602c47d201a1ec2d246323a8048243f2bf972f859f0db1db4662ee43
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="lv2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dgtk2=disabled
-Dgtk3=disabled
-Dqt5=disabled
-Dx11=disabled
-Ddocs=disabled
"
