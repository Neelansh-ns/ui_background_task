/// Keep short-running iOS work alive while an app transitions to the
/// background.
///
/// Use [UiBackgroundTask.instance] to begin and end tasks, and forward app
/// lifecycle changes to [UiBackgroundTask.appLifeCycleUpdate].
library;

export 'src/ui_background_task.dart';
