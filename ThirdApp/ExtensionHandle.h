//
//  ExtensionHandle.h
//  ThirdApp
//
//  Created by tunsuy on 4/8/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TSCallback)(id result);

@interface ExtensionHandle : NSObject

+ (void)handleMOACallbackUrl:(NSURL *)url;
+ (void)requestToServerForPersonInfoWithCallback:(TSCallback)callback;
+ (void)handleOpenUrl:(NSURL *)url;

@end
