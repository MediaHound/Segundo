//
//  MHStoreViewController+Internal.h
//  CoreStore
//
//  Created by Dustin Bachrach on 2/12/15.
//
//

#import "MHStoreViewController.h"


@interface MHStoreViewController (Internal)

@property (strong, nonatomic, readwrite) MHStoreDataSource* dataSource; // TODO: Rename to storeDataSource
@property (strong, nonatomic, readwrite) MHStoreDelegate* storeDelegate;
@property (strong, nonatomic, readwrite) MHStore* store;
@property (strong, nonatomic, readwrite) id<MHRequester> requester;

@end
