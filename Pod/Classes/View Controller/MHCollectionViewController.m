//
//  MHCollectionViewController.m
//  mediaHound
//
//  Created by Dustin Bachrach on 3/16/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import "MHCollectionViewController.h"
#import "MHStoreViewController+Internal.h"
#import "MHStore.h"
#import "MHSection.h"
#import "MHRow.h"
#import "MHCell.h"
#import "MHStoreDataSource.h"
#import "MHStoreDelegate.h"
#import "MHPagedRequester.h"
#import <KVOController/FBKVOController.h>
#import <KVOController/NSObject+FBKVOController.h>
#import <castaway/castaway.h>


@implementation MHCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionView.dataSource = self.dataSource;
    self.collectionView.delegate = self.storeDelegate;
}

- (void)setStore:(MHStore*)store
{
    [super setStore:store];
    
    for (Class<MHCollectionCell> cellClass in store.allCellClasses) {
        [cellClass registerInCollectionView:self.collectionView];
    }
    
    for (Class<MHCollectionCell> cellClass in store.allHeaderFooterCellClasses) {
        [cellClass registerInCollectionView:self.collectionView];
    }
    
    for (MHSection* section in store.sections) {
        for (MHRow* row in section.rows) {
            [self.KVOController observeOnMainThread:row
                                keyPath:@"cellClass"
                                options:NSKeyValueObservingOptionNew
                                  block:^(id observer, id object, NSDictionary* change) {
                                      [(Class<MHCollectionCell>)row.cellClass registerInCollectionView:self.collectionView];
                                  }];
        }
    }
    
    [self.collectionView reloadData];
}

// TODO: We should make it so that the MHViewController creates a store and sets this as the delegate.
#pragma mark - MHStoreResponder

- (void)storeDidChange:(MHStore*)store
{
    for (Class<MHCollectionCell> cellClass in store.allCellClasses) {
        [cellClass registerInCollectionView:self.collectionView];
    }
    
//    for (MHSection* section in store.sections) {
//        for (MHRow* row in section.rows) {
//            [self.KVOController observe:row
//                                keyPath:@"cellClass"
//                                options:NSKeyValueObservingOptionNew
//                                  block:^(id observer, id object, NSDictionary* change) {
//                                      [(Class<MHCollectionCell>)row.cellClass registerInCollectionView:self.collectionView];
//                                  }];
//        }
//    }
}

- (void)store:(MHStore*)store didInsertSectionAtIndex:(NSUInteger)index
{
    [self.collectionView insertSections:[NSIndexSet indexSetWithIndex:index]];
}

- (void)store:(MHStore*)store didAppendSections:(NSIndexSet*)sections
{
    [self.collectionView insertSections:sections];
}

- (void)store:(MHStore*)store didDeleteSections:(NSIndexSet*)sections
{
    [self.collectionView deleteSections:sections];
}

- (void)store:(MHStore*)store didInsertRows:(NSIndexSet*)indexes inSection:(NSUInteger)sectionIndex
{
    NSMutableArray* indexPaths = [NSMutableArray array];
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL* stop) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:idx inSection:sectionIndex]];
    }];
    [self.collectionView insertItemsAtIndexPaths:indexPaths];
}

- (void)store:(MHStore*)store didDeleteRows:(NSIndexSet*)indexes inSection:(NSUInteger)sectionIndex
{
    NSMutableArray* indexPaths = [NSMutableArray array];
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL* stop) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:idx inSection:sectionIndex]];
    }];
    [self.collectionView deleteItemsAtIndexPaths:indexPaths];
}

- (void)store:(MHStore*)store didUpdateRowAtIndexPath:(NSIndexPath*)indexPath inPlace:(BOOL)inPlace
{
    if (inPlace) {
        id<MHRowCell> cell = (id<MHRowCell>)[self.collectionView cellForItemAtIndexPath:indexPath];
        [cell configureWithData:cell.row.data];
    }
    else {
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
}

- (void)store:(MHStore*)store
    performBatchUpdates:(void (^)(void))updates
   completion:(void (^)(BOOL finished))completion
     animated:(BOOL)animated
{
    void(^block)() = ^{
        [self.collectionView performBatchUpdates:updates completion:completion];
    };
    
    if (animated) {
        block();
    }
    else {
        [UIView performWithoutAnimation:block];
    }
}

- (void)requesterDidFinishRequest:(id<MHRequester>)requester
{
    [super requesterDidFinishRequest:requester];
    
    [(id)requester as:^(MHPagedRequester* pagedRequester) {
        if (pagedRequester.morePagesAvailable && self.collectionView.contentSize.height <= self.collectionView.bounds.size.height) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [pagedRequester refreshNextPage];
            });
        }
    }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    const CGFloat percentage = 0.8f;
    if ((scrollView.contentOffset.y + scrollView.bounds.size.height) / scrollView.contentSize.height >= percentage
        && !self.store.isEmpty) {
        [(id)self.requester as:^(MHPagedRequester* pagedRequester) {
            if (!pagedRequester.isFetchingNewPage && pagedRequester.morePagesAvailable) {
                [pagedRequester refreshNextPage];
            }
        }];
    }
}

- (id)showLoadingIndicator
{
    return [self.class.loadingIndicatorClass showLoadingIndicatorOnView:self.collectionView];
}

- (void)hideLoadingIndicator
{
    [self.class.loadingIndicatorClass hideLoadingIndicatorOnView:self.collectionView];
}

@end
