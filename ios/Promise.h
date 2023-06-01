//
//  Promise.h
//  SuperApp
//
//  Created by Nguyen Trai on 26/04/2023.
//
#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>

@interface Promise: NSObject {
}

@property RCTPromiseRejectBlock reject;
@property RCTPromiseResolveBlock resolve;


- (instancetype)initWithResolve: (RCTPromiseResolveBlock)resolve reject: (RCTPromiseRejectBlock)reject;
@end
