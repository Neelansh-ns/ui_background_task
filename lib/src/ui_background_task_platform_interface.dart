import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'ui_background_task_method_channel.dart';

abstract class UiBackgroundTaskPlatform extends PlatformInterface {
  /// Constructs a UiBackgroundTaskPlatform.
  UiBackgroundTaskPlatform() : super(token: _token);

  static final Object _token = Object();

  static UiBackgroundTaskPlatform _instance = MethodChannelUiBackgroundTask();

  /// The default instance of [UiBackgroundTaskPlatform] to use.
  ///
  /// Defaults to [MethodChannelUiBackgroundTask].
  static UiBackgroundTaskPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [UiBackgroundTaskPlatform] when
  /// they register themselves.
  static set instance(UiBackgroundTaskPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<int?> beginBackgroundTask() {
    throw UnimplementedError('beginBackgroundTask() has not been implemented.');
  }

  Future<void> endBackgroundTask(int taskId) {
    throw UnimplementedError('endBackgroundTask() has not been implemented.');
  }
}
