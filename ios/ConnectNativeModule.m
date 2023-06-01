//
//  ConnectNativeModule.m
//  SuperApp
//
//  Created by Nguyen Trai on 26/04/2023.
//
#import "ConnectNativeModule.h"
#import <React/RCTRootView.h>
#import "Promise.h"
@implementation ConnectNativeModule

static NSMutableDictionary *emitters;
static NSMutableDictionary *promises;
static NSMutableDictionary *whiteList;

static UIViewController *vc;
static RCTResponseSenderBlock closeCallBack;

RCT_EXPORT_MODULE()

__attribute__((constructor))
static void initialize() {
  if (emitters == nil) emitters = [[NSMutableDictionary alloc] init];
  if (promises == nil) promises = [[NSMutableDictionary alloc] init];
}

- (NSArray<NSString *> *)supportedEvents
{
  return @[@"EventMessage", @"EventRequest"];
}

RCT_EXPORT_METHOD(openApp:(NSString *)bundleName appPath:(NSString *)appPath
                  initProps:(NSDictionary *)initProps devLoad:(BOOL)devLoad callback:(RCTResponseSenderBlock)callback)
{
    NSURL *jsCodeLocation;
    if (devLoad)
        jsCodeLocation = [NSURL URLWithString:@"http://localhost:8082/index.bundle?platform=ios&dev=true&minify=false"];
    else
        jsCodeLocation = [NSURL URLWithString:appPath];

    dispatch_async(dispatch_get_main_queue(), ^{
        RCTRootView *rootView =
          [[RCTRootView alloc] initWithBundleURL: jsCodeLocation
                                      moduleName: bundleName
                               initialProperties: initProps
                                   launchOptions: nil];
        vc = [[UIViewController alloc] init];
        [vc setModalPresentationStyle: UIModalPresentationFullScreen];
        vc.view = rootView;

        [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:vc animated:YES completion:nil];
        closeCallBack = callback;
    });
}

RCT_EXPORT_METHOD(bringSuperToFront:(RCTResponseSenderBlock)callback)
{
    NSMutableDictionary *result = [NSMutableDictionary new];
    if (vc) {
        [result setObject:@"Ok" forKey:@"msg"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [vc dismissViewControllerAnimated:YES completion:nil];
        });
    } else {
        [result setObject:@"Cannot find mini app" forKey:@"msg"];
    }
    callback(@[result]);
}

RCT_EXPORT_METHOD(bringMiniAppToFront:(RCTResponseSenderBlock)callback)
{
    NSMutableDictionary *result = [NSMutableDictionary new];
    if (vc) {
        [result setObject:@"Ok" forKey:@"msg"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:vc animated:YES completion:nil];
        });
    } else {
        [result setObject:@"Cannot find mini app" forKey:@"msg"];
    }
    callback(@[result]);
}

RCT_EXPORT_METHOD(closeApp:(NSString *)bundleName result:(NSDictionary *)result)
{
    @try {
        dispatch_async(dispatch_get_main_queue(), ^{
            [vc dismissViewControllerAnimated:YES completion:nil];
            // check null
            if(result!=nil){
                closeCallBack(@[result]);
            }
            
            vc = nil;
            closeCallBack = nil;
        });
        [emitters removeObjectForKey:bundleName];
        
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    @finally {
        NSLog(@"finally");
    }
    
    
}

RCT_EXPORT_METHOD(addBridge:(NSString *)bundleName)
{
    [emitters setObject: self forKey:bundleName];
}

RCT_EXPORT_METHOD(sendMessage:(NSString *)bundleName msg:(NSDictionary *)msg callback:(RCTResponseSenderBlock)callback)
{
    RCTEventEmitter* emitter = [emitters objectForKey: bundleName];
    NSMutableDictionary *result = [NSMutableDictionary new];
    if (emitter) {
        [emitter sendEventWithName:@"EventMessage" body:msg];
        [result setObject:@"Send message ok!" forKey:@"msg"];
    } else {
        NSString *str = @"[sendMessage] Cannot find this bundle name ";
        str = [str stringByAppendingString:bundleName];
        [result setObject:str forKey:@"msg"];
    }
    callback(@[result]);
}

RCT_EXPORT_METHOD(replyResponse:(NSString *)requestId response: (NSDictionary *)response callback:(RCTResponseSenderBlock)callback)
{
    Promise *promise = [promises objectForKey:requestId];
    NSMutableDictionary *result = [NSMutableDictionary new];
    if (promise) {
        promise.resolve(response);
        [promises removeObjectForKey:requestId];
        [result setObject:@"Reply response ok!" forKey:@"msg"];
    } else {
        NSString *str = @"[replyResponse] Cannot find promise with id ";
        str = [str stringByAppendingString:requestId];
        [result setObject:str forKey:@"msg"];
    }
    callback(@[result]);
}

RCT_EXPORT_METHOD(replyError:(NSString *)requestId error: (NSDictionary *)error callback: (RCTResponseSenderBlock)callback) {
    Promise *promise = [promises objectForKey:requestId];
    NSMutableDictionary *result = [NSMutableDictionary new];
    if (promise) {
        NSError *nsError = [NSError errorWithDomain:@"XFramework" code:0 userInfo:error];
        promise.reject(@"Error", @"", nsError);
        [promises removeObjectForKey:requestId];
        [result setObject:@"Reply error ok!" forKey:@"msg"];
    } else {
        NSString *str = @"[replyError] Cannot find promise with id ";
        str = [str stringByAppendingString:requestId];
        [result setObject:str forKey:@"msg"];
    }
    callback(@[result]);
}

RCT_REMAP_METHOD(sendRequest,
                 bundle: (NSString *)bundleName
                 request:(NSDictionary *)request
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    NSString *appId = [request valueForKey:@"appId"];
    NSString *type = [request valueForKey:@"type"];
    NSError *error = [NSError errorWithDomain:@"XFramework" code:0 userInfo:nil];

    if (appId == nil || type == nil) {
        reject(@"Error", @"Invalid request, missing appId or type" , error);
        return;
    }
    
    NSArray *permission = [whiteList objectForKey:appId];
    if (permission == nil || ![permission containsObject:type]) {
        reject(@"Error", @"The request isn't allowed diem" , error);
        return;
    }
    
    RCTEventEmitter* emitter = [emitters objectForKey: bundleName];
    if (emitter) {
        NSString *requestId = [[NSUUID UUID] UUIDString];
        Promise *promise = [[Promise alloc] initWithResolve:resolve reject:reject];
        [promises setValue:promise forKey:requestId];
        [request setValue:requestId forKey:@"id"];
        [emitter sendEventWithName:@"EventRequest" body:request];
    } else {
        NSString *str = @"[sendRequest] Cannot find this bundle name ";
        str = [str stringByAppendingString:bundleName];
        reject(@"Error", str , error);
    }
}

RCT_REMAP_METHOD(getBundleNames,
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    NSArray *arr = [emitters allKeys];
    if (arr.count > 0) {
        resolve(arr);
    } else {
        NSError *nsError = [NSError errorWithDomain:@"XFramework" code:0 userInfo:nil];
        reject(@"Error", @"No listeners", nsError);
    }
}

@end
