//
//  MHCell.h
//  mediaHound
//
//  Created by Dustin Bachrach on 2/18/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MHRow;
@class MHHeaderFooter;

/**
 * MHCell is the protocol that all cells in a MHStoreDataSource must conform to.
 * It covers cell identifiers, nibs, sizing, and configuration for Presenters.
 */
@protocol MHCell <NSObject>

@required

/**
 * The cell identifier.
 */
+ (NSString*)cellIdentifier;

/**
 * The nib name that hosts this cell.
 */
+ (NSString*)nibName;

/**
 * The nib that hosts this cell.
 */
+ (UINib*)nib;

- (void)configureWithData:(id)data;

+ (void)preemptivelyLoadResourcesForData:(id)data;

- (void)cancelImmediateResourcesLoad;

- (CGFloat)constrainedWidth;

+ (id)sizingCell;

/**
 * Whether this cell uses dynamic sizing.
 * If a cell has dynamic size, then it must implement -dynamicSize.
 */
+ (BOOL)hasDynamicSize;

/**
 * Whether the cell allows selection.
 */
+ (BOOL)allowsSelection; // TODO: This should also set SelectionType to NONE

/**
 * The zIndex for the cell.
 */
+ (NSInteger)zIndex;

@property (nonatomic) BOOL isInEditMode; // TODO: Rename?

@optional

/**
 * The default size of this cell.
 * This size will be used if `hasDynamicSize` is NO.
 */
+ (CGSize)defaultSize;

+ (instancetype)create;

+ (BOOL)defaultSizeUsesScreenWidth;

+ (BOOL)defaultSizeUsesContainerHeight;

/**
 * The dynamic size of the cell.
 * Cells that have variable sizes, must return YES for `hasDynamicSize` and report
 * cell size in this method.
 */
- (CGSize)dynamicSize;

+ (BOOL)cachesDynamicSize;

+ (NSString*)dynamicSizeCacheKeyForData:(id)data;

- (void)configureForEmpty;

@property (weak, nonatomic) id layoutOwner;

@property (weak, nonatomic) id delegate;

@end


@protocol MHRowCell <MHCell>

/**
 * The row that this cell is displaying.
 */
@property (weak, nonatomic) MHRow* row;

@end


@protocol MHHeaderFooterCell <MHCell>

/**
 * The Header/Footer that this cell is displaying.
 */
@property (weak, nonatomic) MHHeaderFooter* headerFooter;

@end


@protocol MHCollectionCell <NSObject>

@required

+ (void)registerInCollectionView:(UICollectionView*)collectionView;

@end


@protocol MHTableCell <NSObject>

@required

+ (void)registerInTableView:(UITableView*)tableView;

@end


/**
 * A concrete implementation of MHCell for table views.
 * Provides default behavior for most MHCell methods.
 */
@interface MHTableCell : UITableViewCell <MHRowCell, MHTableCell>

@end


/**
 * A concrete implementation of MHCell for collection views.
 * Provides default behavior for most MHCell methods.
 */
@interface MHCollectionCell : UICollectionViewCell <MHRowCell, MHCollectionCell>

@end


@interface MHTableHeaderFooterCell : UITableViewHeaderFooterView <MHHeaderFooterCell, MHTableCell>

@end


@interface MHCollectionHeaderFooterCell : UICollectionReusableView <MHHeaderFooterCell, MHCollectionCell>

@end
