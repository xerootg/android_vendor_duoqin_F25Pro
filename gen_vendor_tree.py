#!/usr/bin/env python3
"""Generate proprietary-files.txt, F25Pro-vendor.mk, Android.bp for the
DuoQin F25Pro vendor tree from the extracted proprietary/ mirror."""
import os, re, sys

REPO = "/home/xero/repos/android_vendor_duoqin_F25Pro"
PROP = os.path.join(REPO, "proprietary")

# Files present in the mirror but deliberately NOT wired into the build.
EXCLUDE = {
    # Device tree owns VINTF for the build; stock copies kept in mirror only.
    "vendor/etc/vintf/manifest.xml",
    "vendor/etc/vintf/compatibility_matrix.xml",
}

SECTIONS = [
    ("A-GPS / GNSS", [r"gps", r"mnld", r"agps", r"geofence", r"lbs"]),
    ("Audio", [r"audio", r"aurisys", r"speech", r"smartpa", r"aw883", r"/sound/",
               r"nvram_aud", r"vow", r"besloudness", r"blisrc", r"a3m", r"acf\b"]),
    ("Bluetooth", [r"bluetooth", r"\bbt_", r"/bt", r"btaudio"]),
    ("Camera", [r"camera", r"mtkcam", r"imgsensor", r"flashlight", r"hal3a",
                r"isp", r"dngop", r"ccap", r"cam_", r"libmfb", r"fdvt", r"dpe",
                r"eeprom", r"seninf", r"vcodec.*cam", r"3a\.bin"]),
    ("Charger / Power / Thermal", [r"charger", r"thermal", r"power", r"ptgen",
                                   r"battery", r"fuel"]),
    ("ConnSys firmware & tools", [r"wmt", r"connsys", r"conninfra", r"stp",
                                  r"wlan", r"wifi", r"woble", r"WIFI_RAM",
                                  r"soc[0-9]_[0-9]"]),
    ("DRM / Widevine", [r"widevine", r"oemcrypto", r"/drm", r"drm\.", r"liwvhdcp"]),
    ("Display / Graphics", [r"gralloc", r"hwcomposer", r"/egl/", r"mali",
                            r"dpframework", r"libpq", r"mdp", r"libgpud",
                            r"vulkan", r"libged", r"dispsys", r"mml"]),
    ("FM radio", [r"fmradio", r"\bfm_", r"mt6631_fm"]),
    ("Keymaster / Gatekeeper", [r"keymaster", r"gatekeeper", r"keymint",
                                r"kmsetkey", r"keybox", r"soft.*keymaster"]),
    ("Kernel modules", [r"^vendor/lib/modules/"]),
    ("Media / Codecs", [r"codec", r"vpud", r"omx", r"stagefright", r"\.c2\.",
                        r"mtk_c2", r"vdec", r"venc", r"jpeg", r"media_profiles",
                        r"media_codecs"]),
    ("Modem / Telephony / RIL", [r"\bril", r"rild", r"md1", r"ccci", r"modem",
                                 r"mal_", r"epdg", r"\bims", r"volte", r"telephony",
                                 r"gsm0710", r"muxd", r"c2k", r"viarild", r"flp",
                                 r"mdmonitor", r"apmonitor", r"ccb_", r"eccci",
                                 r"mddb", r"spm_loader", r"mtkfusionrild"]),
    ("NFC", [r"nfc"]),
    ("SCP / Tinysys", [r"scp", r"sspm", r"tinysys", r"adsp"]),
    ("Sensors", [r"sensor", r"hwmsen", r"alsps", r"barometer", r"gyroscope",
                 r"accelerometer", r"magnetometer", r"stk3a", r"lsm6dsm"]),
    ("SELinux (prebuilt stock policy)", [r"^vendor/etc/selinux/"]),
    ("TEE (TrustKernel)", [r"^vendor/thh/", r"\btee", r"trustkernel", r"beanpod",
                           r"microtrust", r"thh"]),
    ("Vibrator / Haptics", [r"vibrator", r"haptic", r"aac_vib", r"awinic"]),
    ("VINTF / ODM configs", [r"^vendor/odm/", r"^vendor/odm_dlkm/",
                             r"^vendor/vendor_dlkm/"]),
    ("Overlays (vendor RRO)", [r"^vendor/overlay/"]),
    ("Apps", [r"^vendor/app/"]),
    ("Init / rc / fstab", [r"^vendor/etc/init/", r"fstab", r"ueventd"]),
]

def bucket(path):
    for name, pats in SECTIONS:
        for p in pats:
            if re.search(p, path, re.IGNORECASE):
                return name
    return "MTK platform / misc"

files = []
for root, dirs, names in os.walk(PROP):
    for n in names:
        full = os.path.join(root, n)
        if os.path.islink(full):
            continue
        rel = os.path.relpath(full, PROP)  # vendor/...
        files.append(rel)
files.sort()

apps = [f for f in files if f.startswith("vendor/app/") and f.endswith(".apk")]
by_sec = {}
for f in files:
    if f in EXCLUDE:
        continue
    by_sec.setdefault(bucket(f), []).append(f)

sec_order = [s for s, _ in SECTIONS] + ["MTK platform / misc"]

# ---- proprietary-files.txt ----
with open(os.path.join(REPO, "proprietary-files.txt"), "w") as out:
    out.write("# Proprietary files for DuoQin Qin F25 Pro (F25Pro)\n")
    out.write("# Extracted from stock vendor_a.img, build "
              "AGN_4313R_RD_MX12832_69U.20251103\n")
    out.write("# 'vendor/app' APKs are built as presigned modules (- prefix);\n"
              "# everything else is PRODUCT_COPY_FILES.\n")
    for sec in sec_order:
        if sec not in by_sec:
            continue
        out.write(f"\n# {sec}\n")
        for f in sorted(by_sec[sec]):
            pfx = "-" if f in apps else ""
            out.write(f"{pfx}{f}\n")

# ---- F25Pro-vendor.mk ----
copy_lines = []
for sec in sec_order:
    for f in sorted(by_sec.get(sec, [])):
        if f in apps:
            continue
        dest = f[len("vendor/"):]
        copy_lines.append(
            f"    vendor/duoqin/F25Pro/proprietary/{f}:"
            f"$(TARGET_COPY_OUT_VENDOR)/{dest}")

with open(os.path.join(REPO, "F25Pro-vendor.mk"), "w") as out:
    out.write("""# Automatically generated from proprietary-files.txt - do not hand-edit
# blob list here; regenerate with gen_vendor_tree.py (see README.md).

PRODUCT_SOONG_NAMESPACES += \\
    vendor/duoqin/F25Pro

$(call inherit-product, vendor/duoqin/F25Pro/vendor-props.mk)

PRODUCT_PACKAGES += \\
""")
    out.write(" \\\n".join(f"    {os.path.splitext(os.path.basename(a))[0]}"
                            for a in sorted(apps)))
    out.write("\n\nPRODUCT_COPY_FILES += \\\n")
    out.write(" \\\n".join(copy_lines))
    out.write("\n")

# ---- Android.bp ----
with open(os.path.join(REPO, "Android.bp"), "w") as out:
    out.write("// Automatically generated - vendor app imports for F25Pro\n\n")
    out.write('soong_namespace {\n}\n')
    for a in sorted(apps):
        name = os.path.splitext(os.path.basename(a))[0]
        out.write(f'''
android_app_import {{
    name: "{name}",
    owner: "duoqin",
    apk: "proprietary/{a}",
    presigned: true,
    soc_specific: true,
    dex_preopt: {{
        enabled: false,
    }},
}}
''')

print(f"files={len(files)} apps={len(apps)} sections={len(by_sec)} "
      f"copy_lines={len(copy_lines)} excluded={len(EXCLUDE)}")
