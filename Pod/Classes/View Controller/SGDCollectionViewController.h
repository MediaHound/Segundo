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

/// After the first page is loaded, the collection view will test to see if the first page
/// fills the whole page. Increasing this value allows you to increase how much more than the full collectionView height/width must be filled.
@property (nonatomic) CGFloat autoloadFuzzySize;

@end
