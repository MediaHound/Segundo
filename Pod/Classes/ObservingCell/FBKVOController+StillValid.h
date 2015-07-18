//
//  FBKVOController+StillValid.h
//  mediaHound
//
//  Created by Dustin Bachrach on 9/26/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import "FBKVOController.h"


@interface FBKVOController (StillValid)

- (void)observe:(id)object
        keyPath:(NSString *)keyPath
        options:(NSKeyValueObservingOptions)options
          block:(FBKVONotificationBlock)block
     stillValid:(BOOL(^)())stillValid;

- (void)observeOnMainThread:(id)object
        keyPath:(NSString *)keyPath
        options:(NSKeyValueObservingOptions)options
          block:(FBKVONotificationBlock)block
     stillValid:(BOOL(^)())stillValid;

@end
