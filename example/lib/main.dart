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
                    _taskId =
                        await UiBackgroundTask.instance.beginBackgroundTask();
                    setState(() {});
                  },
                  child: const Text('Begin background task')),
              const SizedBox(
                width: 24,
              ),
              if (_taskId != null)
                ElevatedButton(
                  onPressed: () {
                    UiBackgroundTask.instance.endBackgroundTask(_taskId!);
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
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    UiBackgroundTask.instance.appLifeCycleUpdate(state);
  }
}
