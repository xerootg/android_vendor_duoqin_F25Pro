#!/bin/bash
#
# Regenerate the proprietary/ mirror of this tree from a mounted stock
# vendor partition (or a rooted device via `adb pull`-style sources is NOT
# supported here - mount the stock vendor image instead, see README.md).
#
# Usage: ./extract-files.sh /path/to/mounted/vendor
#
set -euo pipefail

SRC="${1:?usage: $0 /path/to/mounted/vendor}"
REPO="$(cd "$(dirname "$0")" && pwd)"

[ -f "$SRC/build.prop" ] || { echo "error: $SRC does not look like a vendor partition" >&2; exit 1; }

echo "Mirroring $SRC -> $REPO/proprietary/vendor"
rm -rf "$REPO/proprietary/vendor"
mkdir -p "$REPO/proprietary/vendor"
# -a preserves symlinks (documented in symlinks.txt, excluded from the
# generated blob list). May need sudo if the mount is root-owned.
cp -a "$SRC"/. "$REPO/proprietary/vendor/"
rm -rf "$REPO/proprietary/vendor/lost+found" \
       "$REPO/proprietary/vendor/rw.prop"
# Root prop files are imported as curated PRODUCT_VENDOR_PROPERTIES in
# vendor-props.mk, not shipped as blobs.
cp "$REPO/proprietary/vendor/build.prop" /tmp/f25_vendor_build.prop
cp "$REPO/proprietary/vendor/ro.prop"    /tmp/f25_vendor_ro.prop
rm -f "$REPO/proprietary/vendor/build.prop" "$REPO/proprietary/vendor/ro.prop"

echo "Regenerating proprietary-files.txt / F25Pro-vendor.mk / Android.bp"
python3 "$REPO/gen_vendor_tree.py"

echo "Done. Review 'git status' and re-curate vendor-props.mk if the stock"
echo "build changed (see the DROP_PREFIXES list in the session notes)."
