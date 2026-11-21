TERMUX_PKG_HOMEPAGE=https://lv2plug.in/
TERMUX_PKG_DESCRIPTION="A plugin standard for audio systems"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.18.10
TERMUX_PKG_REVISION=8
# MIRROR (2026-11-20): lv2plug.in times out intermittently for CI runners
# (curl timeout; failed wave-2 c02r3, verified 2026-11-20). Tarball below is
# the genuine upstream release (SHA256 verified against the recipe;
# downloaded via VM). Served from this repo so CI runners can fetch it.
# Regenerate on version bump.
TERMUX_PKG_SRCURL="https://raw.githubusercontent.com/tale92266-hash/nobiterminal-packages/master/mirror/lv2-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=78c51bcf21b54e58bb6329accbb4dae03b2ed79b520f9a01e734bd9de530953f
TERMUX_PKG_DEPENDS="libxml2, libxslt, python, sord, python-pip, python-lxml"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-Dplugins=disabled"
TERMUX_PKG_PYTHON_TARGET_DEPS="pygments, rdflib"
