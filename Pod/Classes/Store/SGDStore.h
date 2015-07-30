//
//  SGDStore.h
//  Segundo
//
//  Created by Dustin Bachrach on 2/18/14.
//  Copyright (c) 2014 MediaHound. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SGDStore;
@class SGDSection;
@class SGDRow;
@protocol SGDCell;
@protocol SGDStoreResponder;


@interface SGDStore : NSObject

@property (strong, nonatomic, readonly) NSArray* sections;

- (void)performBatchUpdates:(void (^)(void))updates;
- (void)performBatchUpdates:(void (^)(void))updates
                 completion:(void (^)(BOOL finished))completion;
- (void)performBatchUpdates:(void (^)(void))updates
                 completion:(void (^)(BOOL finished))completion
                   animated:(BOOL)animated;
- (void)insertSection:(SGDSection*)section atIndex:(NSUInteger)index;
- (void)appendSections:(NSArray*)newSections;
- (void)deleteSections:(NSIndexSet*)indexSet;
- (void)removeAllSections;

- (SGDSection*)sectionAtIndex:(NSUInteger)index;

- (SGDRow*)rowAtIndexPath:(NSIndexPath*)indexPath;

// TODO: These constructors should be removed
+ (instancetype)simpleStoreWithData:(NSArray*)data cellClass:(Class<SGDCell>)cellClass;

+ (instancetype)simpleStoreWithData:(NSArray*)data cellClasses:(NSArray*)cellClasses;

+ (instancetype)simpleStoreWithData:(NSArray*)data
                        cellClasses:(NSArray*)cellClasses
                    allowsSelection:(BOOL)allowsSelection;

+ (instancetype)storeWithSections:(NSArray*)sections;
// END TODO

+ (instancetype)emptyStore;

@property (strong, nonatomic, readonly) NSSet* allCellClasses;
@property (strong, nonatomic, readonly) NSSet* allHeaderFooterCellClasses;

@property (strong, nonatomic) NSString* tag;

@property (weak, nonatomic) id<SGDStoreResponder> delegate;

@property (nonatomic) BOOL isInEditMode; // TODO: Rename?

@property (nonatomic, readonly) BOOL isEmpty;

@end
