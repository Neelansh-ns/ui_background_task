import 'package:flutter/material.dart';
import 'package:ui_background_task/ui_background_task.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  int? _taskId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Background Task Example app'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final taskId =
                      await UiBackgroundTask.instance.beginBackgroundTask();
                  if (!mounted) return;
                  setState(() {
                    _taskId = taskId == 0 ? null : taskId;
                  });
                },
                child: const Text('Begin background task'),
              ),
              const SizedBox(height: 24),
              if (_taskId != null)
                ElevatedButton(
                  onPressed: () async {
                    await UiBackgroundTask.instance.endBackgroundTask(_taskId!);
                    if (!mounted) return;
                    setState(() {
                      _taskId = null;
                    });
                  },
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

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    UiBackgroundTask.instance.appLifeCycleUpdate(state);
  }
}
