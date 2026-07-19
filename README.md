# ui_background_task

[![pub package](https://img.shields.io/pub/v/ui_background_task.svg)](https://pub.dev/packages/ui_background_task)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

Keep short-running iOS work alive while your Flutter app moves to the
background. The plugin wraps iOS background task assertions and provides
safety timers that end active tasks before their execution allowance expires.

> **iOS only:** This plugin is intended for finite work that is already in
> progress. It does not schedule background jobs or guarantee a fixed amount of
> execution time; iOS decides how much background time an app receives.

## Requirements

- Flutter 3.44 or later
- Dart 3.5 or later
- iOS 13 or later

Both CocoaPods and Swift Package Manager integration are supported.

## Installation

```console
flutter pub add ui_background_task
```

No additional native setup is required. Apps migrating their iOS dependencies
to Swift Package Manager can follow Flutter's
[Swift Package Manager guide](https://docs.flutter.dev/packages-and-plugins/swift-package-manager/for-app-authors).

## Usage

Register a lifecycle observer, forward lifecycle changes to the plugin, and
always end each task as soon as its work finishes:

```dart
import 'package:flutter/material.dart';
import 'package:ui_background_task/ui_background_task.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key, required this.operation});

  final Future<void> Function() operation;

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> runWithBackgroundTime(
    Future<void> Function() operation,
  ) async {
    final taskId =
        await UiBackgroundTask.instance.beginBackgroundTask();

    // A zero identifier means the managed background-time window is nearly
    // exhausted and no task was started.
    if (taskId == 0) return;

    try {
      await operation();
    } finally {
      await UiBackgroundTask.instance.endBackgroundTask(taskId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => runWithBackgroundTime(widget.operation),
      child: const Text('Start work'),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    UiBackgroundTask.instance.appLifeCycleUpdate(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
```

Pass your finite asynchronous operation to `runWithBackgroundTime`. If work can
be cancelled from elsewhere, adapt the example to store `taskId` in state and
pass it to `endBackgroundTask` during cleanup.

## API

| Member | Purpose |
| --- | --- |
| `UiBackgroundTask.instance` | Returns the shared task manager. |
| `beginBackgroundTask()` | Starts an iOS background task and returns its integer identifier. |
| `endBackgroundTask(taskId)` | Ends a previously started task. |
| `appLifeCycleUpdate(state)` | Keeps the plugin's safety timers synchronized with the app lifecycle. |

The plugin automatically ends tracked tasks after approximately 28 seconds in
the background and applies a 29-second safety limit to individual tasks. These
are safety limits, not a promise that iOS will grant that much time.

See the complete [example application](example/lib/main.dart) for interactive
begin/end controls.

## License

MIT. See [LICENSE](LICENSE).
