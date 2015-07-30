//
//  SGDStoreViewController+Internal.h
//  Segundo
//
//  Created by Dustin Bachrach on 2/12/15.
//
//

#import "SGDStoreViewController.h"


@interface SGDStoreViewController (Internal)

@property (strong, nonatomic, readwrite) SGDStoreDataSource* dataSource; // TODO: Rename to storeDataSource
@property (strong, nonatomic, readwrite) SGDStoreDelegate* storeDelegate;
@property (strong, nonatomic, readwrite) SGDStore* store;
@property (strong, nonatomic, readwrite) id<SGDRequester> requester;

@end
