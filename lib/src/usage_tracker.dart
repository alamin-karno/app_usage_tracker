/* MIT License
Copyright (c) 2022 Md. Al-Amin
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// [AppUsageTracker] The App Usage Tracker is a Dart class that provides
/// a simple way to track how many days an app has been used and how many
/// times it has been opened. It uses the shared_preferences package to
/// store the app's usage information on the device.
class AppUsageTracker {
  static const String _kFirstOpen = 'first_open';
  static const String _kOpenedCount = 'opened_count';

  /// [isAppUsedEnough] Checks whether the app has been used enough.
  ///
  /// Returns a boolean indicating whether the app has been used enough. The app
  /// is considered to have been used enough if it has been open for at least minDayUsed
  /// days and has been opened at least minLaunches times. If the app has not been used
  /// enough, the method returns `false`. If the app has been used enough, the
  /// method resets the usage information and returns `true`.
  ///
  /// Usage:
  ///
  /// ```dart
  /// bool isUsedEnough = await AppUsageTracker.isAppUsedEnough();
  /// if (isUsedEnough) {
  ///   // The app has been used enough
  /// } else {
  ///   // The app has not been used enough
  /// }
  /// ```
  ///
  /// Throws a `PlatformException` if there was an error accessing the shared
  /// preferences.
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

    // Check if the app has been used for at least 15 days
    final now = DateTime.now();
    final firstOpenDate =
        DateTime.fromMillisecondsSinceEpoch(firstOpenTimestamp);
    final diff = now.difference(firstOpenDate);
    final daysUsed = diff.inDays + 1; // add 1 to include the first day
    if (daysUsed < minDayUsed) {
      debugPrint('[AppUsageTracker] TOTAL DAY USED: $daysUsed');
      return false;
    }

    // Check if the app has been opened at least 10 times
    final openedCount = prefs.getInt(_kOpenedCount) ?? 0;
    if (openedCount < minLaunches) {
      prefs.setInt(_kOpenedCount, openedCount + 1);
      debugPrint('[AppUsageTracker] TOTAL APP LUNCHED: $openedCount');
      return false;
    }

    // Reset the first open timestamp and opened count
    if (resetTracker) {
      debugPrint('[AppUsageTracker] TRACKER RESET');
      prefs.setInt(_kFirstOpen, DateTime.now().millisecondsSinceEpoch);
      prefs.setInt(_kOpenedCount, 1);
    }

    debugPrint('[AppUsageTracker] TOTAL DAY USED: $daysUsed');
    debugPrint('[AppUsageTracker] TOTAL APP LUNCHED: $openedCount');
    // The app has been used enough
    return true;
  }
}
