# shellcheck shell=bash
# This provides an utility function to setup iserv (external interpreter of ghc) to cross-compile haskell-template.
termux_setup_ghc_iserv() {
	local TERMUX_ISERV_BIN="$TERMUX_COMMON_CACHEDIR/iserv-bin-$TERMUX_ARCH"
	local TERMUX_ISERV_BIN_NAME="termux-ghc-iserv"

	termux_setup_proot

	export PATH="$TERMUX_ISERV_BIN:$PATH"

	[[ -d "$TERMUX_ISERV_BIN" ]] && return

	# cfix76 (2026-11-09): the ghc-cross iserv binary (termux/ghc-cross-tools)
	# has RUNPATH /data/data/com.termux/files/usr/lib (official prefix) and
	# DT_NEEDEDs libandroid-posix-semaphore.so etc. The fork prefix is
	# /data/data/com.nobiterminal/files/usr, so inside proot (-R /) that
	# RUNPATH is dead and the Android linker cannot load ghc-iserv
	# ("CANNOT LINK EXECUTABLE .../ghc-iserv: library
	# libandroid-posix-semaphore.so not found", W22R r02). Symlink the
	# official app dir to the fork app dir so the RUNPATH resolves.
	# Per-job (container-ephemeral); guarded so a second Haskell package
	# in the same job does not re-create it.
	local TERMUX_APP_DIR="${TERMUX_PREFIX%/files/usr}"
	[[ -e /data/data/com.termux ]] || ln -s "$TERMUX_APP_DIR" /data/data/com.termux

	mkdir -p "$TERMUX_ISERV_BIN"

	local ghc_bin_dir
	ghc_bin_dir="$(ghc --print-libdir)/../bin"

	cat <<-EOF >"$TERMUX_ISERV_BIN/$TERMUX_ISERV_BIN_NAME"
		#!/bin/bash
		termux-proot-run $ghc_bin_dir/ghc-iserv "\$@"
	EOF

	cat <<-EOF >"$TERMUX_ISERV_BIN/${TERMUX_ISERV_BIN_NAME/iserv/iserv-dyn}"
		#!/bin/bash
		termux-proot-run $ghc_bin_dir/ghc-iserv-dyn "\$@"
	EOF

	chmod +x "$TERMUX_ISERV_BIN/$TERMUX_ISERV_BIN_NAME"
	chmod +x "$TERMUX_ISERV_BIN/${TERMUX_ISERV_BIN_NAME/iserv/iserv-dyn}"
}
