TERMUX_PKG_HOMEPAGE=https://codeberg.org/dnkl/foot
TERMUX_PKG_DESCRIPTION="Fast, lightweight and minimalistic Wayland terminal emulator"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.28.0"
# MIRROR (2026-11-09): Codeberg archive endpoint down since 2026-11-08
# (archive tarballs time out, git still works). Tarball below is byte-identical
# to the Codeberg archive (git archive --prefix=foot/ 1.28.0, same SHA256).
# Served from this repo so CI runners can fetch it. Regenerate on version bump.
TERMUX_PKG_SRCURL="https://raw.githubusercontent.com/tale92266-hash/nobiterminal-packages/master/mirror/foot-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=4296be402b5684d049534598e69db92b918f92beac9dab76b585207045f0b037
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-support, fontconfig, freetype, libfcft, libpixman, libwayland, libxkbcommon, utf8proc"
TERMUX_PKG_BUILD_DEPENDS="libtllist, libwayland-protocols, libwayland-cross-scanner, scdoc, xdg-utils"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Ddocs=enabled
-Dterminfo-base-name=foot-extra
-Dtests=false
"

termux_step_pre_configure() {
	termux_setup_wayland_cross_pkg_config_wrapper

	# libandroid-support provides this
	export CPPFLAGS+=" -D__STDC_ISO_10646__=201103L"
}
