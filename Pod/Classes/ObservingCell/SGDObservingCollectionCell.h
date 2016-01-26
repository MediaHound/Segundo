//
//  ObservingCollectionCell.h
//  Segundo
//
//  Created by Dustin Bachrach on 9/26/14.
//  Copyright (c) 2014 MediaHound. All rights reserved.
//

#import "SGDCell.h"
#import <KVOController/FBKVOController.h>


/**
 * A useful base class for SGDCollectionCells that need to use key-value
 * observing on their row's data.
 * 
 * By using SGDObservingCollectionCell, KVO registrations are automatically
 * unregistered on `-prepareForReusue`.
 */
@interface SGDObservingCollectionCell : SGDCollectionCell

- (void)observeRowDataKeyPath:(NSString*)keypath block:(void(^)())block;

@end
