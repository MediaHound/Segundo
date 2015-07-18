//
//  MHArrayDataSource.m
//  mediaHound
//
//  Created by Dustin Bachrach on 2/18/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import "MHStoreDataSource.h"
#import "MHStore.h"
#import "MHStoreResponder.h"
#import "MHSection.h"
#import "MHRow.h"
#import "MHCell.h"
#import "MHHeaderFooter.h"


@implementation MHStoreDataSource

#pragma mark - Shared Data Source

// TODO: Mostly Duplicated with MHStoreDelegate
- (id<MHHeaderFooterCell>)headerViewForSection:(NSInteger)sectionIndex kind:(NSString*)kind view:(id)view
{
    MHSection* section = [self.store sectionAtIndex:sectionIndex];
    MHHeaderFooter* headerFooter = section.header;
    
    if (!headerFooter) {
        return [[UICollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    }
    
    id<MHHeaderFooterCell> headerFooterCell = nil;
    
    if ([view isKindOfClass:[UITableView class]]) {
        headerFooterCell = [(UITableView*)view dequeueReusableHeaderFooterViewWithIdentifier:[headerFooter.cellClass cellIdentifier]];
    }
    else if ([view isKindOfClass:[UICollectionView class]]) {
        headerFooterCell = [(UICollectionView*)view dequeueReusableSupplementaryViewOfKind:kind
                                                                       withReuseIdentifier:[headerFooter.cellClass cellIdentifier]
                                                                              forIndexPath:[NSIndexPath indexPathForRow:0 inSection:sectionIndex]];
    }
    
    if (headerFooterCell) {
        headerFooterCell.headerFooter = headerFooter;
        
        if ([headerFooterCell respondsToSelector:@selector(setDelegate:)]) {
            headerFooterCell.delegate = self.store.delegate;
        }
        
        // Default configuration
        
        //            // TODO: Yuck.
        //            if ([cell respondsToSelector:@selector(setCellHeight:)]) {
        //                if (![cell.class hasDynamicSize]) {
        //                    const CGFloat height = [cell.class defaultSize].height;
        //                    [(id)cell setCellHeight:height];
        //                }
        //                // TODO: what about dynamic heights?
        //            }
        //
        [headerFooterCell configureWithData:headerFooter.data];
    }
    
    return headerFooterCell;
}

- (NSInteger)numberOfSections
{
    return self.store.sections.count;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)sectionIndex
{
    MHSection* section = [self.store sectionAtIndex:sectionIndex];
    return section.rows.count;
}

- (id<MHRowCell>)cellAtIndexPath:(NSIndexPath*)indexPath view:(id)view
{
    MHRow* row = [self.store rowAtIndexPath:indexPath];
    
    id<MHRowCell> cell = nil;
    
    NSString* identifier = [row.cellClass cellIdentifier];
    
    if ([view isKindOfClass:[UITableView class]]) {
        cell = [(UITableView*)view dequeueReusableCellWithIdentifier:identifier
                                                        forIndexPath:indexPath];
    }
    else if ([view isKindOfClass:[UICollectionView class]]) {
        cell = [(UICollectionView*)view dequeueReusableCellWithReuseIdentifier:identifier
                                                                  forIndexPath:indexPath];
    }
    
    if (cell) {
        if ([view isKindOfClass:UICollectionView.class] && [cell isKindOfClass:MHCollectionCell.class]) {
            cell.layoutOwner = ((UICollectionView*)view).collectionViewLayout;
        }
        cell.row = row;
        cell.isInEditMode = self.store.isInEditMode;
        
        if ([cell respondsToSelector:@selector(setDelegate:)]) {
            cell.delegate = self.store.delegate;
        }
        
        [cell configureWithData:row.data];
    }
    
    return cell;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return [self numberOfSections];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return [self numberOfRowsInSection:sectionIndex];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return (UITableViewCell*)[self cellAtIndexPath:indexPath view:tableView];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView
{
    return [self numberOfSections];
}

- (NSInteger)collectionView:(UICollectionView*)collectionView
     numberOfItemsInSection:(NSInteger)sectionIndex
{
    return [self numberOfRowsInSection:sectionIndex];
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView
                  cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    MHCollectionCell* cell = (MHCollectionCell*)[self cellAtIndexPath:indexPath view:collectionView];
    
    if ([self.store.delegate respondsToSelector:@selector(willDisplayCell:)]) {
        [self.store.delegate willDisplayCell:cell];
    }
    
    return cell;
}

- (UICollectionReusableView*)collectionView:(UICollectionView*)collectionView viewForSupplementaryElementOfKind:(NSString*)kind atIndexPath:(NSIndexPath*)indexPath;
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        return (UICollectionReusableView*)[self headerViewForSection:indexPath.section kind:kind view:collectionView];
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        // TODO: Collection Footers
    }
    
    return nil;
}

@end
