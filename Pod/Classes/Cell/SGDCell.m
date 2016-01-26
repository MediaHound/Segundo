//
//  SGDCell.m
//  Segundo
//
//  Created by Dustin Bachrach on 2/18/14.
//  Copyright (c) 2014 MediaHound. All rights reserved.
//

#import "SGDCell.h"
#import <AtSugar/AtSugar.h>

#import <DynamicInvoker/DIDynamicInvoker.h>


/**
 * This is a poor-man's mixin.
 */
#define SGDCellMixin \
@synthesize isInEditMode; \
+ (BOOL)defaultSizeUsesScreenWidth { return YES; } \
+ (BOOL)defaultSizeUsesContainerHeight { return NO; } \
+ (BOOL)cachesDynamicSize { return NO; } \
+ (BOOL)allowsSelection { return YES; } \
+ (NSInteger)zIndex { return 0; } \
 \
+ (BOOL)hasDynamicSize { return NO; } \
 \
+ (NSString*)cellIdentifier \
{ \
    return NSStringFromClass(self); \
} \
 \
+ (NSString*)nibName \
{ \
    return NSStringFromClass(self); \
} \
 \
+ (UINib*)nib \
{ \
    return [UINib nibWithNibName:[self nibName] bundle:nil]; \
} \
 \
+ (instancetype)create \
{ \
    return [[self nib] instantiateWithOwner:nil options:nil][0]; \
} \
 \
+ (id)sizingCell \
{ \
    return [[self nib] instantiateWithOwner:nil options:nil][0]; \
} \
 \
+ (CGSize)defaultSize \
{ \
    static NSMutableDictionary* s_SizeCache = nil; \
     \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        s_SizeCache = [NSMutableDictionary dictionary]; \
    }); \
     \
    NSString* cellIdentifier = [self cellIdentifier]; \
     \
    if (s_SizeCache[cellIdentifier]) { \
        return [s_SizeCache[cellIdentifier] CGSizeValue]; \
    } \
     \
    UIView* cellView = [self sizingCell]; \
    CGSize size = cellView.frame.size; \
     \
    if ([self defaultSizeUsesScreenWidth]) { \
        size.width = [UIScreen mainScreen].bounds.size.width; \
    } \
     \
    s_SizeCache[cellIdentifier] = [NSValue valueWithCGSize:size]; \
     \
    return size; \
} \
 \
- (void)configureWithData:(id)data \
{ \
    [self dynamicInvokeFormat:@"configureWith%@:" data:data emptySelector:@selector(configureForEmpty)]; \
} \
 \
+ (void)preemptivelyLoadResourcesForData:(id)data \
{ \
    [self dynamicInvokeFormat:@"preemptivelyLoadResourcesFor%@:" data:data]; \
} \
 \
- (void)cancelImmediateResourcesLoad \
{ \
    /* Sublcasses can override */ \
}


@implementation SGDTableCell

SGDCellMixin

@synthesize row;

+ (void)registerInTableView:(UITableView*)tableView
{
    [tableView registerNib:[self nib] forCellReuseIdentifier:[self cellIdentifier]];
}

@end


@implementation SGDCollectionCell

SGDCellMixin

@synthesize row;

+ (void)registerInCollectionView:(UICollectionView*)collectionView
{
    [collectionView registerNib:[self nib] forCellWithReuseIdentifier:[self cellIdentifier]];
}

- (CGFloat)constrainedWidth
{
    if ([self.layoutOwner isKindOfClass:UICollectionViewLayout.class]) {
        return [self.layoutOwner itemWidth];
    }
    return CGFLOAT_MAX;
}

@end


@implementation SGDTableHeaderFooterCell

SGDCellMixin

@synthesize headerFooter;

+ (void)registerInTableView:(UITableView*)tableView
{
    [tableView registerNib:[self nib] forHeaderFooterViewReuseIdentifier:[self cellIdentifier]];
}

@end


@implementation SGDCollectionHeaderFooterCell

SGDCellMixin

@synthesize headerFooter;

+ (void)registerInCollectionView:(UICollectionView*)collectionView
{
    // TODO: footers
    [collectionView registerNib:[self nib]
     forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
            withReuseIdentifier:[self cellIdentifier]];
}

@end
