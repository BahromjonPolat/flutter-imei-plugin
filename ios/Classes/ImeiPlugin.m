#import "ImeiPlugin.h"
#if __has_include(<imei/imei-Swift.h>)
#import <imei/imei-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "imei-Swift.h"
#endif

@implementation ImeiPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftImeiPlugin registerWithRegistrar:registrar];
}
@end
