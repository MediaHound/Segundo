//
//  MHViewController.h
//  mediaHound
//
//  Created by Dustin Bachrach on 2/20/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import "MHFetcher.h"
#import "MHStoreResponder.h"
#import "MHRequester.h"
#import "MHLoadingIndicator.h"

@class MHStoreDelegate;
@class MHStoreDataSource;


@protocol MHStoreViewController <NSObject>

@required

@property (strong, nonatomic, readonly) MHStoreDataSource* dataSource; // TODO: Rename to storeDataSource
@property (strong, nonatomic, readonly) MHStoreDelegate* storeDelegate;
@property (strong, nonatomic, readonly) MHStore* store;
@property (strong, nonatomic, readonly) id<MHRequester> requester;

@property (weak, nonatomic) IBOutlet UIView* emptyStoreView;

@property (nonatomic) BOOL showsLoadingIndicators;
@property (nonatomic) BOOL showsPageLoadingIndicators;

- (void)showEmptyStoreView;
- (void)hideEmptyStoreView;

+ (Class<MHLoadingIndicator>)loadingIndicatorClass;
- (id)showLoadingIndicator;
- (void)hideLoadingIndicator;

- (void)configureLoadingIndicator:(id<MHLoadingIndicator>)indicator;

- (void)showLoadingMoreIndicator;
- (void)hideLoadingMoreIndicator;

@property (nonatomic) BOOL refreshesOnAppear;

@end


@interface MHStoreViewController : UIViewController <MHStoreViewController, MHStoreResponder, MHRequesterDelegate, MHRequesterDataSource>


@property (nonatomic) BOOL slidesIntoTopViewController; // TODO: REMOVE THIS STAT

+ (Class<MHRequester>)requesterClass;

@end
