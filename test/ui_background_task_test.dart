import 'package:flutter_test/flutter_test.dart';
import 'package:ui_background_task/ui_background_task.dart';
import 'package:ui_background_task/ui_background_task_platform_interface.dart';
import 'package:ui_background_task/ui_background_task_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockUiBackgroundTaskPlatform
    with MockPlatformInterfaceMixin
    implements UiBackgroundTaskPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final UiBackgroundTaskPlatform initialPlatform =
      UiBackgroundTaskPlatform.instance;

  test('$MethodChannelUiBackgroundTask is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelUiBackgroundTask>());
  });

  test('getPlatformVersion', () async {
    UiBackgroundTask uiBackgroundTaskPlugin = UiBackgroundTask();
    MockUiBackgroundTaskPlatform fakePlatform = MockUiBackgroundTaskPlatform();
    UiBackgroundTaskPlatform.instance = fakePlatform;

    expect(await uiBackgroundTaskPlugin.getPlatformVersion(), '42');
  });
}
