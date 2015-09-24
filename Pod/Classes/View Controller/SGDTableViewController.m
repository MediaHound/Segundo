//
//  SGDTableViewController.m
//  Segundo
//
//  Created by Dustin Bachrach on 4/2/14.
//  Copyright (c) 2014 MediaHound. All rights reserved.
//

#import "SGDTableViewController.h"
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


@implementation SGDTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self.storeDelegate;
}

- (void)setStore:(SGDStore*)store
{
    [super setStore:store];
    
    for (Class<SGDTableCell> cellClass in store.allCellClasses) {
        [cellClass registerInTableView:self.tableView];
    }
    
    // TODO: Do for collection view controller and in the table/collection container cells
    for (Class<SGDTableCell> cellClass in store.allHeaderFooterCellClasses) {
        [cellClass registerInTableView:self.tableView];
    }
    
    @weakSelf()
    for (SGDSection* section in store.sections) {
        for (SGDRow* row in section.rows) {
            [self.KVOController observeOnMainThread:row
                                keyPath:@"cellClass"
                                options:NSKeyValueObservingOptionNew
                                  block:^(id observer, id object, NSDictionary* change) {
                                      [(Class<SGDTableCell>)row.cellClass registerInTableView:weakSelf.tableView];
                                  }
                             stillValid:^BOOL{
                                 return YES;
                             }];
        }
    }
    
    [self.tableView reloadData];
}

- (void)storeDidChange:(SGDStore*)store
{
    for (Class<SGDTableCell> cellClass in store.allCellClasses) {
        [cellClass registerInTableView:self.tableView];
    }
    
    // TODO:
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
    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:index]
                  withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)store:(SGDStore*)store didAppendSections:(NSIndexSet*)sections
{
    [self.tableView insertSections:sections
                  withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)store:(SGDStore*)store didDeleteSections:(NSIndexSet*)sections
{
    [self.tableView deleteSections:sections
                  withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)store:(SGDStore*)store didInsertRows:(NSIndexSet*)indexes inSection:(NSUInteger)sectionIndex
{
    NSMutableArray* indexPaths = [NSMutableArray array];
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL* stop) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:idx
                                                 inSection:sectionIndex]];
    }];
    [self.tableView insertRowsAtIndexPaths:indexPaths
                          withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)store:(SGDStore*)store didDeleteRows:(NSIndexSet*)indexes inSection:(NSUInteger)sectionIndex
{
    NSMutableArray* indexPaths = [NSMutableArray array];
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL* stop) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:idx
                                                 inSection:sectionIndex]];
    }];
    [self.tableView deleteRowsAtIndexPaths:indexPaths
                          withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)store:(SGDStore*)store didUpdateRowAtIndexPath:(NSIndexPath*)indexPath inPlace:(BOOL)inPlace
{
    // TODO: In place
    if (inPlace) {
        id<SGDRowCell> cell = (id<SGDRowCell>)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell configureWithData:cell.row.data];
    }
    else {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)store:(SGDStore*)store
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

- (void)requesterDidFinishRequest:(id<SGDRequester>)requester
{
    [super requesterDidFinishRequest:requester];
    
    [(id)requester as:^(SGDPagedRequester* pagedRequester) {
        if (pagedRequester.morePagesAvailable && self.tableView.contentSize.height <= self.tableView.bounds.size.height) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [pagedRequester refreshNextPage];
            });
        }
    }];

#if TARGET_OS_TV
    [self.tableView setNeedsFocusUpdate];
#endif

}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    const CGFloat percentage = 0.8f;
    if ((scrollView.contentOffset.y + scrollView.bounds.size.height) / scrollView.contentSize.height >= percentage
        && !self.store.isEmpty) {
        [(id)self.requester as:^(SGDPagedRequester* pagedRequester) {
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
