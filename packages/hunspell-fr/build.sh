TERMUX_PKG_HOMEPAGE=https://hunspell.github.io
TERMUX_PKG_DESCRIPTION="French dictionary for hunspell"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=20221031
TERMUX_PKG_REVISION=2
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	mkdir -p $TERMUX_PREFIX/share/hunspell/
	# On checksum mismatch the files may have been updated:
	#  https://cgit.freedesktop.org/libreoffice/dictionaries/log/fr_FR/fr.aff
	#  https://cgit.freedesktop.org/libreoffice/dictionaries/log/fr_FR/fr.dic
	# In which case we need to bump version and checksum used.
	termux_download https://raw.githubusercontent.com/LibreOffice/dictionaries/master/fr_FR/dictionaries/fr.aff \
					$TERMUX_PREFIX/share/hunspell/fr_FR.aff \
					c176610cd5dc4846806a65ddd029f422d87978bf58f224aa44222662a16a2de5
	termux_download https://raw.githubusercontent.com/LibreOffice/dictionaries/master/fr_FR/dictionaries/fr.dic \
					$TERMUX_PREFIX/share/hunspell/fr_FR.dic \
					b78a868e31dd6e373b6c3217969afb898a9acde828a5e7ef97308da42218c88c
	touch $TERMUX_PREFIX/share/hunspell/fr_FR.{aff,dic}
}
