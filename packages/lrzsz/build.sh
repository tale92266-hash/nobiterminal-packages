TERMUX_PKG_HOMEPAGE=https://ohse.de/uwe/software/lrzsz.html
TERMUX_PKG_DESCRIPTION="Tools for zmodem/xmodem/ymodem file transfer"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.13.1
TERMUX_PKG_REVISION=0
_COMMIT=e97e41a6bc0e86b47b2bfb6b3b5db2d3fc1907b6
TERMUX_PKG_SRCURL=https://github.com/UweOhse/lrzsz/archive/$_COMMIT.tar.gz
TERMUX_PKG_SHA256=582828a0e1faacac002787e3ccd918e94bf716e45ebbc0de7dbaad18fabe72be
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_METHOD=repology
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-syslog
--mandir=$TERMUX_PREFIX/share/man
"

termux_step_pre_configure() {
	# 0.13.1 git tree lacks config.rpath (vendored m4/ + po/ only); autoreconf
	# skips autopoint, so automake fails. Supply it from the autopoint install.
	for _f in /usr/share/gettext/config.rpath /usr/local/share/gettext/config.rpath; do
		if [ -f "$_f" ]; then cp "$_f" ./config.rpath; break; fi
	done
	[ -f ./config.rpath ] || { echo "config.rpath not found" >&2; return 1; }
	if [ ! -f ./po/Makefile.in.in ]; then
		for _f in /usr/share/gettext/po/Makefile.in.in /usr/local/share/gettext/po/Makefile.in.in; do
			if [ -f "$_f" ]; then cp "$_f" ./po/Makefile.in.in; break; fi
		done
	fi
	[ -f ./po/Makefile.in.in ] || { echo "po/Makefile.in.in not found" >&2; return 1; }
	autoreconf -vfi
}
