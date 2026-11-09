TERMUX_PKG_HOMEPAGE=http://alpine.x10host.com/
TERMUX_PKG_DESCRIPTION="Fast, easy to use email client"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.26
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://fossies.org/linux/misc/alpine-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=c0779c2be6c47d30554854a3e14ef5e36539502b331068851329275898a9baba
TERMUX_PKG_DEPENDS="coreutils, libcrypt, ncurses, openssl, openssl-tool"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-debug
--with-c-client-target=lnx
--without-krb5
--without-ldap
--without-pthread
--without-tcl
--with-system-pinerc=${TERMUX_PREFIX}/etc/pine.conf
--with-passfile=$TERMUX_ANDROID_HOME/.pine-passfile
--with-ssl-dir=$TERMUX_PREFIX
--with-ssl-certs-dir=$TERMUX_PREFIX/etc/ssl/certs
--with-ssl-key-dir=$TERMUX_PREFIX/etc/ssl/private
"
TERMUX_PKG_BUILD_IN_SRC=true

termux_pkg_auto_update() {
	local latest_version
	latest_version="$(curl --silent https://alpineapp.email/alpine/release/src/ | grep -oP 'alpine-\K[0-9]+(\.[0-9]+)+(?=\.tar\.xz)' | sort -V | tail -n1)"

	if [[ -z "${latest_version}" ]]; then
		echo "WARN: Unable to get the latest version." >&2
		return
	fi

	termux_pkg_upgrade_version "${latest_version}"
}

termux_step_pre_configure() {
	export TCC=$CC
	export TRANLIB=$RANLIB
	export SPELLPROG=${TERMUX_PREFIX}/bin/hunspell
	export alpine_SSLVERSION=old
	export TPATH=$PATH

	export LIBS="-lcrypt"

	# To get S_IREAD and friends:
	CPPFLAGS+=" -D__USE_BSD"

	cp $TERMUX_PKG_BUILDER_DIR/pine.conf $TERMUX_PREFIX/etc/pine.conf

	touch $TERMUX_PKG_SRCDIR/imap/lnxok

	# cfix75 (2026-11-09): the tarball ships stale gettext-0.16.1 macros
	# (m4/gettext.m4 serial 59, 2006-era) that loop aclocal 1.18
	# ("aclocal: error: too many loops" at the system's m4/intlmacosx.m4,
	# W22R r01 run 42588270151). Delete them so autoreconf regenerates
	# the gettext set from the system's consistent modern macros.
	# Keep the custom macros configure.ac needs (AX_PROG_CC_FOR_BUILD,
	# ACX_PTHREAD) and the libtool set (aclocal re-installs those anyway).
	rm -f m4/codeset.m4 m4/gettext.m4 m4/glibc2.m4 m4/glibc21.m4 m4/iconv.m4 \
	      m4/intdiv0.m4 m4/intl.m4 m4/intldir.m4 m4/intmax.m4 m4/inttypes-pri.m4 \
	      m4/inttypes.m4 m4/inttypes_h.m4 m4/isc-posix.m4 m4/lcmessage.m4 \
	      m4/lib-ld.m4 m4/lib-link.m4 m4/lib-prefix.m4 m4/lock.m4 \
	      m4/longdouble.m4 m4/longlong.m4 m4/nls.m4 m4/po.m4 \
	      m4/printf-posix.m4 m4/progtest.m4 m4/size_max.m4 m4/stdint_h.m4 \
	      m4/uintmax_t.m4 m4/ulonglong.m4 m4/visibility.m4 m4/wchar_t.m4 \
	      m4/wint_t.m4 m4/xsize.m4
	autoreconf -fi
}

termux_step_post_configure() {
	cd pith
	$CC_FOR_BUILD help_c_gen.c -o help_c_gen
	$CC_FOR_BUILD help_h_gen.c -o help_h_gen
	touch -d "next hour" help_c_gen help_h_gen
}

termux_step_create_debscripts() {
	echo "#!$TERMUX_PREFIX/bin/sh" >> postinst
	echo "if [ ! -e $TERMUX_ANDROID_HOME/.alpine-smime/.pwd/MasterPassword.crt ] && [ ! -e $HOME/.alpine-smime/.pwd/MasterPassword.key ]; then" >> postinst
	echo "echo 'warning making a passwordless masterpasword file'" >> postinst
	echo "mkdir -p \$HOME/.alpine-smime/public \$HOME/.alpine-smime/.pwd \$HOME/.alpine-smime/private \$HOME/.alpine-smime/ca" >> postinst
	echo "openssl req -x509 -newkey rsa:2048 -keyout \$HOME/.alpine-smime/.pwd/MasterPassword.key -out \$HOME/.alpine-smime/.pwd/MasterPassword.crt -days 10000 -nodes -subj '/C=US/ST=dont/L=use/O=this Name/OU=for/CN=anything.com.termux'" >> postinst
	echo "touch \$HOME/.pine-passfile" >> postinst
	echo "fi" >> postinst
}
