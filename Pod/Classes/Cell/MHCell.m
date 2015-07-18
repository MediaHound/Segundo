//
//  MHCell.m
//  mediaHound
//
//  Created by Dustin Bachrach on 2/18/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import "MHCell.h"
#import <AtSugar/AtSugar.h>
#import <AtSugarMixin/ASMixin.h>

#import <DynamicInvoker/DIDynamicInvoker.h>



#define MHCellMixinSynthesizeProperties isInEditMode, layoutOwner, delegate


@interface MHCellMixin : NSObject <MHCell>

@end


@implementation MHCellMixin

@synthesize_from_mixin (MHCellMixin)

@declare_class_property (defaultSizeUsesScreenWidth, YES)
@declare_class_property (defaultSizeUsesContainerHeight, NO)
@declare_class_property (hasDynamicSize, NO)
@declare_class_property (cachesDynamicSize, NO)
@declare_class_property (allowsSelection, YES)
@declare_class_property (zIndex, 0)

+ (NSString*)cellIdentifier
{
    return NSStringFromClass(self);
}

+ (NSString*)nibName
{
    return NSStringFromClass(self);
}

+ (UINib*)nib
{
    return [UINib nibWithNibName:[self nibName] bundle:nil];
}

+ (instancetype)create
{
    return [[self nib] instantiateWithOwner:nil options:nil][0];
}

+ (id)sizingCell
{
    return [[self nib] instantiateWithOwner:nil options:nil][0];
}

+ (CGSize)defaultSize
{
    static NSMutableDictionary* s_SizeCache = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_SizeCache = [NSMutableDictionary dictionary];
    });
    
    NSString* cellIdentifier = [self cellIdentifier];
    
    if (s_SizeCache[cellIdentifier]) {
        return [s_SizeCache[cellIdentifier] CGSizeValue];
    }
    
    UIView* cellView = [self sizingCell];
    CGSize size = cellView.frame.size;
    
    if ([self defaultSizeUsesScreenWidth]) {
        size.width = [UIScreen mainScreen].bounds.size.width;
    }
    
    s_SizeCache[cellIdentifier] = [NSValue valueWithCGSize:size];
    
    return size;
}

- (void)configureWithData:(id)data
{
    [DIDynamicInvoker dynamicInvokeFormat:@"configureWith%@:" data:data on:self emptySelector:@selector(configureForEmpty)];
}

+ (void)preemptivelyLoadResourcesForData:(id)data
{
    [DIDynamicInvoker dynamicInvokeFormat:@"preemptivelyLoadResourcesFor%@:" data:data on:self];
}

- (void)cancelImmediateResourcesLoad
{
    // Sublcasses can override
}

@end


@implementation MHTableCell

@mixin (MHTableCell, MHCellMixin)

@synthesize row;

+ (void)registerInTableView:(UITableView*)tableView
{
    [tableView registerNib:[self nib] forCellReuseIdentifier:[self cellIdentifier]];
}

@end


@implementation MHCollectionCell

@mixin (MHCollectionCell, MHCellMixin)

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


@implementation MHTableHeaderFooterCell

@mixin (MHTableHeaderFooterCell, MHCellMixin)

@synthesize headerFooter;

+ (void)registerInTableView:(UITableView*)tableView
{
    [tableView registerNib:[self nib] forHeaderFooterViewReuseIdentifier:[self cellIdentifier]];
}

@end


@implementation MHCollectionHeaderFooterCell

@mixin (MHCollectionHeaderFooterCell, MHCellMixin)

@synthesize headerFooter;

+ (void)registerInCollectionView:(UICollectionView*)collectionView
{
    // TODO: footers
    [collectionView registerNib:[self nib]
     forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
            withReuseIdentifier:[self cellIdentifier]];
}

@end
