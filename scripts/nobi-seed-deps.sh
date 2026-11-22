#!/bin/bash
# nobi-seed-deps.sh — seed already-hosted dependency debs into the container
# prefix so the build system treats them as already built and skips them.
#
# Usage (inside the package-builder container, from the repo root):
#   ./scripts/nobi-seed-deps.sh <manifest-name>
#   e.g. ./scripts/nobi-seed-deps.sh mesa
#   reads ./scripts/nobi-seed/<manifest-name>.txt
#
# Manifest format (one entry per line, '#' comments, blank lines ignored):
#   PKG <package> <fullversion> <sha256> <url>
#   MARKER <package> <fullversion>
#
# For each PKG line the script downloads the deb, verifies its SHA256
# against the manifest, and extracts data.tar.xz into the container root
# with exactly the same command the build system's -I branch uses
# (termux_step_get_dependencies.sh), so paths land under the NobiTerminal
# prefix /data/data/com.nobiterminal/files/usr.
# For each MARKER line it writes /data/data/.built-packages/<package>
# with the fullversion as content — the same file
# termux_step_finish_build writes after a real build. The build system's
# start_build skip check (termux_step_start_build.sh) then prints
# "<pkg>@<version> built - skipping" and exits 0 instead of rebuilding.
#
# Fail-fast: any download/verify/extract failure aborts the whole run
# (the CI build must never proceed on a half-seeded prefix).
# The normal (unseeded) build path is untouched: this script only runs
# when the workflow is dispatched with a seed manifest name.
set -euo pipefail

if [ $# -ne 1 ]; then
	echo "Usage: $0 <manifest-name>" >&2
	exit 2
fi
MANIFEST_NAME="$1"

SCRIPTDIR="$(cd "$(dirname "$0")" && pwd)"
# Repo root is the parent of scripts/ when run from the checkout; fall
# back to the current directory (the container WORKDIR is the repo root).
if [ -d "$SCRIPTDIR/nobi-seed" ]; then
	MANIFEST="$SCRIPTDIR/nobi-seed/$MANIFEST_NAME.txt"
elif [ -d "./scripts/nobi-seed" ]; then
	MANIFEST="./scripts/nobi-seed/$MANIFEST_NAME.txt"
else
	echo "nobi-seed-deps: manifest directory not found" >&2
	exit 2
fi
[ -f "$MANIFEST" ] || { echo "nobi-seed-deps: no such manifest: $MANIFEST" >&2; exit 2; }

BUILT_PACKAGES_DIR="${NOBI_SEED_BUILT_DIR:-/data/data/.built-packages}"
EXTRACT_ROOT="${NOBI_SEED_EXTRACT_ROOT:-/}"
SEED_CACHE="${NOBI_SEED_CACHE:-/tmp/nobi-seed-deps}"
mkdir -p "$SEED_CACHE"

# The prefix tree may not exist yet (the seed step runs before any build)
# and may not be writable by the builder user. Use sudo only if needed.
SUDO=""
if ! mkdir -p "$EXTRACT_ROOT/data/data" 2>/dev/null || ! touch "$EXTRACT_ROOT/data/data/.nobi-seed-write-test" 2>/dev/null; then
	if command -v sudo >/dev/null 2>&1; then
		echo "nobi-seed-deps: $EXTRACT_ROOT/data/data not writable, using sudo"
		SUDO="sudo"
	else
		echo "nobi-seed-deps: $EXTRACT_ROOT/data/data not writable and no sudo available" >&2
		exit 1
	fi
else
	rm -f "$EXTRACT_ROOT/data/data/.nobi-seed-write-test"
fi
$SUDO mkdir -p "$BUILT_PACKAGES_DIR"

echo "nobi-seed-deps: manifest $MANIFEST"
PKG_COUNT=0
MARKER_COUNT=0
while IFS= read -r line || [ -n "$line" ]; do
	# Strip comments and skip blanks.
	case "$line" in
		''|'#'*) continue ;;
	esac
	set -- $line
	kind="$1"
	if [ "$kind" = "PKG" ]; then
		pkg="$2"; ver="$3"; want_sha="$4"; url="$5"
		[ -n "$pkg" ] && [ -n "$ver" ] && [ -n "$want_sha" ] && [ -n "$url" ] \
			|| { echo "nobi-seed-deps: malformed PKG line: $line" >&2; exit 1; }
		deb="$SEED_CACHE/$pkg.deb"
		echo "nobi-seed-deps: SEED $pkg@$ver"
		# Reuse a cached download only if its hash already matches.
		if [ -f "$deb" ]; then
			got_sha="$(sha256sum "$deb" | cut -d' ' -f1)"
			[ "$got_sha" = "$want_sha" ] || rm -f "$deb"
		fi
		if [ ! -f "$deb" ]; then
			curl -fsSL --retry 3 --retry-delay 5 --max-time 600 -o "$deb" "$url" \
				|| { echo "nobi-seed-deps: download FAILED for $pkg ($url)" >&2; exit 1; }
		fi
		got_sha="$(sha256sum "$deb" | cut -d' ' -f1)"
		[ "$got_sha" = "$want_sha" ] \
			|| { echo "nobi-seed-deps: SHA256 MISMATCH for $pkg: got $got_sha want $want_sha" >&2; exit 1; }
		# Same extraction as the build system's -I branch.
		$SUDO sh -c "ar p '$deb' data.tar.xz | tar xJ --no-overwrite-dir --transform='s#^.\$#data#' -C '$EXTRACT_ROOT'" \
			|| { echo "nobi-seed-deps: extract FAILED for $pkg" >&2; exit 1; }
		PKG_COUNT=$((PKG_COUNT + 1))
	elif [ "$kind" = "MARKER" ]; then
		pkg="$2"; ver="$3"
		[ -n "$pkg" ] && [ -n "$ver" ] \
			|| { echo "nobi-seed-deps: malformed MARKER line: $line" >&2; exit 1; }
		echo "$ver" | $SUDO tee "$BUILT_PACKAGES_DIR/$pkg" >/dev/null
		MARKER_COUNT=$((MARKER_COUNT + 1))
	else
		echo "nobi-seed-deps: unknown line kind '$kind': $line" >&2
		exit 1
	fi
done < "$MANIFEST"

echo "nobi-seed-deps: SEED DONE: $PKG_COUNT packages extracted, $MARKER_COUNT markers written to $BUILT_PACKAGES_DIR"
