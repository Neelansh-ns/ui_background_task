import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'ui_background_task_platform_interface.dart';

/// An implementation of [UiBackgroundTaskPlatform] that uses method channels.
class MethodChannelUiBackgroundTask extends UiBackgroundTaskPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('ui_background_task');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<int?> beginBackgroundTask() async {
    final taskId = await methodChannel.invokeMethod<int>('beginBackgroundTask');
    return taskId;
  }

  @override
  Future<void> endBackgroundTask(int taskId) {
    return methodChannel
        .invokeMethod<void>('endBackgroundTask', {'taskId': taskId});
  }
}
