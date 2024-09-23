#!/usr/bin/env bash

# Helper script, not meant to be executed directly!

set -e

print_usage () {
    echo "Usage: $0 <Platform: ios|macos>"

    exit 1
}

XC_PLATFORM=""

if [ "$1" = "ios" ]; then
    XC_PLATFORM="ios"
elif [ "$1" = "macos" ]; then
    XC_PLATFORM="macos"
else
    print_usage
fi

BIN_PATH_BASE="bin"
BIN_PATH_RELEASE="${BIN_PATH_BASE}/Release"

echo "Bin Path Base: ${BIN_PATH_BASE}"

XC_SDK_MACOS='macosx'
XC_DESTINATION_MACOS='generic/platform=macOS'

XC_SDK_IOS='iphoneos'
XC_SDK_IOS_SIMULATOR='iphonesimulator'

XC_DESTINATION_IOS='name=Any iOS Device'
XC_DESTINATION_IOS_SIMULATOR='generic/platform=iOS Simulator'

XC_SCHEME='swift-package-ios-build-test'
XC_PRODUCT_NAME='SwiftPackageiOSBuildTest'
XC_CONFIG_RELEASE='release'

CODESIGN_ID="-"

build () {
    local bin_path="$1"
    local xc_config="$2"
    local xc_sdk="$3"
    local xc_destination="$4"
    local xc_product_dir_name="${xc_config}"
    local xc_info_plist_path="Versions/A/Resources/Info.plist"

    if [[ "${xc_sdk}" =~ ^iphone* ]]; then
        xc_product_dir_name="${xc_config}-${xc_sdk}"
        xc_info_plist_path="Info.plist"
    fi

    local log_suffix="(SDK: ${xc_sdk}; Destination: ${xc_destination}; Config: ${xc_config})"

    echo "Cleaning ${log_suffix}"
    if [[ -d "${bin_path}/${xc_config}" ]]; then
        rm -rf "${bin_path}/${xc_config}"
    fi

    xcodebuild clean \
        -sdk "${xc_sdk}" \
        -destination "${xc_destination}" \
        -scheme "${XC_SCHEME}" \
        -configuration "${xc_config}" \
        -derivedDataPath "${bin_path}"

    echo "Compiling ${log_suffix}"
    xcodebuild build \
        -sdk "${xc_sdk}" \
        -destination "${xc_destination}" \
        -scheme "${XC_SCHEME}" \
        -configuration "${xc_config}" \
        -derivedDataPath "${bin_path}" \
        ONLY_ACTIVE_ARCH=NO \
        PRODUCT_NAME="${XC_PRODUCT_NAME}" \
        BUNDLE_NAME="${XC_PRODUCT_NAME}" \
        PRODUCT_BUNDLE_IDENTIFIER="com.royalapps.${XC_PRODUCT_NAME}"
}

config="${XC_CONFIG_RELEASE}"

build "${BIN_PATH_RELEASE}/${XC_SDK_IOS}" "${config}" "${XC_SDK_IOS}" "${XC_DESTINATION_IOS}"
build "${BIN_PATH_RELEASE}/${XC_SDK_IOS_SIMULATOR}" "${config}" "${XC_SDK_IOS_SIMULATOR}" "${XC_DESTINATION_IOS_SIMULATOR}"
build "${BIN_PATH_RELEASE}/${XC_SDK_MACOS}" "${config}" "${XC_SDK_MACOS}" "${XC_DESTINATION_MACOS}"