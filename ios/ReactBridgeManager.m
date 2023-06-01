//
//  ReactBridgeManager.m
//  SuperApp
//
//  Created by Nguyen Trai on 26/04/2023.
//

#import "ReactBridgeManager.h"

@interface ReactBridgeManager () <RCTBridgeDelegate>
@property (nonatomic, strong, readwrite) RCTBridge *bridge;
@property (nonatomic, strong) NSURL *bundleURL;
@end

@implementation ReactBridgeManager

- (instancetype)initWithBundleURL:(NSURL *)bundleURL launchOptions:(NSDictionary *)launchOptions
{
  self = [super init];
  if (self)
  {
    self.bundleURL = bundleURL;
    self.bridge = [[RCTBridge alloc] initWithDelegate:self launchOptions:launchOptions];
  }
  return self;
}

#pragma mark - RCTBridgeDelegate methods

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
  return self.bundleURL;
}

@end
