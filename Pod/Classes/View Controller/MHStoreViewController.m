//
//  MHViewController.m
//  mediaHound
//
//  Created by Dustin Bachrach on 2/20/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import "MHStoreViewController.h"
#import "MHStoreViewController+Internal.h"
#import "MHStore.h"
#import "MHStoreDataSource.h"
#import "MHStoreDelegate.h"
#import "MHCircularLoadingIndicator.h"
#import "MHPagedResponse.h"
#import <castaway/castaway.h>


@interface MHStoreViewController ()

@property (strong, nonatomic, readwrite) MHStoreDataSource* dataSource; // TODO: Rename to storeDataSource
@property (strong, nonatomic, readwrite) MHStoreDelegate* storeDelegate;
@property (strong, nonatomic, readwrite) MHStore* store;
@property (strong, nonatomic, readwrite) id<MHRequester> requester;

@property (nonatomic) BOOL hasAppeared;
@property (nonatomic) BOOL needsLoadingIndicatorShown;

@end


@implementation MHStoreViewController

@synthesize store = _store;
@synthesize dataSource;
@synthesize storeDelegate;
@synthesize model = _model;
@synthesize emptyStoreView = _emptyStoreView;
@synthesize showsLoadingIndicators = _showsLoadingIndicators;
@synthesize showsPageLoadingIndicators = _showsPageLoadingIndicators;
@synthesize requester = _requester;
@synthesize refreshesOnAppear = _refreshesOnAppear;

+ (Class<MHRequester>)requesterClass
{
    return nil;
}

+ (Class<MHLoadingIndicator>)loadingIndicatorClass
{
    return MHCircularLoadingIndicator.class;
}

- (id)showLoadingIndicator
{
    return [self.class.loadingIndicatorClass showLoadingIndicatorOnView:self.view];
}

- (void)hideLoadingIndicator
{
    [self.class.loadingIndicatorClass hideLoadingIndicatorOnView:self.view];
}

- (void)showLoadingMoreIndicator
{
    // Subclasses should override
}

- (void)hideLoadingMoreIndicator
{
    // Subclasses should override
}

- (void)requesterDidBeginRefreshing:(id<MHRequester>)requester
{
    if (self.showsLoadingIndicators) {
        if (self.hasAppeared) {
            id indicator = [self showLoadingIndicator];
            [self configureLoadingIndicator:indicator];
        }
        else {
            self.needsLoadingIndicatorShown = YES;
        }
    }
    
    [self hideEmptyStoreView];
}

- (void)requesterDidBeiginFetchingAnotherPage:(id<MHRequester>)requester
{
    if (self.showsPageLoadingIndicators) {
        [self showLoadingMoreIndicator];
    }
}

- (void)requesterWillBeginLoading:(id<MHRequester>)requester
{
    if (self.showsPageLoadingIndicators) {
        if (!self.store.isEmpty) {
            [self hideLoadingMoreIndicator];
        }
    }
}

- (void)requesterDidFinishRequest:(id<MHRequester>)requester
{
    if (self.showsLoadingIndicators) {
        [self hideLoadingIndicator];
        self.needsLoadingIndicatorShown = NO;
    }
    
    if (self.store.isEmpty) {
        [self showEmptyStoreView];
    }
    else {
        [self hideEmptyStoreView];
    }
}

- (void)requester:(id<MHRequester>)requester needsBatchUpdatesPerformed:(void (^)())updates animated:(BOOL)animated
{
    if (self.store) {
        [self.store performBatchUpdates:updates completion:nil animated:animated];
    }
    else {
        updates();
    }
}

- (instancetype)init
{
    if (self = [super init]) {
        [self defaultInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder*)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self defaultInit];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self defaultInit];
    }
    return self;
}

- (void)defaultInit
{
    self.dataSource = [[MHStoreDataSource alloc] init];
    self.storeDelegate = [[MHStoreDelegate alloc] init];
    self.storeDelegate.scrollViewDelegate = self;
    self.store = [MHStore emptyStore];
    
    Class<MHRequester> requesterClass = [self.class requesterClass];
    if (requesterClass) {
        self.requester = [[(id)requesterClass alloc] init];
        self.requester.delegate = self;
        self.requester.dataSource = self;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!self.refreshesOnAppear) {
        [self.requester refresh];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.refreshesOnAppear) {
        [self.requester refresh];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.hasAppeared = YES;
    
    if (self.needsLoadingIndicatorShown) {
        id indicator = [self showLoadingIndicator];
        [self configureLoadingIndicator:indicator];
    }
}

- (void)setStore:(MHStore*)store
{
    _store = store;
    
    _store.delegate = self;
    
    self.dataSource.store = _store;
    self.storeDelegate.store = _store;
}

#pragma mark - Model

- (void)didReset
{
    // By default a reset will just remove everything in the table.
    // Subclasses can override to perform custom reset behavior.
    // Unless needed, subclasses should call [super didReset] to get
    // the default "remove everything" behavior
    [self.store removeAllSections];
}

- (BOOL)animatesRefresh
{
    return YES;
}

- (void)showEmptyStoreView
{
    const NSTimeInterval kAnimationDuration = .5;
    [UIView animateWithDuration:kAnimationDuration
                     animations:^{
                         self.emptyStoreView.alpha = 1.0f;
                     }];
}

- (void)hideEmptyStoreView
{
    self.emptyStoreView.alpha = 0.0f;
}

- (void)configureLoadingIndicator:(id<MHLoadingIndicator>)indicator
{
    // Subclasses can override
}

@end
