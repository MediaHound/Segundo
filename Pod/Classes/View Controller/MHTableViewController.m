//
//  MHTableViewController.m
//  mediaHound
//
//  Created by Dustin Bachrach on 4/2/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import "MHTableViewController.h"
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


@implementation MHTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self.storeDelegate;
}

- (void)setStore:(MHStore*)store
{
    [super setStore:store];
    
    for (Class<MHTableCell> cellClass in store.allCellClasses) {
        [cellClass registerInTableView:self.tableView];
    }
    
    // TODO: Do for collection view controller and in the table/collection container cells
    for (Class<MHTableCell> cellClass in store.allHeaderFooterCellClasses) {
        [cellClass registerInTableView:self.tableView];
    }
    
    for (MHSection* section in store.sections) {
        for (MHRow* row in section.rows) {
            [self.KVOController observeOnMainThread:row
                                keyPath:@"cellClass"
                                options:NSKeyValueObservingOptionNew
                                  block:^(id observer, id object, NSDictionary* change) {
                                      [(Class<MHTableCell>)row.cellClass registerInTableView:self.tableView];
                                  }];
        }
    }
    
    [self.tableView reloadData];
}

- (void)storeDidChange:(MHStore*)store
{
    for (Class<MHTableCell> cellClass in store.allCellClasses) {
        [cellClass registerInTableView:self.tableView];
    }
    
    // TODO:
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
    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)store:(MHStore*)store didAppendSections:(NSIndexSet*)sections
{
    [self.tableView insertSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)store:(MHStore*)store didDeleteSections:(NSIndexSet*)sections
{
    [self.tableView deleteSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)store:(MHStore*)store didInsertRows:(NSIndexSet*)indexes inSection:(NSUInteger)sectionIndex
{
    NSMutableArray* indexPaths = [NSMutableArray array];
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL* stop) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:idx inSection:sectionIndex]];
    }];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)store:(MHStore*)store didDeleteRows:(NSIndexSet*)indexes inSection:(NSUInteger)sectionIndex
{
    NSMutableArray* indexPaths = [NSMutableArray array];
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL* stop) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:idx inSection:sectionIndex]];
    }];
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)store:(MHStore*)store didUpdateRowAtIndexPath:(NSIndexPath*)indexPath inPlace:(BOOL)inPlace
{
    // TODO: In place
    if (inPlace) {
        id<MHRowCell> cell = (id<MHRowCell>)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell configureWithData:cell.row.data];
    }
    else {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)store:(MHStore*)store
    performBatchUpdates:(void (^)(void))updates
   completion:(void (^)(BOOL finished))completion
     animated:(BOOL)animated
{
    if (updates) {
        if (!animated) {
            [UIView setAnimationsEnabled:NO];
        }
        
        [self.tableView beginUpdates];
        updates();
        [self.tableView endUpdates];
        
        if (!animated) {
            [UIView setAnimationsEnabled:YES];
        }
    }
    
    if (completion) {
        completion(YES);
    }
}

- (void)requesterDidFinishRequest:(id<MHRequester>)requester
{
    [super requesterDidFinishRequest:requester];
    
    [(id)requester as:^(MHPagedRequester* pagedRequester) {
        if (pagedRequester.morePagesAvailable && self.tableView.contentSize.height <= self.tableView.bounds.size.height) {
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
    return [self.class.loadingIndicatorClass showLoadingIndicatorOnView:self.tableView];
}

- (void)hideLoadingIndicator
{
    [self.class.loadingIndicatorClass hideLoadingIndicatorOnView:self.tableView];
}

@end
