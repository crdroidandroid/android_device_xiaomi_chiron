#!/bin/bash
#
# SPDX-FileCopyrightText: 2016 The CyanogenMod Project
# SPDX-FileCopyrightText: 2017-2024 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

function blob_fixup() {
    case "${1}" in
        vendor/lib/libmmcamera_chiron_imx386_semco_eeprom.so)
            [ "$2" = "" ] && return 0
            sed -i 's|/data/misc/camera/camera_lsc_caldata.txt|/data/vendor/camera/camera_lsc_calib.txt|g' "${2}"
            ;;
        vendor/lib64/libgf_hal.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF}" --remove-needed "libpowermanager.so" "${2}"
            ;;
        vendor/lib64/sensors.elliptic.so)
            [ "$2" = "" ] && return 0
            sed -i "s|/etc/elliptic_sensor.xml|/vendor/etc/elliptic.xml|g" "${2}"
            "${PATCHELF}" --remove-needed "libandroid.so" "${2}"
            ;;
        *)
            return 1
            ;;
    esac

    return 0
}

function blob_fixup_dry() {
    blob_fixup "$1" ""
}

# If we're being sourced by the common script that we called,
# stop right here. No need to go down the rabbit hole.
if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
    return
fi

set -e

export DEVICE=chiron
export DEVICE_COMMON=msm8998-common
export VENDOR=xiaomi
export VENDOR_COMMON=${VENDOR}

"./../../${VENDOR_COMMON}/${DEVICE_COMMON}/extract-files.sh" "$@"
