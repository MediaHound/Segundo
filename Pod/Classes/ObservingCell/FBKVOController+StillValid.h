//
//  FBKVOController+StillValid.h
//  Segundo
//
//  Created by Dustin Bachrach on 9/26/14.
//  Copyright (c) 2014 MediaHound. All rights reserved.
//

#import <KVOController/FBKVOController.h>


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
