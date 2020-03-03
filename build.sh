#!/bin/sh

echo "Step 1: Archive\n"
xcodebuild -workspace WTC.xcodeproj/project.xcworkspace \
            -scheme WTC \
            clean archive \
            -configuration release \
            -sdk iphoneos \
            -archivePath WTC.xcarchive
echo "✅ Step 1: Done\n\n"

echo "Step 2: Create IPA\n"
xcodebuild -exportArchive \
            -allowProvisioningUpdates \
            -archivePath WTC.xcarchive \
            -exportOptionsPlist  WTC/exportOptionsAdHoc.plist \
            -exportPath  WTC.ipa
echo "✅ Step 2: Done\n\n"
