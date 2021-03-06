#!/bin/bash

BUILD=$1

if [ "$BUILD" != "debug" ] && [ "$BUILD" != "release" ]; then
  echo "usage ./deploy_osx.sh [debug | release] (package)"
  exit 1
fi

QT_VER=5.9.4/clang_64
QTDIR=/usr/local/opt/qt/$QT_VER
APP_NAME=ct_file_encrypt
BUNDLE_NAME=CTFileEncrypt

echo "building..."
$QTDIR/bin/qmake CONFIG+=$BUILD
make

cd $BUILD
cat ./$APP_NAME.app/Contents/Info.plist | \
sed 's/edu.cuhk.ct_file_encrypt/carlos.ct_file_encrypt/g' | \
sed 's/NOTE/CFBundleName/g' | \
sed 's/This file was generated by Qt\/QMake./CT File Encrypt/g' > Info.plist
mv Info.plist ./$APP_NAME.app/Contents/Info.plist

# note -dmg will create a read-only image
$QTDIR/bin/macdeployqt $APP_NAME.app

if [ "$2" == "package" ]; then
  hdiutil create -size 100MB -fs HFS+ -volname "CT File Encrypt" ./tmp.dmg
  hdiutil attach ./tmp.dmg
  cp -R ./$APP_NAME.app /Volumes/CT\ File\ Encrypt/$BUNDLE_NAME.app
  ln -s /Applications /Volumes/CT\ File\ Encrypt/
  diskutil eject /Volumes/CT\ File\ Encrypt/
  hdiutil convert -format UDBZ -o ./$APP_NAME.dmg ./tmp.dmg
  rm ./tmp.dmg
fi

echo "done"
