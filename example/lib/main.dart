import 'package:flutter/material.dart';
import 'package:ui_background_task/ui_background_task.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _uiBackgroundTaskPlugin = UiBackgroundTask();

  int? _taskId;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    _taskId = await _uiBackgroundTaskPlugin.beginBackgroundTask();
                    setState(() {});
                  },
                  child: const Text('Begin background task')),
              const SizedBox(
                width: 24,
              ),
              if (_taskId != null)
                ElevatedButton(
                  onPressed: () => _uiBackgroundTaskPlugin.endBackgroundTask(_taskId!),
                  child: Text(
                    'End background task: $_taskId',
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
