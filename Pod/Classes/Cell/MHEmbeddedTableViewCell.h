//
//  MHEmbeddedTableViewCell.h
//  mediaHound
//
//  Created by Dustin Bachrach on 3/22/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import "MHCell.h"

@class MHStore;
@class MHStoreDataSource;
@class MHStoreDelegate;


@interface MHEmbeddedTableViewCell : MHCollectionCell

@property (weak, nonatomic) IBOutlet UITableView* tableView;

@property (strong, nonatomic) MHStoreDataSource* dataSource;
@property (strong, nonatomic) MHStoreDelegate* storeDelegate;
@property (strong, nonatomic) MHStore* store;

@end
