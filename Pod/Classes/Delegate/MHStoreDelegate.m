//
//  MHStoreDelegate.m
//  mediaHound
//
//  Created by Dustin Bachrach on 3/14/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import "MHStoreDelegate.h"
#import "MHStore.h"
#import "MHStoreResponder.h"
#import "MHSection.h"
#import "MHRow.h"
#import "MHCell.h"
#import "MHHeaderFooter.h"
#import <AgnosticLogger/AgnosticLogger.h>
#import <DynamicInvoker/DIDynamicInvoker.h>

NSString* const MHStoreContextColumnCountKey = @"columnCount";


@implementation MHStoreDelegate

#pragma mark - Shared Delegate

- (void)didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    MHRow* row = [self.store rowAtIndexPath:indexPath];
    Class rowClass = row.cellClass;
    id delegate = self.store.delegate;

    if ([DIDynamicInvoker dynamicInvokeFormat:@"didSelect%@Row:" data:row base:rowClass on:delegate]) {
        return;
    }
    
    if ([delegate respondsToSelector:@selector(didSelectRow:)]) {
        [delegate didSelectRow:row];
        return;
    }
    
    AGLLogWarn(@"No -didSelectRow: method found on delegate: %@.", delegate);
}

- (BOOL)shouldSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    MHRow* row = [self.store rowAtIndexPath:indexPath];
    
    BOOL storeWideSelectionAllowed = YES;
    if ([self.store.delegate respondsToSelector:@selector(storeShouldAllowSelection:)]) {
        storeWideSelectionAllowed = [self.store.delegate storeShouldAllowSelection:self.store];
    }
    
    return row.allowsSelection && storeWideSelectionAllowed;
}

- (CGSize)sizeForHeaderAtSectionIndex:(NSInteger)sectionIndex
{
    MHHeaderFooter* header = [self.store sectionAtIndex:sectionIndex].header;
    
    CGSize size = CGSizeZero;
    if (header) {
        size = [header.cellClass defaultSize];
    }
    // TODO: Support dynamic headers
    return size;
}

- (CGSize)sizeForRowAtIndexPath:(NSIndexPath*)indexPath view:(UIView*)view
{
    
    MHRow* row = [self.store rowAtIndexPath:indexPath];
    
    CGSize size = CGSizeZero;
    if ([row.cellClass hasDynamicSize]) {
        
        // TODO: Should probably use NSCache instead of NSDictionary
        static NSMutableDictionary* dynamicSizeCache = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            dynamicSizeCache = [NSMutableDictionary dictionary];
        });
        
        const BOOL cachesDynamicSize = ([(id)row.cellClass respondsToSelector:@selector(cachesDynamicSize)] && [row.cellClass cachesDynamicSize]);
        
        NSString* cacheKey = nil;
        
        if (cachesDynamicSize) {
            NSString* rowDataHash = nil;
            if ([(id)row.cellClass respondsToSelector:@selector(dynamicSizeCacheKeyForData:)]) {
                rowDataHash = [row.cellClass dynamicSizeCacheKeyForData:row.data];
            }
            else {
                rowDataHash = @([row.data hash]).stringValue;
            }
            
            NSString* constrainedWidth = @"none";
            if ([view isKindOfClass:UICollectionView.class]) {
                UICollectionViewLayout* layoutOwner = ((UICollectionView*)view).collectionViewLayout;
                if ([layoutOwner respondsToSelector:@selector(itemWidth)]) {
                    constrainedWidth = @([(id)layoutOwner itemWidth]).stringValue;
                }
            }
            
            cacheKey = [NSString stringWithFormat:@"%@:%@:%@", NSStringFromClass(row.cellClass), rowDataHash, constrainedWidth];
            
            id cacheValue = dynamicSizeCache[cacheKey];
            if (cacheValue) {
//                NSLog(@"using dynamic size from cache for %@", cacheKey);
                size = [cacheValue CGSizeValue];
            }
        }
        if (CGSizeEqualToSize(size, CGSizeZero)) {
            AGLLogInfo(@"sizing dynamic cell %@", row.cellClass);
            id<MHCell> sizingCell = [row.cellClass sizingCell];
            if ([sizingCell conformsToProtocol:@protocol(MHRowCell)]) {
                ((id<MHRowCell>)sizingCell).row = row;
            }
            [sizingCell configureWithData:row.data];
            
            if ([view isKindOfClass:UICollectionView.class] && [sizingCell isKindOfClass:MHCollectionCell.class]) {
                sizingCell.layoutOwner = ((UICollectionView*)view).collectionViewLayout;
            }
            
            size = [sizingCell dynamicSize];
            
            
            if (cachesDynamicSize) {
                dynamicSizeCache[cacheKey] = [NSValue valueWithCGSize:size];
            }
        }
    }
    else {
        size = [row.cellClass defaultSize];
        
        if ([row.cellClass defaultSizeUsesContainerHeight]) {
            size.height = view.bounds.size.height;
        }
    }
    
    return size;
}

- (id<MHHeaderFooterCell>)headerViewForSection:(NSInteger)sectionIndex view:(id)view
{
    MHSection* section = [self.store sectionAtIndex:sectionIndex];
    MHHeaderFooter* headerFooter = section.header;
    
    id<MHHeaderFooterCell> headerFooterCell = nil;
    
    if ([view isKindOfClass:[UITableView class]]) {
        headerFooterCell = [(UITableView*)view dequeueReusableHeaderFooterViewWithIdentifier:[headerFooter.cellClass cellIdentifier]];
    }
    else if ([view isKindOfClass:[UICollectionView class]]) {
        headerFooterCell = [(UICollectionView*)view dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                       withReuseIdentifier:[headerFooter.cellClass cellIdentifier]
                                                                              forIndexPath:[NSIndexPath indexPathForRow:0 inSection:sectionIndex]];
    }
    
    if (headerFooterCell) {
        headerFooterCell.headerFooter = headerFooter;
        
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

- (void)endDisplayCell:(id<MHCell>)cell
{
    [cell cancelImmediateResourcesLoad];
    if ([self.store.delegate respondsToSelector:@selector(willEndDisplayCell:)]) {
        [self.store.delegate willEndDisplayCell:(id<MHCell>)cell];
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return [self sizeForRowAtIndexPath:indexPath view:tableView].height;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    MHSection* sec = [self.store sectionAtIndex:section];
    if (sec.header) {
        // TODO:
        return 40;
    }
    else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    // TODO:
    return 0;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [self didSelectRowAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSIndexPath*)tableView:(UITableView*)tableView willSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    return ([self shouldSelectRowAtIndexPath:indexPath]) ? indexPath : nil;
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    return (UIView*)[self headerViewForSection:section view:tableView];
}

- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    // TODO:
    return nil;
}

- (void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if ([self.store.delegate respondsToSelector:@selector(willDisplayCell:)]) {
        [self.store.delegate willDisplayCell:(id<MHCell>)cell];
    }
}

- (void)tableView:(UITableView*)tableView didEndDisplayingCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    [self endDisplayCell:(id<MHCell>)cell];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    [self didSelectRowAtIndexPath:indexPath];
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (BOOL)collectionView:(UICollectionView*)collectionView shouldSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    return ([self shouldSelectRowAtIndexPath:indexPath]);
}

- (void)collectionView:(UICollectionView*)collectionView didEndDisplayingCell:(UICollectionViewCell*)cell forItemAtIndexPath:(NSIndexPath*)indexPath
{
    [self endDisplayCell:(id<MHCell>)cell];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath
{
    return [self sizeForRowAtIndexPath:indexPath view:collectionView];
}

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
{
    return [self sizeForHeaderAtSectionIndex:section];
}

// TODO: This should be in a subclass of MHStoreDelegate because its behavior is specific to waterfall layouts
- (NSInteger)collectionView:(UICollectionView*)collectionView
                     layout:(UICollectionViewLayout*)collectionViewLayout
columnCountForItemAtIndexPath:(NSIndexPath*)indexPath
{
    MHRow* row = [self.store rowAtIndexPath:indexPath];
    NSNumber* columnCount = row.context[MHStoreContextColumnCountKey];
    if (!columnCount) {
        columnCount = @1;
    }
    return columnCount.integerValue;
}

// TODO: The rest of the scroll view protocol needs to be added
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.scrollViewDelegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.scrollViewDelegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidScrollToTop:(UIScrollView*)scrollView
{
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidScrollToTop:)]) {
        [self.scrollViewDelegate scrollViewDidScrollToTop:scrollView];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView*)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint*)targetContentOffset
{
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
        [self.scrollViewDelegate scrollViewWillEndDragging:scrollView
                                              withVelocity:velocity
                                       targetContentOffset:targetContentOffset];
    }
}
//
//- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout heightForHeaderInSection:(NSInteger)section
//{
//    return [self sizeForHeaderAtSectionIndex:section].height;
//}

@end
