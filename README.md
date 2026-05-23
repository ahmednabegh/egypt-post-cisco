# Egypt Post Cisco

Flutter app for searching Egypt Post Cisco numbers by office/place name, region, job description, or the Cisco number itself.

## What is included

- Professional RTL Arabic UI using Egypt Post colors.
- Egypt Post logo used inside the app and prepared as app icon source.
- Offline JSON database generated from the provided Excel sheet.
- Search by name, place, description, region, or Cisco number.
- Filters for all results, post offices, distribution areas, and sectors.
- Result details bottom sheet with one-tap Cisco number copy.

## How to run

1. Install Flutter SDK.
2. Unzip this folder.
3. Open Terminal inside the folder.
4. Run these commands:

```bash
flutter create . --platforms=android,ios,web
flutter pub get
dart run flutter_launcher_icons
flutter run
```

The `flutter create .` command adds the Android/iOS/Web platform files around this ready app source. Humans decided platform folders should be generated per machine, because apparently one universal folder was too merciful.

## Main files

- `lib/main.dart` — full app UI and search logic.
- `assets/data/cisco_directory.json` — converted data from the Excel sheet.
- `assets/images/egypt_post_logo.png` — logo used in the app.
- `assets/icons/app_icon.png` — icon source used by `flutter_launcher_icons`.
