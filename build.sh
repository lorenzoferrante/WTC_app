#!/bin/sh

security unlock-keychain

echo "🍷 Step 1: Archive...\n"
xcodebuild -workspace WTC.xcodeproj/project.xcworkspace \
            -scheme WTC \
            clean archive \
            -configuration release \
            -sdk iphoneos \
            -archivePath WTC.xcarchive
echo "✅ Step 1: Done\n\n"

echo "🍷 Step 2: Create IPA...\n"
xcodebuild -exportArchive \
            -archivePath WTC.xcarchive \
            -exportOptionsPlist  WTC/ExportOptions.plist \
            -exportPath  WTC_APP
echo "✅ Step 2: Done\n\n"

echo "🍷 Step 3: Moving files to IPAServer...\n\n"
rm /Users/lorenzoferrante/Documents/ipaserver/build/*.txt
rm /Users/lorenzoferrante/Documents/ipaserver/build/*.plist
rm /Users/lorenzoferrante/Documents/ipaserver/build/*.log
rm /Users/lorenzoferrante/Documents/ipaserver/build/*.ipa

rm WTC.xcarchive

mv WTC_APP/* /Users/lorenzoferrante/Documents/ipaserver/build/
rm -rf WTC_APP
echo "✅ Step 3: Done\n\n"

cd /Users/lorenzoferrante/Documents/ipaserver/build/
APP_NAME=$(ls *.ipa)
echo "📲 App Name: $APP_NAME\n\n"
