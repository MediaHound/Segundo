//
//  MHEmbeddedCollectionViewCell+MHStore.m
//  mediaHound
//
//  Created by Dustin Bachrach on 3/22/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import "MHEmbeddedCollectionViewCell+MHStore.h"
#import "MHCircularLoadingIndicator.h"


@implementation MHEmbeddedCollectionViewCell (MHStore)

- (void)configureWithMHStore:(MHStore*)store
{
    [MHCircularLoadingIndicator hideLoadingIndicatorOnView:self.collectionView];
    
    self.store = store;
    
    [self.collectionView reloadData];
}

@end
