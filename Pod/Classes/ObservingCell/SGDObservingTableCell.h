//
//  ObservingTableCell.h
//  Segundo
//
//  Created by Dustin Bachrach on 9/26/14.
//  Copyright (c) 2014 MediaHound. All rights reserved.
//

#import "SGDCell.h"
#import <KVOController/FBKVOController.h>


@interface SGDObservingTableCell : SGDTableCell

- (void)observeRowDataKeyPath:(NSString*)keypath block:(void(^)())block;

@end
