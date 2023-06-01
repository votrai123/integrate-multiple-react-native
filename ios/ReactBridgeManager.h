//
//  ReactBridgeManager.h
//  SuperApp
//
//  Created by Nguyen Trai on 26/04/2023.
//
#import <React/RCTBridge.h>

@interface ReactBridgeManager : NSObject
@property (nonatomic, strong, readonly) RCTBridge *bridge;
-(instancetype)initWithBundleURL:(NSURL *)bundleURL launchOptions:(NSDictionary *)launchOptions;
@end
