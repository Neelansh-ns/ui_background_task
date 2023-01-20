#import "UiBackgroundTaskPlugin.h"
#if __has_include(<ui_background_task/ui_background_task-Swift.h>)
#import <ui_background_task/ui_background_task-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "ui_background_task-Swift.h"
#endif

@implementation UiBackgroundTaskPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftUiBackgroundTaskPlugin registerWithRegistrar:registrar];
}
@end
