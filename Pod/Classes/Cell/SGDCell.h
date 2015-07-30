//
//  SGDCell.h
//  Segundo
//
//  Created by Dustin Bachrach on 2/18/14.
//  Copyright (c) 2014 MediaHound. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SGDRow;
@class SGDHeaderFooter;

/**
 * SGDCell is the protocol that all cells in a SGDStoreDataSource must conform to.
 * It covers cell identifiers, nibs, sizing, and configuration for Presenters.
 */
@protocol SGDCell <NSObject>

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


@protocol SGDRowCell <SGDCell>

/**
 * The row that this cell is displaying.
 */
@property (weak, nonatomic) SGDRow* row;

@end


@protocol SGDHeaderFooterCell <SGDCell>

/**
 * The Header/Footer that this cell is displaying.
 */
@property (weak, nonatomic) SGDHeaderFooter* headerFooter;

@end


@protocol SGDCollectionCell <NSObject>

@required

+ (void)registerInCollectionView:(UICollectionView*)collectionView;

@end


@protocol SGDTableCell <NSObject>

@required

+ (void)registerInTableView:(UITableView*)tableView;

@end


/**
 * A concrete implementation of SGDCell for table views.
 * Provides default behavior for most SGDCell methods.
 */
@interface SGDTableCell : UITableViewCell <SGDRowCell, SGDTableCell>

@end


/**
 * A concrete implementation of SGDCell for collection views.
 * Provides default behavior for most SGDCell methods.
 */
@interface SGDCollectionCell : UICollectionViewCell <SGDRowCell, SGDCollectionCell>

@end


@interface SGDTableHeaderFooterCell : UITableViewHeaderFooterView <SGDHeaderFooterCell, SGDTableCell>

@end


@interface SGDCollectionHeaderFooterCell : UICollectionReusableView <SGDHeaderFooterCell, SGDCollectionCell>

@end
