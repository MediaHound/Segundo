//
//  SGDStoreDelegate.h
//  Segundo
//
//  Created by Dustin Bachrach on 3/14/14.
//  Copyright (c) 2014 MediaHound. All rights reserved.
//

@class SGDStore;

// TODO: This constant string should be defined in the SGDStoreDelegate subclass specific for waterfall layouts
extern NSString* const SGDStoreContextColumnCountKey;


// TODO: Make a shared class that is delegate and data source
@interface SGDStoreDelegate : NSObject <UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

/**
 * The underlying store that is used to fulfill the delegate requirements.
 */
@property (weak, nonatomic) SGDStore* store;

// TODO: Think about this more
@property (weak, nonatomic) id/*<UIScrollViewDelegate>*/ scrollViewDelegate;

@end
