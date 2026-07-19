# ui_background_task example

This iOS example demonstrates the complete plugin lifecycle:

1. Tap **Begin background task**.
2. Move the app to the background while the task is active.
3. Return to the app and tap **End background task**.

Run it on an iOS device or simulator:

```console
flutter run
```

The example forwards every Flutter application lifecycle change to
`UiBackgroundTask.instance.appLifeCycleUpdate`, which is required for the
plugin's safety timers.
