#import "NativeResourcePlugin.h"
#if __has_include(<native_resource/native_resource-Swift.h>)
#import <native_resource/native_resource-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "native_resource-Swift.h"
#endif

@implementation NativeResourcePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftNativeResourcePlugin registerWithRegistrar:registrar];
}
@end
