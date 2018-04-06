PRODUCT_BRAND ?= SudaMod

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    keyguard.no_require_sim=true

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.build.selinux=1

# Default notification/alarm sounds
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.config.notification_sound=Argon.ogg \
    ro.config.alarm_alert=Hassium.ogg

ifneq ($(TARGET_BUILD_VARIANT),user)
# Thank you, please drive thru!
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += persist.sys.dun.override=0
endif

ifneq ($(TARGET_BUILD_VARIANT),eng)
# Enable ADB authentication
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.adb.secure=1
endif

ifeq ($(BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE),)
  PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.device.cache_dir=/data/cache
else
  PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.device.cache_dir=/cache
endif

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/sm/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/sm/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/sm/prebuilt/common/bin/50-sm.sh:system/addon.d/50-sm.sh \
    vendor/sm/prebuilt/common/bin/blacklist:system/addon.d/blacklist

# Backup Services whitelist
PRODUCT_COPY_FILES += \
    vendor/sm/config/permissions/backup.xml:system/etc/sysconfig/backup.xml

# Lineage-specific broadcast actions whitelist
PRODUCT_COPY_FILES += \
    vendor/sm/config/permissions/lineage-sysconfig.xml:system/etc/sysconfig/lineage-sysconfig.xml

# Signature compatibility validation
PRODUCT_COPY_FILES += \
    vendor/sm/prebuilt/common/bin/otasigcheck.sh:install/bin/otasigcheck.sh

# init.d support
PRODUCT_COPY_FILES += \
    vendor/sm/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/sm/prebuilt/common/bin/sysinit:system/bin/sysinit

ifneq ($(TARGET_BUILD_VARIANT),user)
# userinit support
PRODUCT_COPY_FILES += \
    vendor/sm/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit
endif

# Copy all SM-specific init rc files
$(foreach f,$(wildcard vendor/sm/prebuilt/common/etc/init/*.rc),\
	$(eval PRODUCT_COPY_FILES += $(f):system/etc/init/$(notdir $f)))

# Copy over added mimetype supported in libcore.net.MimeUtils
PRODUCT_COPY_FILES += \
    vendor/sm/prebuilt/common/lib/content-types.properties:system/lib/content-types.properties

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:system/usr/keylayout/Vendor_045e_Product_0719.kl

# This is SM!
PRODUCT_COPY_FILES += \
    vendor/sm/config/permissions/org.lineageos.android.xml:system/etc/permissions/org.lineageos.android.xml \
    vendor/sm/config/permissions/privapp-permissions-lineage.xml:system/etc/permissions/privapp-permissions-lineage.xml

# Phonelocation!
PRODUCT_COPY_FILES +=  \
    vendor/sm/prebuilt/common/media/location/suda-phonelocation.dat:system/media/location/suda-phonelocation.dat

# Include SM audio files
include vendor/sm/config/sm_audio.mk

# Include private files
include vendor/sm/config/private.mk

ifneq ($(TARGET_DISABLE_LINEAGE_SDK), true)
# Lineage SDK
include vendor/sm/config/lineage_sdk_common.mk
endif

# TWRP
ifeq ($(WITH_TWRP),true)
include vendor/sm/config/twrp.mk
endif

# Bootanimation
PRODUCT_PACKAGES += \
    bootanimation.zip

# Required Lineage packages
PRODUCT_PACKAGES += \
    BluetoothExt \
    LineageParts \
    Development \
    Profiles

# Optional packages
PRODUCT_PACKAGES += \
    libemoji \
    LiveWallpapersPicker \
    PhotoTable \
    Terminal

# Include explicitly to work around GMS issues
PRODUCT_PACKAGES += \
    libprotobuf-cpp-full \
    librsjni

# Custom Lineage packages
PRODUCT_PACKAGES += \
    LineageSettingsProvider \
    PhoneLocationProvider \
    ExactCalculator \
    LockClock \
    WallpaperPicker \
    WeatherProvider

# Exchange support
#PRODUCT_PACKAGES += \
#    Exchange2

# Berry styles
#PRODUCT_PACKAGES += \
#    LineageDarkTheme \
#    LineageBlackAccent \
#    LineageBlueAccent \
#    LineageBrownAccent \
#    LineageCyanAccent \
#    LineageGreenAccent \
#    LineageOrangeAccent \
#    LineagePinkAccent \
#    LineagePurpleAccent \
#    LineageRedAccent \
#    LineageYellowAccent

# Extra tools in Lineage
PRODUCT_PACKAGES += \
    7z \
    awk \
    bash \
    bzip2 \
    curl \
    fsck.ntfs \
    gdbserver \
    htop \
    lib7z \
    libsepol \
    micro_bench \
    mke2fs \
    mkfs.ntfs \
    mount.ntfs \
    oprofiled \
    pigz \
    powertop \
    sqlite3 \
    strace \
    tune2fs \
    unrar \
    unzip \
    vim \
    wget \
    zip

# Charger
PRODUCT_PACKAGES += \
    charger_res_images

# Custom off-mode charger
ifeq ($(WITH_LINEAGE_CHARGER),true)
PRODUCT_PACKAGES += \
    lineage_charger_res_images \
    font_log.png \
    libhealthd.lineage
endif

# exFAT tools
PRODUCT_PACKAGES += \
    fsck.exfat \
    mkfs.exfat

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

# rsync
PRODUCT_PACKAGES += \
    rsync

# Stagefright FFMPEG plugin
PRODUCT_PACKAGES += \
    libffmpeg_extractor \
    libffmpeg_omx \
    media_codecs_ffmpeg.xml

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    media.sf.omx-plugin=libffmpeg_omx.so \
    media.sf.extractor-plugin=libffmpeg_extractor.so

# Storage manager
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.storage_manager.enabled=true

# Media
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    media.recorder.show_manufacturer_and_model=true

# These packages are excluded from user builds
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_PACKAGES += \
    procmem \
    procrank \
    su
endif

DEVICE_PACKAGE_OVERLAYS += vendor/sm/overlay/common

PRODUCT_VERSION_MAJOR = 81
PRODUCT_VERSION_MINOR = 0

ifdef SM_BUILDTYPE
    ifdef SM_EXTRAVERSION
        # Force build type to EXPERIMENTAL
        SM_BUILDTYPE := EXPERIMENTAL
        # Remove leading dash from SM_EXTRAVERSION
        SM_EXTRAVERSION := $(shell echo $(SM_EXTRAVERSION) | sed 's/-//')
        # Add leading dash to SM_EXTRAVERSION
        SM_EXTRAVERSION := -$(SM_EXTRAVERSION)
    endif
else
    # If SM_BUILDTYPE is not defined, set to UNOFFICIAL
    SM_BUILDTYPE := UNOFFICIAL
    SM_EXTRAVERSION :=
endif

ifneq ($(filter RELEASE,$(SM_BUILDTYPE)),)
    ifdef SM_BUILD_DATE
        SM_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(SM_BUILD_DATE)-$(SM_BUILDTYPE)-$(SM_BUILD)
    else
        SM_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(shell date +%y%m%d)-$(SM_BUILDTYPE)-$(SM_BUILD)
    endif
else
    ifdef SM_BUILD_DATE
        SM_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(SM_BUILD_DATE)-$(SM_BUILDTYPE)-$(SM_BUILD)
    else
        SM_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(shell date +%Y%m%d%H%M)-$(SM_BUILDTYPE)-$(SM_BUILD)
    endif
endif

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.sm.version=$(SM_VERSION) \
    ro.sm.releasetype=$(SM_BUILDTYPE) \
    ro.sm.build.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR) \
    ro.modversion=$(SM_VERSION) \
    ro.lineagelegal.url=https://lineageos.org/legal

PRODUCT_EXTRA_RECOVERY_KEYS += \
    vendor/sm/build/target/product/security/lineage

-include vendor/lineage-priv/keys/keys.mk

SM_DISPLAY_VERSION := $(SM_VERSION)

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.sm.display.version=$(SM_DISPLAY_VERSION)

-include $(WORKSPACE)/build_env/image-auto-bits.mk
-include vendor/sm/config/partner_gms.mk
-include vendor/cyngn/product.mk

$(call prepend-product-if-exists, vendor/extra/product.mk)
