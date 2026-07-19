import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import 'ui_background_task_platform_interface.dart';

/// Manages finite-length iOS background task assertions.
///
/// Call [beginBackgroundTask] immediately before starting work that should be
/// allowed to finish after the app enters the background. Always pair a
/// successful call with [endBackgroundTask].
class UiBackgroundTask {
  /// Duration after which all tasks are ended while the app is in the
  /// background.
  ///
  /// This is intentionally shorter than the time normally granted by iOS.
  static const kAppBackgroundTimerDuration = Duration(seconds: 28);

  /// Maximum duration for an individual task managed by this plugin.
  ///
  /// This safety timer ends the task before the iOS expiration handler would
  /// normally be invoked.
  static const kTaskCompletionTimerDuration = Duration(seconds: 29);

  static final UiBackgroundTask _instance = UiBackgroundTask._();

  /// The shared background task manager.
  static UiBackgroundTask get instance => _instance;

  UiBackgroundTask._();

  ///List to store the task Ids of the running background tasks.
  final List<int> _taskIds = [];

  final StopWatchTimer _stopWatchTimer = StopWatchTimer();

  StreamSubscription<int>? _subscription;

  /// Begins an iOS background task and returns its identifier.
  ///
  /// Returns `0` without creating a task if the app has already spent almost
  /// all of its managed time in the background.
  Future<int> beginBackgroundTask() async {
    // Avoid starting a task after [kAppBackgroundTimerDuration], which could
    // cause iOS to terminate the app. One second is subtracted to account for
    // timer precision.
    if ((_stopWatchTimer.secondTime.valueOrNull ?? 0) >
        kAppBackgroundTimerDuration.inSeconds - 1) {
      debugPrint('BG_TASK:: SKIPPED STARTING BG TASK');
      return 0;
    }

    final taskId = await _getTaskId();
    _taskIds.add(taskId);

    StopWatchTimer taskStopWatchTimer = StopWatchTimer();
    taskStopWatchTimer.onStartTimer();
    taskStopWatchTimer.secondTime.listen((event) async {
      if (event == kTaskCompletionTimerDuration.inSeconds ||
          !_taskIds.contains(taskId)) {
        taskStopWatchTimer.dispose();
      }
      if (event == kTaskCompletionTimerDuration.inSeconds) {
        debugPrint('BG_TASK:: $taskId cancelled at $event seconds');
        endBackgroundTask(taskId);
      }
    });

    return taskId;
  }

  /// Ends the background task identified by [taskId].
  Future<void> endBackgroundTask(int taskId) async {
    await UiBackgroundTaskPlatform.instance.endBackgroundTask(taskId);
    _taskIds.remove(taskId);
  }

  /// Updates the task timers for an app lifecycle transition.
  ///
  /// Forward every [WidgetsBindingObserver.didChangeAppLifecycleState] event
  /// here so managed tasks are reset or ended at the appropriate time.
  void appLifeCycleUpdate(AppLifecycleState appLifecycleState) {
    switch (appLifecycleState) {
      case AppLifecycleState.resumed:
        debugPrint('BG_TASK:: App background timer reset');
        _stopWatchTimer.onResetTimer();
        break;
      case AppLifecycleState.paused:
        if (_taskIds.isNotEmpty) {
          _stopWatchTimer.onResetTimer();
          _stopWatchTimer.onStartTimer();
          _subscription?.cancel();
          _subscription = _stopWatchTimer.secondTime.listen((event) {
            if (event == kAppBackgroundTimerDuration.inSeconds) {
              for (var taskId in [..._taskIds]) {
                endBackgroundTask(taskId);
                debugPrint('BG_TASK:: $taskId cancelled at $event seconds');
              }
            }
          });
        }
        break;
      case AppLifecycleState.detached:
        _stopWatchTimer.dispose();
        break;
      case AppLifecycleState.hidden:
      case AppLifecycleState.inactive:
        //do nothing
        break;
    }
  }

  Future<int> _getTaskId() async {
    final taskId =
        await UiBackgroundTaskPlatform.instance.beginBackgroundTask();
    if (taskId == null) {
      throw Exception('Cannot begin BackgroundTask');
    }
    return taskId;
  }

  /// Releases timers and clears locally tracked task identifiers.
  ///
  /// Call this only when the shared manager will no longer be used.
  void dispose() {
    _stopWatchTimer.dispose();
    _taskIds.clear();
  }
}
