TERMUX_PKG_HOMEPAGE=https://github.com/gjk-cat/cat-prep
TERMUX_PKG_DESCRIPTION="A preprocessor for mdbook which provides teacher, subject, material and tag functionality"
TERMUX_PKG_LICENSE="Fair"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=fbf5ca360337452ca5ef7437d64c2efd7d891aec
TERMUX_PKG_VERSION=1.0.9
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=git+https://github.com/gjk-cat/cat-prep
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_BUILD_IN_SRC=true

# https://github.com/termux/termux-packages/issues/16756
TERMUX_RUST_VERSION=1.68.2

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout $_COMMIT

	local ver=$(sed -En 's/^version = "([^"]+)".*/\1/p' Cargo.toml)
	if [ "${ver}" != "${TERMUX_PKG_VERSION#*:}" ]; then
		termux_error_exit "Version string '$TERMUX_PKG_VERSION' does not seem to be correct."
	fi
}

termux_step_pre_configure() {
	termux_setup_rust

	# NDK-r30 sys/cdefs.h:365 rejects the unversioned --target=aarch64-linux-android
	# triple the cc crate (via backtrace-sys 0.1.33) passes. The guard keys on
	# __ANDROID_MIN_SDK_VERSION__ (NOT __ANDROID_API__ — cfix43/cfix45 proved
	# the API define alone does not satisfy it; the driver defines both macros
	# only for versioned triples). Define both. The cc crate prefers the
	# target-specific CFLAGS_aarch64_linux_android, which the toolchain setup
	# snapshots BEFORE pre_configure runs, so the defines must be appended to
	# that variable too (plain CFLAGS alone never reaches the compile).
	CFLAGS+=" -D__ANDROID_API__=$TERMUX_PKG_API_LEVEL -D__ANDROID_MIN_SDK_VERSION__=$TERMUX_PKG_API_LEVEL"
	CFLAGS_aarch64_linux_android+=" -D__ANDROID_API__=$TERMUX_PKG_API_LEVEL -D__ANDROID_MIN_SDK_VERSION__=$TERMUX_PKG_API_LEVEL"
	export CFLAGS CFLAGS_aarch64_linux_android

	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME

	cargo fetch --target "${CARGO_TARGET_NAME}"

	local _patch=$TERMUX_PKG_BUILDER_DIR/mdbook-src-renderer-html_handlebars-helpers-navigation.rs.diff
	local d
	for d in $CARGO_HOME/registry/src/*/mdbook-*; do
		patch --silent -p1 -d ${d} < ${_patch} || :
	done
}

termux_step_make() {
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/mdbook-cat-prep
}
