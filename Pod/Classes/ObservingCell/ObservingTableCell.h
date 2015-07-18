//
//  ObservingTableCell.h
//  mediaHound
//
//  Created by Dustin Bachrach on 9/26/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import "MHCell.h"
#import <KVOController/FBKVOController.h>


@interface ObservingTableCell : MHTableCell

- (void)observeRowDataKeyPath:(NSString*)keypath block:(void(^)())block;

@end
