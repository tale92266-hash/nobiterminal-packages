TERMUX_PKG_HOMEPAGE="https://github.com/tareksander/termux-gui-bash"
TERMUX_PKG_DESCRIPTION="A bash library for Termux:GUI"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@tareksander"
TERMUX_PKG_VERSION="0.1.2"
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/tareksander/termux-gui-bash/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e915af020b8c32b9f26ccdff839befb1d8eb7cc231363c6d96868606b71dc8b2
TERMUX_PKG_HAS_DEBUG=false
TERMUX_PKG_DEPENDS="jq"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"

termux_step_post_get_source() {
	# CMakeLists.txt does set(CMAKE_C_FLAGS "-Os"), wiping the toolchain CFLAGS,
	# and CMake's Android module then compiles with the unversioned triple
	# aarch64-none-linux-android, which NDK r30 cdefs.h rejects. Bake the
	# versioned triple into the project's own CFLAGS.
	local _triple="${TERMUX_HOST_PLATFORM}${TERMUX_PKG_API_LEVEL}"
	sed -i 's/-Os"/-Os --target='"${_triple}"'"/' "$TERMUX_PKG_SRCDIR/CMakeLists.txt"
	grep -q -- "--target=${_triple}" "$TERMUX_PKG_SRCDIR/CMakeLists.txt"
}
