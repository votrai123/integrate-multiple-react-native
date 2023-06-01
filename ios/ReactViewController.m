//
//  ReactViewController.m
//  SuperApp
//
//  Created by Nguyen Trai on 26/04/2023.
//
#import "ReactViewController.h"
#import <React/RCTRootView.h>

@implementation ReactViewController

- (instancetype)initWithBridge:(RCTBridge *)bridge moduleName:(NSString*)moduleName initialProps:(NSDictionary*)initialProps
{
  self = [super init];
  if(self)
  {
    self.view = [[RCTRootView alloc] initWithBridge:bridge moduleName:moduleName initialProperties:initialProps];
  }
  return self;
}

@end
