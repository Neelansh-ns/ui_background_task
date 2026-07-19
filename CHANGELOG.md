## 0.3.0 - 2026-07-20

### Added

* Added Swift Package Manager support for iOS while retaining CocoaPods compatibility.
* Moved the shared Swift implementation into the package-compatible `Sources` layout.
* Preserved compatibility with the legacy `SwiftUiBackgroundTaskPlugin` class name.
* Expanded the README, example documentation, and public API documentation.

### Changed

* **Breaking:** Raised the minimum supported versions to Flutter 3.44 and iOS 13.

## 0.2.0

* Fix error when `taskStopWatchTimer` attempted to be disposed twice
* Updated sdk: ">=3.5.0 <4.0.0"
* Updated flutter: ">=3.24.0"
* Updated plugin_platform_interface: ^2.1.8
* Updated stop_watch_timer: ^3.2.1

## 0.1.3

* Updated description

## 0.1.2

* Bumped rxdart and stop_watch_timer

## 0.0.3

* Added fix for background task being created after kAppBackgroundTimerDuration.
* Added rxdart: ^0.26.0

## 0.0.2

* Added UIBackgroundTask class to cancel tasks before 30 seconds.

## 0.0.1

* Initial Open Source release.
