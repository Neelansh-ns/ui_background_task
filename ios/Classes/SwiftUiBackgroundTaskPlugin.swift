import Flutter
import UIKit

public class SwiftUiBackgroundTaskPlugin: NSObject, FlutterPlugin {
    
    
    var runningTaskDictionary = Dictionary<UIBackgroundTaskIdentifier, BackgroundTask>()
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "ui_background_task", binaryMessenger: registrar.messenger())
        let instance = SwiftUiBackgroundTaskPlugin()
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
            break;
            
        case "endBackgroundTask":
            
            let args = call.arguments as? [String: Any?]
            let taskId = args?["taskId"] as? Int
            
            if taskId == nil {
                result(nil)
                return
            }
            
            let backgroundTask: BackgroundTask? = runningTaskDictionary[UIBackgroundTaskIdentifier(rawValue: taskId!)]
            
            if backgroundTask != nil {
                backgroundTask?.end();
                result(nil)
            }
            break;
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
