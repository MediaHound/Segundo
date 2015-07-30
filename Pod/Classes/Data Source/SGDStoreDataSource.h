//
//  SGDArrayDataSource.h
//  Segundo
//
//  Created by Dustin Bachrach on 2/18/14.
//  Copyright (c) 2014 MediaHound. All rights reserved.
//

@class SGDStore;


/**
 * SGDStoreDataSource is a common data source for collection views and table views.
 * It follows the Lighter View Controller pattern.
 **/
@interface SGDStoreDataSource : NSObject <UICollectionViewDataSource, UITableViewDataSource>

/**
 * The underlying store that is used to fulfill the data source requirements.
 */
@property (weak, nonatomic) SGDStore* store;

@end
