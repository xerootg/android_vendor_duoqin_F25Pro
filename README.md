# Proprietary vendor files for DuoQin Qin F25 Pro (`vendor/duoqin/F25Pro`)

Full-stock-parity vendor tree for the Qin F25 Pro (board
`AGN_4313R_RD_MX12832_69U`, MT8786/mt6768). Extracted **offline** from the
stock firmware dump's `super.img` → `vendor_a.img`, build
`AGN_4313R_RD_MX12832_69U.20251103` (vendor build
`SP1A.210812.016`/`1736163178`, VNDK 31, vendor security patch 2025-09-05).

## Layout

- `proprietary/vendor/` — byte-exact mirror of the stock vendor partition
  (symlinks preserved; `lost+found`, empty `rw.prop`, and the root
  `build.prop`/`ro.prop` removed — see below).
- `proprietary-files.txt` — the blob list, sectioned by subsystem. Plain
  entries become `PRODUCT_COPY_FILES`; `-`-prefixed `vendor/app` APKs are
  built as presigned `android_app_import` modules (see `Android.bp`).
- `F25Pro-vendor.mk` — generated product fragment (`PRODUCT_COPY_FILES` +
  `PRODUCT_PACKAGES`); inherit this from the device tree.
- `vendor-props.mk` — stock vendor `build.prop`/`ro.prop` curated into
  `PRODUCT_VENDOR_PROPERTIES` (650 props kept; the 42 the AOSP build
  system owns — fingerprints, build ids, VNDK/bionic/dalvik ISA,
  dynamic-partition/virtual-A/B flags — dropped to avoid conflicts).
- `symlinks.txt` — all 194 symlinks on the stock partition. The 180
  toybox/toolbox applet links regenerate if those binaries are ever built
  as modules; the ~14 lib links (`vulkan.mt6768.so`, `gatekeeper.default.so`,
  `mt6768/` dispatch libs, APK JNI links) must be recreated by the device
  tree (`BOARD_VENDORIMAGE_EXTRA_*` or init) — **not yet wired anywhere**.
- `extract-files.sh` — regenerates `proprietary/` + the generated files
  from a mounted stock vendor partition.

## Deliberately excluded from the build wiring

- `vendor/etc/vintf/manifest.xml` + `compatibility_matrix.xml` — present in
  the mirror, excluded from `PRODUCT_COPY_FILES`: the device tree owns VINTF
  at build time (`DEVICE_MANIFEST_FILE`), and shipping both collides.
- Root `build.prop`/`ro.prop` — imported as curated props (`vendor-props.mk`)
  instead of raw files, since the build generates its own vendor build.prop.

## Regenerating

```
simg2img super.img super.raw.img
lpunpack super.raw.img out/            # yields vendor_a.img
sudo mount -o ro,loop out/vendor_a.img /mnt/vendor
./extract-files.sh /mnt/vendor
```

Companion repos: `device/duoqin/F25Pro`
(github.com/xerootg/android_device_duoqin_F25Pro), kernel
(github.com/xerootg/linux-duoqin-f25pro).
