//
//  ReactViewController.h
//  SuperApp
//
//  Created by Nguyen Trai on 26/04/2023.
//

#import <UIKit/UIKit.h>
#import <React/RCTBridge.h>


@interface ReactViewController : UIViewController
- (instancetype)initWithBridge:(RCTBridge *)bridge moduleName:(NSString*)moduleName initialProps:(NSDictionary*)initialProps;
@end
