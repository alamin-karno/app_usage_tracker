# App Usage Tracker

The App Usage Tracker is a Dart class that provides a simple way to track how many days an app has been used and how many times it has been opened. It uses the `shared_preferences` package to store the app's usage information on the device.

Note: This plugin is still under development, anyone want to contribute on this project is most welcome. If you have any idea or suggestion, please feel free to contact me.

## Features

- [x] Null-safety enable
- [x] Easy to use
- [x] Highly customizable
- [x] Supports for all platforms
- [x] Can check in days format and can stop reseting if want

## Getting Started
To use the App Usage Tracker, simply import the `AppUsageTracker` package:

Run this on your project terminal:

```yaml
flutter pub add app_usage_tracker
```

or manually configure pubspec.yml fi

```yaml
dependencies:
  flutter:
    sdk: flutter
  app_usage_tracker: ^0.0.1
```

## Usage
To check if the app has been used for at least 15 days and opened at least 10 times, use the `isAppUsedEnough` method of the `AppUsageTracker` class. The method returns a boolean value indicating whether the app has been used enough:

##### First Imported Package:

```dart
import 'package:app_usage_tracker/app_usage_tracker.dart';
```

##### Then:

```dart
bool isUsedEnough = await AppUsageTracker.isAppUsedEnough(
    minDayUsed: 15, // here you can user your own minimum day used
    minLunches: 10, // here you can use your own minimum lunches
    resetTacker: false, // reset the tracker if the app has been used for at least minDays = 15 days and opened at least minLunches = 10 times. By default the tracker is reset.
);
if (isUsedEnough) {
  // The app has been used enough
} else {
  // The app has not been used enough
}
```

Here is the full code for the `AppUsageTracker` class:

```dart
import 'package:shared_preferences/shared_preferences.dart';

class AppUsageTracker {
  static const String _kFirstOpen = 'first_open';
  static const String _kOpenedCount = 'opened_count';

  static Future<bool> isAppUsedEnough({
    required minDayUsed,
    required minLaunches,
    bool resetTracker = true,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // Check if this is the first time the app is opened
    final firstOpenTimestamp = prefs.getInt(_kFirstOpen);
    if (firstOpenTimestamp == null) {
      prefs.setInt(_kFirstOpen, DateTime.now().millisecondsSinceEpoch);
      prefs.setInt(_kOpenedCount, 1);
      return false;
    }

    // Check if the app has been used for at least minDayUsed days
    final now = DateTime.now();
    final firstOpenDate = DateTime.fromMillisecondsSinceEpoch(firstOpenTimestamp);
    final diff = now.difference(firstOpenDate);
    final daysUsed = diff.inDays + 1; // add 1 to include the first day
    if (daysUsed < minDayUsed) {
      return false;
    }

    // Check if the app has been opened at least minLaunches times
    final openedCount = prefs.getInt(_kOpenedCount) ?? 0;
    if (openedCount < minLaunches) {
      prefs.setInt(_kOpenedCount, openedCount + 1);
      return false;
    }

    // Reset the first open timestamp and opened count
    if (resetTracker) {
      prefs.setInt(_kFirstOpen, DateTime.now().millisecondsSinceEpoch);
      prefs.setInt(_kOpenedCount, 1);
    }

    // The app has been used enough
    return true;
  }
}
```

This code defines the `AppUsageTracker` class, which has a static method `isAppUsedEnough` that returns a boolean indicating whether the app has been used enough. It uses the shared_preferences package to store the app's usage information on the device. When the `isAppUsedEnough` method is called, it checks the stored usage information to determine if the app has been used for at least `minDayUsed` days and opened at least `minLaunches` times. If the app has not been used enough, the method returns false. If the app has been used enough, the method resets the usage information and returns true.

## Screenshot (GIF)

| App Uaages Tracker (GIF) |
| :---: |
| <img src="#"> |

## Additional information

- [App Usage Tracker (pub.dev)](https://pub.dev/packages/app_usage_tracker)
- [App Usage Tracker (GitHub)](https://github.com/alamin-karno/app_usage_tracker)

<h3 align=center> Project Maintainer ❤️ </h3>
<p align="center">
<table align="center">
  <tbody><tr>
     <td align="center">
     <a href="https://github.com/alamin-karno">
     <img alt="Md. Al-Amin" src="https://avatars.githubusercontent.com/alamin-karno" width="125px;"> <br>
     <sub><b> Md. Al-Amin </b></sub>
     </a><br></td></tr>
     </tbody> </table> </p>


<h3 align="center"> ✨VALUABLE CONTRIBUTORS✨ </h3>
<p align="center">
<a href="https://github.com/alamin-karno/app_usage_tracker/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=alamin-karno/app_usage_tracker" />
</a>
</p>
<h3 align="center"> Happy Coding 👨‍💻 </h3>

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.