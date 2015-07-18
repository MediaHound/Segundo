//
//  ObservingCollectionCell.m
//  mediaHound
//
//  Created by Dustin Bachrach on 9/26/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import "ObservingCollectionCell.h"
#import "MHRow.h"
#import "FBKVOController+StillValid.h"
#import <KVOController/NSObject+FBKVOController.h>
#import <AtSugar/AtSugar.h>


@implementation ObservingCollectionCell

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    [self.KVOController unobserveAll];
}

- (void)observeRowDataKeyPath:(NSString*)keypath block:(void(^)())block
{
    // TODO: Support a MHRelationalPair
    id model = self.row.data;
    
    @weakSelf()
    [self.KVOController observeOnMainThread:model
                        keyPath:keypath
                        options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                          block:^(id observer, id object, NSDictionary* change) {
                              if (block) {
                                  block();
                              }
                          }
                     stillValid:^BOOL{
                         return ([weakSelf.row.data isEqual:model]);
                     }];
}

@end
