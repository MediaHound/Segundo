//
//  SGDCollectionViewController.m
//  Segundo
//
//  Created by Dustin Bachrach on 3/16/14.
//  Copyright (c) 2014 MediaHound. All rights reserved.
//

#import "SGDCollectionViewController.h"
#import "SGDStoreViewController+Internal.h"
#import "SGDStore.h"
#import "SGDSection.h"
#import "SGDRow.h"
#import "SGDCell.h"
#import "SGDStoreDataSource.h"
#import "SGDStoreDelegate.h"
#import "SGDPagedRequester.h"
#import "FBKVOController+StillValid.h"

#import <AtSugar/AtSugar.h>
#import <KVOController/FBKVOController.h>
#import <castaway/castaway.h>


@implementation SGDCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.isVertical = YES;
    self.isHorizontal = NO;
    
    self.collectionView.dataSource = self.dataSource;
    self.collectionView.delegate = self.storeDelegate;
}

- (void)setStore:(SGDStore*)store
{
    [super setStore:store];
    
    for (Class<SGDCollectionCell> cellClass in store.allCellClasses) {
        [cellClass registerInCollectionView:self.collectionView];
    }
    
    for (Class<SGDCollectionCell> cellClass in store.allHeaderFooterCellClasses) {
        [cellClass registerInCollectionView:self.collectionView];
    }
    
    @weakSelf()
    
    for (SGDSection* section in store.sections) {
        for (SGDRow* row in section.rows) {
            [self.KVOController observeOnMainThread:row
                                            keyPath:@"cellClass"
                                            options:NSKeyValueObservingOptionNew
                                              block:^(id observer, id object, NSDictionary* change) {
                                                  [(Class<SGDCollectionCell>)row.cellClass registerInCollectionView:weakSelf.collectionView];
                                              }
                                         stillValid:^BOOL{
                                             return YES;
                                         }];
        }
    }
    
    [self.collectionView reloadData];
}

// TODO: We should make it so that the SGDViewController creates a store and sets this as the delegate.
#pragma mark - SGDStoreResponder

- (void)storeDidChange:(SGDStore*)store
{
    for (Class<SGDCollectionCell> cellClass in store.allCellClasses) {
        [cellClass registerInCollectionView:self.collectionView];
    }
    
    //    for (SGDSection* section in store.sections) {
    //        for (SGDRow* row in section.rows) {
    //            [self.KVOController observe:row
    //                                keyPath:@"cellClass"
    //                                options:NSKeyValueObservingOptionNew
    //                                  block:^(id observer, id object, NSDictionary* change) {
    //                                      [(Class<SGDCollectionCell>)row.cellClass registerInCollectionView:self.collectionView];
    //                                  }];
    //        }
    //    }
}

- (void)store:(SGDStore*)store didInsertSectionAtIndex:(NSUInteger)index
{
    [self.collectionView insertSections:[NSIndexSet indexSetWithIndex:index]];
}

- (void)store:(SGDStore*)store didAppendSections:(NSIndexSet*)sections
{
    [self.collectionView insertSections:sections];
}

- (void)store:(SGDStore*)store didDeleteSections:(NSIndexSet*)sections
{
    [self.collectionView deleteSections:sections];
}

- (void)store:(SGDStore*)store didInsertRows:(NSIndexSet*)indexes inSection:(NSUInteger)sectionIndex
{
    NSMutableArray* indexPaths = [NSMutableArray array];
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL* stop) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:idx inSection:sectionIndex]];
    }];
    [self.collectionView insertItemsAtIndexPaths:indexPaths];
}

- (void)store:(SGDStore*)store didDeleteRows:(NSIndexSet*)indexes inSection:(NSUInteger)sectionIndex
{
    NSMutableArray* indexPaths = [NSMutableArray array];
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL* stop) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:idx inSection:sectionIndex]];
    }];
    [self.collectionView deleteItemsAtIndexPaths:indexPaths];
}

- (void)store:(SGDStore*)store didUpdateRowAtIndexPath:(NSIndexPath*)indexPath inPlace:(BOOL)inPlace
{
    if (inPlace) {
        id<SGDRowCell> cell = (id<SGDRowCell>)[self.collectionView cellForItemAtIndexPath:indexPath];
        [cell configureWithData:cell.row.data];
    }
    else {
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
}

- (void)store:(SGDStore*)store
performBatchUpdates:(void (^)(void))updates
   completion:(void (^)(BOOL finished))completion
     animated:(BOOL)animated
{
    void(^block)() = ^{
        if (!self.collectionView) {
            NSLog(@"[Segundo] Warning: performing batch updates on a SGDCollectionViewController, which does not have a collectionView.");
        }
        [self.collectionView performBatchUpdates:updates completion:completion];
    };
    
    if (animated) {
        block();
    }
    else {
        [UIView performWithoutAnimation:block];
    }
}

- (void)requesterDidFinishRequest:(id<SGDRequester>)requester
{
    [super requesterDidFinishRequest:requester];
    
    [(id)requester as:^(SGDPagedRequester* pagedRequester) {
        if (pagedRequester.morePagesAvailable
            &&
            (
             (self.isVertical && (self.collectionView.contentSize.height - self.autoloadFuzzySize) <= self.collectionView.bounds.size.height)
             ||
             (self.isHorizontal && (self.collectionView.contentSize.width - self.autoloadFuzzySize) <= self.collectionView.bounds.size.width)
             )) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [pagedRequester refreshNextPage];
                });
            }
    }];
    
#if TARGET_OS_TV
    [self.collectionView setNeedsFocusUpdate];
#endif
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    const CGFloat percentage = 0.8f;
    if (!self.store.isEmpty
        &&
        (
         (self.isVertical && ((scrollView.contentOffset.y + scrollView.bounds.size.height) / scrollView.contentSize.height >= percentage))
         ||
         (self.isHorizontal && ((scrollView.contentOffset.x + scrollView.bounds.size.width) / scrollView.contentSize.width >= percentage))
         )) {
            [(id)self.requester as:^(SGDPagedRequester* pagedRequester) {
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
