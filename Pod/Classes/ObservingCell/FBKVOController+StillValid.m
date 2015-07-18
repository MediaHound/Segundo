//
//  FBKVOController+StillValid.m
//  mediaHound
//
//  Created by Dustin Bachrach on 9/26/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import "FBKVOController+StillValid.h"


@implementation FBKVOController (StillValid)

- (void)observe:(id)object
        keyPath:(NSString *)keyPath
        options:(NSKeyValueObservingOptions)options
          block:(FBKVONotificationBlock)block
     stillValid:(BOOL(^)())stillValid
{
    [self observe:object
          keyPath:keyPath
          options:options
            block:^(id observer, id innerObject, NSDictionary *change) {
                if (stillValid && !stillValid()) {
                    return;
                }
                if (block) {
                    block(observer, innerObject, change);
                }
            }];
}

- (void)observeOnMainThread:(id)object
                    keyPath:(NSString *)keyPath
                    options:(NSKeyValueObservingOptions)options
                      block:(FBKVONotificationBlock)block
                 stillValid:(BOOL(^)())stillValid
{
    [self observe:object keyPath:keyPath options:options block:^(id observer, id object, NSDictionary *change) {
        dispatch_async(dispatch_get_main_queue(), ^{
            block(observer, object, change);
        });
    }
       stillValid:stillValid];
}

@end
