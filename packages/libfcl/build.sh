TERMUX_PKG_HOMEPAGE="https://github.com/flexible-collision-library/fcl"
TERMUX_PKG_DESCRIPTION="Flexible collision library"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="Pooya Moradi <pvonmoradi@gmail.com>"
TERMUX_PKG_VERSION="0.7.0"
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL="https://github.com/flexible-collision-library/fcl/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=90409e940b24045987506a6b239424a4222e2daf648c86dd146cbcb692ebdcbc
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_DEPENDS="libandroid-support, libc++, libccd, octomap"
TERMUX_PKG_BUILD_DEPENDS="eigen, octomap-static"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DFCL_STATIC_LIBRARY=OFF
-DFCL_USE_HOST_NATIVE_ARCH=OFF
-DFCL_WITH_OCTOMAP=ON
-DCMAKE_CXX_STANDARD=14
"

termux_step_pre_configure() {
	# fcl's CMakeLists sets PKG_CFLAGS="-std=c++11" (pkg-config export);
	# consumers compiling against Eigen via fcl need c++14 too.
	sed -i 's/-std=c++11/-std=c++14/' CMakeLists.txt
}

termux_step_post_configure() {
	# A late -std=c++11 from a linked interface target overrides the
	# -std=gnu++14 from CMAKE_CXX_STANDARD on the compile line (r01 proof).
	# Rewrite it in the generated build files. v2's bare grep|xargs pipeline
	# aborted the build (exit 2) when an operand was missing (generator/cwd
	# mismatch), so v3 is guarded and can never fail the build.
	local d="${TERMUX_PKG_BUILDDIR:-.}"
	for f in "$d/build.ninja" "$d/rules.ninja"; do
		[ -f "$f" ] && sed -i 's/-std=c++11/-std=c++14/g' "$f" || true
	done
	if [ -d "$d/CMakeFiles" ]; then
		grep -rl -- '-std=c++11' "$d/CMakeFiles/" 2>/dev/null | xargs -r sed -i 's/-std=c++11/-std=c++14/g' || true
	fi
	return 0
}
