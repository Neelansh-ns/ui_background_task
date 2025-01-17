import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:ui_background_task/src/ui_background_task_method_channel.dart';
import 'package:ui_background_task/src/ui_background_task_platform_interface.dart';

class MockUiBackgroundTaskPlatform extends UiBackgroundTaskPlatform
    with MockPlatformInterfaceMixin {
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
    MockUiBackgroundTaskPlatform fakePlatform = MockUiBackgroundTaskPlatform();
    expect(await fakePlatform.getPlatformVersion(), '42');
  });
}
