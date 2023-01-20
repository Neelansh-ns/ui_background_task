import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_background_task/ui_background_task_method_channel.dart';

void main() {
  MethodChannelUiBackgroundTask platform = MethodChannelUiBackgroundTask();
  const MethodChannel channel = MethodChannel('ui_background_task');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
