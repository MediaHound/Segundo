//
//  MHArrayDataSource.h
//  mediaHound
//
//  Created by Dustin Bachrach on 2/18/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

@class MHStore;


/**
 * MHStoreDataSource is a common data source for collection views and table views.
 * It follows the Lighter View Controller pattern.
 **/
@interface MHStoreDataSource : NSObject <UICollectionViewDataSource, UITableViewDataSource>

@property (weak, nonatomic) MHStore* store;

@end
