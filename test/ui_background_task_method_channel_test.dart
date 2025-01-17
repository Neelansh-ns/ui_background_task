import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_background_task/src/ui_background_task_method_channel.dart';

void main() {
  MethodChannelUiBackgroundTask platform = MethodChannelUiBackgroundTask();
  const MethodChannel channel = MethodChannel('ui_background_task');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async => '42',
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      null,
    );
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
