//
//  SGDEmbeddedCollectionViewCell.h
//  Segundo
//
//  Created by Dustin Bachrach on 3/22/14.
//  Copyright (c) 2014 MediaHound. All rights reserved.
//

#import "SGDCell.h"

@class SGDStore;
@class SGDStoreDataSource;
@class SGDStoreDelegate;


@interface SGDEmbeddedCollectionViewCell : SGDCollectionCell

@property (weak, nonatomic) IBOutlet UICollectionView* collectionView;

@property (strong, nonatomic) SGDStoreDataSource* dataSource;
@property (strong, nonatomic) SGDStoreDelegate* storeDelegate;
@property (strong, nonatomic) SGDStore* store;

@end
