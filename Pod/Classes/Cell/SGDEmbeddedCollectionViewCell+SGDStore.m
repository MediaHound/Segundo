//
//  SGDEmbeddedCollectionViewCell+SGDStore.m
//  Segundo
//
//  Created by Dustin Bachrach on 3/22/14.
//  Copyright (c) 2014 MediaHound. All rights reserved.
//

#import "SGDEmbeddedCollectionViewCell+SGDStore.h"


@implementation SGDEmbeddedCollectionViewCell (SGDStore)

- (void)configureWithSGDStore:(SGDStore*)store
{
    self.store = store;
    
    [self.collectionView reloadData];
}

@end
