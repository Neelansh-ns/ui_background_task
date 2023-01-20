import Foundation

class BackgroundTask {
    private let application: UIApplication
    var identifier = UIBackgroundTaskIdentifier.invalid

    init(application: UIApplication) {
        self.application = application
    }

    class func run(application: UIApplication, handler: (BackgroundTask) -> ()) {
        // NOTE: The handler must call end() when it is done

        let backgroundTask = BackgroundTask(application: application)
        backgroundTask.begin()
        handler(backgroundTask)
    }

    func begin() {
        NSLog("Begin background task:)")
        self.identifier = application.beginBackgroundTask {
            NSLog("Background task ended expirationhandler")
            self.end()
        }
        NSLog("Background time remaining:) \(application.backgroundTimeRemaining)")
    }

    func end() {
        if (identifier != UIBackgroundTaskIdentifier.invalid) {
            application.endBackgroundTask(identifier)
        }

        identifier = UIBackgroundTaskIdentifier.invalid
    }
}
