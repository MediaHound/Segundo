//
//  ObservingCollectionCell.m
//  Segundo
//
//  Created by Dustin Bachrach on 9/26/14.
//  Copyright (c) 2014 MediaHound. All rights reserved.
//

#import "SGDObservingCollectionCell.h"
#import "SGDRow.h"
#import "FBKVOController+StillValid.h"
#import <AtSugar/AtSugar.h>


@implementation SGDObservingCollectionCell

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    [self.KVOController unobserveAll];
}

- (void)observeRowDataKeyPath:(NSString*)keypath block:(void(^)())block
{
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
