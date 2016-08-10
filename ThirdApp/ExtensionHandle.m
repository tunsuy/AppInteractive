//
//  ExtensionHandle.m
//  ThirdApp
//
//  Created by tunsuy on 4/8/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import "ExtensionHandle.h"
#import "AuthorizeLoginViewController.h"
#import "MOAInfoViewController.h"
#import "AppDelegate.h"

@interface ExtensionHandle()

@property (nonatomic, strong) NSDictionary *web2iOSVCInfo;

@end

@implementation ExtensionHandle

- (NSDictionary *)web2iOSVCInfo {
    if (!_web2iOSVCInfo) {
        _web2iOSVCInfo = @{
                           @"authLogin": @"AuthorizeLoginViewController"
                           };
    }
    return _web2iOSVCInfo;
}

+ (void)handleMOACallbackUrl:(NSURL *)url {
    
    if ([url.absoluteString rangeOfString:@"com.tunsuy.third"].location == NSNotFound) {
        NSLog(@"非法的链接！！！！");
    }
    
    NSArray *urlComponents = [url.absoluteString componentsSeparatedByString:@"com.tunsuy.third://"];
    NSString *callbackStr = urlComponents.lastObject;
    NSString *decodingCallbackStr = [callbackStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *callbackParams = [self analyzeQuery:decodingCallbackStr];
    
    NSString *valuesStr = [NSString stringWithFormat:@"%@", callbackParams[@"values"]];
    NSData *valuesData = [valuesStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *values = [NSJSONSerialization JSONObjectWithData:valuesData options:0 error:nil];
    
    NSString *code = [NSString stringWithFormat:@"%@", values[@"code"]];
    NSLog(@"口袋助理返回的code：%@", code);
    [self requestToServerWithCode:code];
    
}

+ (void)requestToServerForPersonInfoWithCallback:(TSCallback)callback {
    
    NSString *urlStr = @"http:200.200.169.162:8001/app2serverForPersonInfo";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    __block NSMutableDictionary *personInfo = @{}.mutableCopy;
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"发生了错误！！！, %@", error);
            callback(error);
            return ;
        }
        //handle response
        personInfo = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"personInfo: %@", personInfo);
        callback(personInfo);
        
    }];
    [dataTask resume];
    
}

+ (NSDictionary *)analyzeQuery:(NSString *)query {
    NSMutableDictionary *keyValues = [NSMutableDictionary dictionary];
    NSArray *queryArray = [query componentsSeparatedByString:@"&"];
    for (NSString *oneParma in queryArray) {
        NSArray *keyValue = [oneParma componentsSeparatedByString:@"="];
        if (keyValue.count >=2) {
            keyValues[keyValue[0]] = keyValue[1];
        }
    }
    return keyValues;
}

+ (void)requestToServerWithCode:(NSString *)code {
    NSString *urlStr = [NSString stringWithFormat:@"http:200.200.169.162:8001/thirdApp2thirdServer?code=%@", code];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"发生了错误！！！, %@", error);
        }
        //handle response
    }];
    [dataTask resume];
}

+ (void)handleOpenUrl:(NSURL *)url {
    if ([url.absoluteString rangeOfString:@"com.tunsuy.third"].location == NSNotFound) {
        NSLog(@"非法的链接！！！！");
        return;
    }
    
    NSArray *urlComponents = [url.absoluteString componentsSeparatedByString:@"com.tunsuy.third://"];
    NSArray *urlID = [urlComponents.lastObject componentsSeparatedByString:@"?"];
    
    NSString *modVCName = urlID.firstObject;
//    Class jmpClass = NSClassFromString(modVCName);
    //这里只是作为测试用，真正的项目不能这样写
    UIViewController *jmpVC;
    if ([modVCName isEqualToString:@"authlogin"]) {
        NSString *codeDicStr = urlID.lastObject;
        NSString *decodingCodeDicStr = [codeDicStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *codeDic = [self analyzeQuery:decodingCodeDicStr];
        
        NSString *code = [NSString stringWithFormat:@"%@", codeDic[@"code"]];
        NSLog(@"口袋助理返回的code：%@", code);
        [self requestToServerWithCode:code];
        
        jmpVC = [[AuthorizeLoginViewController alloc] init];
        
    }
    else {
        [self handleMOACallbackUrl:url];
        jmpVC = [[MOAInfoViewController alloc] init];
    
    }
    UINavigationController *nav = (UINavigationController *)[[UIApplication sharedApplication] delegate].window.rootViewController;
    [nav pushViewController:jmpVC animated:NO];
}

@end
