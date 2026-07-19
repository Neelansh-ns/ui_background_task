import Flutter
import UIKit

public class UiBackgroundTaskPlugin: NSObject, FlutterPlugin {
    var runningTaskDictionary = [UIBackgroundTaskIdentifier: BackgroundTask]()

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "ui_background_task",
            binaryMessenger: registrar.messenger()
        )
        let instance = UiBackgroundTaskPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "beginBackgroundTask":
            let application = UIApplication.shared
            BackgroundTask.run(application: application) { backgroundTask in
                runningTaskDictionary[backgroundTask.identifier] = backgroundTask
                result(backgroundTask.identifier.rawValue)
            }

        case "endBackgroundTask":
            let args = call.arguments as? [String: Any?]
            let taskId = args?["taskId"] as? Int

            guard let taskId else {
                result(nil)
                return
            }

            let identifier = UIBackgroundTaskIdentifier(rawValue: taskId)
            if let backgroundTask = runningTaskDictionary[identifier] {
                backgroundTask.end()
                result(nil)
            }

        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

@available(*, deprecated, renamed: "UiBackgroundTaskPlugin")
@objc(SwiftUiBackgroundTaskPlugin)
public class SwiftUiBackgroundTaskPlugin: UiBackgroundTaskPlugin {}
