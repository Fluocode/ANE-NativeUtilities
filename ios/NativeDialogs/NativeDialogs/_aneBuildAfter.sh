#!/bin/sh

#  aneBuildAfter.sh
#
#  Original implementation.
#

set -e

#
# Universal static library script
# http://github.com/michaeltyson/iOS-Universal-Library-Template
#
# Version 2.5
#
# Purpose:
#   Create a static library for iPhone from within XCode
#
# Author: Adam Martin - http://twitter.com/redglassesapps
# Tweaked and made into an Xcode template by Michael Tyson - http://atastypixel.com/blog
# Based on original script from Eonil
# More info: see this Stack Overflow question: http://stackoverflow.com/questions/3520977/build-fat-static-library-device-simulator-using-xcode-and-sdk-4
#
#################[ Tests: helps workaround any future bugs in Xcode ]########
#
DEBUG_THIS_SCRIPT="true"

if [ $DEBUG_THIS_SCRIPT = "true" ]
then

echo "########### TESTS #############"
echo "Use the following variables when debugging this script; note that they may change on recursions"
echo "BUILD_DIR = $BUILD_DIR"
echo "BUILD_ROOT = $BUILD_ROOT"
echo "CONFIGURATION_BUILD_DIR = $CONFIGURATION_BUILD_DIR"
echo "BUILT_PRODUCTS_DIR = $BUILT_PRODUCTS_DIR"
echo "CONFIGURATION_TEMP_DIR = $CONFIGURATION_TEMP_DIR"
echo "TARGET_BUILD_DIR = $TARGET_BUILD_DIR"
fi

if [ "$CALLED_FROM_MASTER" ]
then
# This is the other build, called from the original instance
exit 0
fi

# We only want device release for ANE packaging:
# - no iphonesimulator builds
# - no universal (lipo) merging
# - only Release configuration output
if [ "${CONFIGURATION}" != "Release" ]; then
    echo "aneBuildAfter: skipping non-Release build (${CONFIGURATION})"
    exit 0
fi

if [ "${PLATFORM_NAME}" != "iphoneos" ]; then
    echo "aneBuildAfter: skipping non-iphoneos build (${PLATFORM_NAME})"
    exit 0
fi

# Find the BASESDK version number
SDK_VERSION=$(echo ${SDK_NAME} | grep -o '.\{os\}$')

# Device-only output: copy the built static library into ANE output folder.
echo "aneBuildAfter: copying device Release artifact (sdk=${SDK_NAME})"

SOURCE_LIB="${BUILT_PRODUCTS_DIR}/${EXECUTABLE_NAME}"
if [ ! -f "${SOURCE_LIB}" ]; then
    SOURCE_LIB="${TARGET_BUILD_DIR}/${EXECUTABLE_NAME}"
fi
if [ ! -f "${SOURCE_LIB}" ]; then
    # Fallback for legacy template paths
    if [ -f "${SYMROOT}/${CONFIGURATION}-iphone/${EXECUTABLE_NAME}" ]; then
        SOURCE_LIB="${SYMROOT}/${CONFIGURATION}-iphone/${EXECUTABLE_NAME}"
    elif [ -f "${SYMROOT}/${CONFIGURATION}-iphoneos/${EXECUTABLE_NAME}" ]; then
        SOURCE_LIB="${SYMROOT}/${CONFIGURATION}-iphoneos/${EXECUTABLE_NAME}"
    fi
fi

if [ ! -f "${SOURCE_LIB}" ]; then
    echo "aneBuildAfter: ERROR - couldn't find built library: ${EXECUTABLE_NAME}" >&2
    exit 0
fi

DEST_DIR="${PROJECT_FILE_PATH}/../build/Release-iphoneos"
mkdir -p "${DEST_DIR}"
cp "${SOURCE_LIB}" "${DEST_DIR}/${EXECUTABLE_NAME}"
