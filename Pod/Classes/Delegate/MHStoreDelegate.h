//
//  MHStoreDelegate.h
//  mediaHound
//
//  Created by Dustin Bachrach on 3/14/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

@class MHStore;

// TODO: This constant string should be defined in the MHStoreDelegate subclass specific for waterfall layouts
extern NSString* const MHStoreContextColumnCountKey;


// TODO: Make a shared class that is delegate and data source
@interface MHStoreDelegate : NSObject <UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (weak, nonatomic) MHStore* store;

// TODO: Think about this more
@property (weak, nonatomic) id/*<UIScrollViewDelegate>*/ scrollViewDelegate;

@end
