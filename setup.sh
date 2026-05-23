#!/usr/bin/env bash
set -e
flutter create . --platforms=android,ios,web
flutter pub get
dart run flutter_launcher_icons
printf '\nDone. Run: flutter run\n'
