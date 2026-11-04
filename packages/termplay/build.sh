TERMUX_PKG_HOMEPAGE=https://gitlab.com/jD91mZM2/termplay
TERMUX_PKG_DESCRIPTION="Plays an image/video in your terminal"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.0.6
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://gitlab.com/jD91mZM2/termplay/-/archive/v${TERMUX_PKG_VERSION}/termplay-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=fba29bf75640c698079b22eeb05e3fdc81c8abc7b232bd9b6752f267aa5405e0
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="glib, gst-plugins-base, gstreamer, libsixel"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	# NDK r30 sys/cdefs.h rejects unversioned triples (cc crate passes
	# --target=aarch64-linux-android); defining __ANDROID_API__ satisfies it.
	export CFLAGS_aarch64_linux_android+=" -D__ANDROID_API__=${TERMUX_PKG_API_LEVEL}"
}

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release \
		--features bin
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/termplay
}
