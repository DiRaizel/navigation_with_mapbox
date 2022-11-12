#import "NavigationWithMapboxPlugin.h"
#if __has_include(<navigation_with_mapbox/navigation_with_mapbox-Swift.h>)
#import <navigation_with_mapbox/navigation_with_mapbox-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "navigation_with_mapbox-Swift.h"
#endif

@implementation NavigationWithMapboxPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftNavigationWithMapboxPlugin registerWithRegistrar:registrar];
}
@end
