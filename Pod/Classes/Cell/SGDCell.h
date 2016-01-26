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

/**
 * Configures the cell with the provided data.
 * You should not need to invoke this method explicitly.
 * It is called automatically by SGDCollectionViews and SGDTableViews.
 * Based on the type of `data`, the appropriate Presenter is invoked.
 */
- (void)configureWithData:(id)data;


+ (void)preemptivelyLoadResourcesForData:(id)data;

- (void)cancelImmediateResourcesLoad;

/**
 * Return an offscreen-rendered cell for sizing purposes.
 */
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

/**
 * Creates a new instance of this cell.
 * Cell XIBs are inferred by name. So a `MyCell.h/m` should have a matching `MyCell.xib`.
 */
+ (instancetype)create;

+ (BOOL)defaultSizeUsesScreenWidth;

+ (BOOL)defaultSizeUsesContainerHeight;

/**
 * The dynamic size of the cell.
 * Cells that have variable sizes, must return YES for `hasDynamicSize` 
 * and return the cell size in this method.
 */
- (CGSize)dynamicSize;

/**
 * Whether caching should be used for calls to dynamicSize.
 * If YES, then `+dynamicSizeCacheKeyForData:` is invoked to determine the cache key.
 * Default is NO.
 */
+ (BOOL)cachesDynamicSize;

/**
 * When cachesDynamicSize returns YES, this method is invoked to determine a cache key.
 * For cells that layout at different sizes based on the cell's row's data,
 * a cache key can be useful.
 */
+ (NSString*)dynamicSizeCacheKeyForData:(id)data;

/**
 * If the cell's row's data is NSNull, then this method is invoked.
 * If you allow emptyness in your cell, you should implement this method.
 * Rather than having a Presenter for NSNull, Segundo uses a consistent
 * concept of "emptyness'.
 */
- (void)configureForEmpty;

@property (weak, nonatomic) id layoutOwner;

/**
 * The cell's delegate. 
 * The cell's delegate is set to be the delegate of the Store
 * the cell is contained in.
 */
@property (weak, nonatomic) id delegate;

@end


/**
 * An SGDRowCell extend SGDCell and adds a `row` property.
 */
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


/**
 * To conform to the SGDCollectionCell protocol, a cell must be able
 * to be registered in a collection view.
 */
@protocol SGDCollectionCell <NSObject>

@required

/**
 * Registers this cell into the provided collection view.
 * @param collectionView The collection view to register this cell inside of
 */
+ (void)registerInCollectionView:(UICollectionView*)collectionView;

@end


/**
 * To conform to the SGDCollectionCell protocol, a cell must be able
 * to be registered in a table view.
 */
@protocol SGDTableCell <NSObject>

@required

/**
 * Registers this cell into the provided table view.
 * @param tableView The table view to register this cell inside of
 */
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

- (CGFloat)constrainedWidth;

@end

/**
 * A concrete implementation of SGDHeaderFooterCell for table views.
 * Provides default behavior for most SGDCell methods.
 */
@interface SGDTableHeaderFooterCell : UITableViewHeaderFooterView <SGDHeaderFooterCell, SGDTableCell>

@end


/**
 * A concrete implementation of SGDHeaderFooterCell for collection views.
 * Provides default behavior for most SGDCell methods.
 */
@interface SGDCollectionHeaderFooterCell : UICollectionReusableView <SGDHeaderFooterCell, SGDCollectionCell>

@end
