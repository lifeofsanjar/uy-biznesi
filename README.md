[Preview source](demo/index.html) — static product preview. [Get the Android app](https://github.com/lifeofsanjar/uy-biznesi/releases/latest).

# Uy biznesi

Uy biznesi is an offline-first Flutter app for tracking sales and profit in a home fruit business. Sale records and reports stay on the device in a local SQLite database.

## Download the Android app

Download the latest APK from the [GitHub Releases page](https://github.com/lifeofsanjar/uy-biznesi/releases/latest), or [download Uy-biznesi.apk directly](https://github.com/lifeofsanjar/uy-biznesi/releases/latest/download/Uy-biznesi.apk).

The shared APK is built for Android ARM64 devices. Download it on your phone, open the file, and allow your browser or file manager to install apps when Android prompts you.

## Features

- Record fruit or sale name, price per kilogram, quantity, other expenses, and an optional note.
- Confirm the amount received; the app calculates sale totals and profit automatically.
- Review daily, weekly, and monthly reports.
- Use the app offline; data is stored locally on the device.
- Uzbek is the main app language.

## Develop

1. Install Flutter and the Android SDK.
2. Enable Developer options and USB debugging on an Android phone, then connect it by USB.
3. Run `flutter devices` to confirm the phone is available.
4. Run `flutter run -d <device-id>` to install and debug the app.

Run static checks with `flutter analyze`, unit tests with `flutter test`, and the physical-device sale-flow test with `flutter test integration_test/sale_flow_test.dart -d <device-id>`.

## Build a release

The repository does not contain the private release keystore or signing passwords. To create your own signed release, set a unique application ID in `android/app/build.gradle.kts`, create `android/key.properties` using `android/key.properties.example`, and keep the keystore and passwords private and backed up. Then build with `flutter build apk --release` or `flutter build appbundle --release`.

The application ID currently uses Flutter's template value (`com.example.home_fruit_seller`). The distributed APK is signed with the project's release key, which is not included in this public repository.

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE).


