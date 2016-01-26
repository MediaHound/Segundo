//
//  SGDCollectionViewController.h
//  Segundo
//
//  Created by Dustin Bachrach on 3/16/14.
//  Copyright (c) 2014 MediaHound. All rights reserved.
//

#import "SGDStoreViewController.h"


@interface SGDCollectionViewController : SGDStoreViewController <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView* collectionView;

@property (nonatomic) BOOL isHorizontal;
@property (nonatomic) BOOL isVertical;

@end
