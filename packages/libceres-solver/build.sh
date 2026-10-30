TERMUX_PKG_HOMEPAGE="http://ceres-solver.org"
TERMUX_PKG_DESCRIPTION="C++ library for modeling and solving large, complicated optimization problems"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.2.0"
TERMUX_PKG_REVISION=6
TERMUX_PKG_SRCURL="https://github.com/ceres-solver/ceres-solver/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=12efacfadbfdc1bbfa203c236e96f4d3c210bed96994288b3ff0c8e7c6f350d4
TERMUX_PKG_DEPENDS="libc++, eigen3, google-glog, gflags"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_PREFIX_PATH=$TERMUX_PREFIX/opt/eigen3
-DBUILD_SHARED_LIBS=ON
-DMINIGLOG=ON
"
