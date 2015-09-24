//
//  SGDStoreViewController.h
//  Segundo
//
//  Created by Dustin Bachrach on 2/20/14.
//  Copyright (c) 2014 MediaHound. All rights reserved.
//

#import "SGDStoreResponder.h"
#import "SGDRequester.h"
#import "SGDLoadingIndicator.h"

@class SGDStoreDelegate;
@class SGDStoreDataSource;


@protocol SGDStoreViewController <NSObject>

@required

@property (strong, nonatomic, readonly) SGDStoreDataSource* dataSource; // TODO: Rename to storeDataSource
@property (strong, nonatomic, readonly) SGDStoreDelegate* storeDelegate;
@property (strong, nonatomic, readonly) SGDStore* store;
@property (strong, nonatomic, readonly) id<SGDRequester> requester;

@property (weak, nonatomic) IBOutlet UIView* emptyStoreView;

@property (nonatomic) BOOL showsLoadingIndicators;
@property (nonatomic) BOOL showsPageLoadingIndicators;

- (void)defaultInit;

- (void)showEmptyStoreView;
- (void)hideEmptyStoreView;

+ (Class<SGDLoadingIndicator>)loadingIndicatorClass;
- (id)showLoadingIndicator;
- (void)hideLoadingIndicator;

- (void)configureLoadingIndicator:(id<SGDLoadingIndicator>)indicator;

- (void)showLoadingMoreIndicator;
- (void)hideLoadingMoreIndicator;

@property (nonatomic) BOOL refreshesOnAppear;

@end


@interface SGDStoreViewController : UIViewController <SGDStoreViewController, SGDStoreResponder, SGDRequesterDelegate, SGDRequesterDataSource>


@property (nonatomic) BOOL slidesIntoTopViewController; // TODO: REMOVE THIS STAT

+ (Class<SGDRequester>)requesterClass;

@end
