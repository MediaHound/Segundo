//
//  MHEmbeddedCollectionViewCell.h
//  mediaHound
//
//  Created by Dustin Bachrach on 3/22/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import "MHCell.h"

@class MHStore;
@class MHStoreDataSource;
@class MHStoreDelegate;


@interface MHEmbeddedCollectionViewCell : MHCollectionCell

@property (weak, nonatomic) IBOutlet UICollectionView* collectionView;

@property (strong, nonatomic) MHStoreDataSource* dataSource;
@property (strong, nonatomic) MHStoreDelegate* storeDelegate;
@property (strong, nonatomic) MHStore* store;

@end
