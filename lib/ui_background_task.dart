
import 'ui_background_task_platform_interface.dart';

class UiBackgroundTask {
  Future<int?> beginBackgroundTask() {
    return UiBackgroundTaskPlatform.instance.beginBackgroundTask();
  }

  Future<void> endBackgroundTask(int taskId) {
    return UiBackgroundTaskPlatform.instance.endBackgroundTask(taskId);
  }
}
