import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import 'ui_background_task_platform_interface.dart';

class UiBackgroundTask {
  ///Duration after which all the tasks will be ended when the app is in background.
  ///Keeping it a bit less than 30 seconds, i.e. the time app gets when in background.
  static const kAppBackgroundTimerDuration = Duration(seconds: 28);

  ///Duration for which each task is going to run at max.
  ///Keeping it a bit less than 30 seconds, i.e. the time before which the background tasks should end.
  ///The expiration handler of the task is only called when teh app is in background for more than 30 seconds
  static const kTaskCompletionTimerDuration = Duration(seconds: 29);

  static final UiBackgroundTask _instance = UiBackgroundTask._();

  static UiBackgroundTask get instance => _instance;

  UiBackgroundTask._();

  ///List to store the task Ids of the running background tasks.
  final List<int> _taskIds = [];

  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  StreamSubscription<int>? _subscription;

  Future<int> beginBackgroundTask() {
    StopWatchTimer taskStopWatchTimer = StopWatchTimer();
    return _getTaskId()
      ..then((taskId) {
        _taskIds.add(taskId);
        taskStopWatchTimer.onExecute.add(StopWatchExecute.start);
        taskStopWatchTimer.secondTime.listen((event) {
          if (!_taskIds.contains(taskId)) {
            taskStopWatchTimer.dispose();
          }
          if (event == kTaskCompletionTimerDuration.inSeconds) {
            debugPrint('BG_TASK:: $taskId cancelled at $event seconds');
            endBackgroundTask(taskId);
            _taskIds.remove(taskId);
            taskStopWatchTimer.dispose();
          }
        });
      });
  }

  Future<void> endBackgroundTask(int taskId) {
    return UiBackgroundTaskPlatform.instance.endBackgroundTask(taskId);
  }

  void appLifeCycleUpdate(AppLifecycleState appLifecycleState) {
    switch (appLifecycleState) {
      case AppLifecycleState.resumed:
        debugPrint('BG_TASK:: App background timer reset');
        _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        if (_taskIds.isNotEmpty) {
          _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
          _stopWatchTimer.onExecute.add(StopWatchExecute.start);
          _subscription?.cancel();
          _subscription = _stopWatchTimer.secondTime.listen((event) {
            if (event == kAppBackgroundTimerDuration.inSeconds) {
              for (var taskId in _taskIds) {
                endBackgroundTask(taskId);
                debugPrint('BG_TASK:: $taskId cancelled at $event seconds');
              }
              _taskIds.clear();
            }
          });
        }
        break;
      case AppLifecycleState.detached:
        _stopWatchTimer.dispose();
        break;
    }
  }

  Future<int> _getTaskId() async {
    return await UiBackgroundTaskPlatform.instance.beginBackgroundTask().then((value) {
      if (value == null) {
        return Future.error(Exception('Something went wrong!'));
      }
      return value;
    });
  }

  dispose() {
    _stopWatchTimer.dispose();
    _taskIds.clear();
  }
}
