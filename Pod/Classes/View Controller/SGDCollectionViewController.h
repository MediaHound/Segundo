//
//  SGDCollectionViewController.h
//  Segundo
//
//  Created by Dustin Bachrach on 3/16/14.
//  Copyright (c) 2014 MediaHound. All rights reserved.
//

#import "SGDStoreViewController.h"


/**
 * Use SGDCollectionViewController as a superclass for any
 * collection-based View Controller that you want to enhance with Segundo.
 * Note, this is not a subclass of UICollectionViewController, just UIViewController.
 */
@interface SGDCollectionViewController : SGDStoreViewController

/**
 * The collection view that this controller owns.
 */
@property (weak, nonatomic) IBOutlet UICollectionView* collectionView;

@property (nonatomic) BOOL isHorizontal;
@property (nonatomic) BOOL isVertical;

@end
