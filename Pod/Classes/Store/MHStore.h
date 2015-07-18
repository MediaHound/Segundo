//
//  MHStore.h
//  mediaHound
//
//  Created by Dustin Bachrach on 2/18/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MHStore;
@class MHSection;
@class MHRow;
@protocol MHCell;
@protocol MHStoreResponder;


@interface MHStore : NSObject

@property (strong, nonatomic, readonly) NSArray* sections;

- (void)performBatchUpdates:(void (^)(void))updates;
- (void)performBatchUpdates:(void (^)(void))updates
                 completion:(void (^)(BOOL finished))completion;
- (void)performBatchUpdates:(void (^)(void))updates
                 completion:(void (^)(BOOL finished))completion
                   animated:(BOOL)animated;
- (void)insertSection:(MHSection*)section atIndex:(NSUInteger)index;
- (void)appendSections:(NSArray*)newSections;
- (void)deleteSections:(NSIndexSet*)indexSet;
- (void)removeAllSections;

- (MHSection*)sectionAtIndex:(NSUInteger)index;

- (MHRow*)rowAtIndexPath:(NSIndexPath*)indexPath;

// TODO: These constructors should be removed
+ (instancetype)simpleStoreWithData:(NSArray*)data cellClass:(Class<MHCell>)cellClass;

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

@property (weak, nonatomic) id<MHStoreResponder> delegate;

@property (nonatomic) BOOL isInEditMode; // TODO: Rename?

@property (nonatomic, readonly) BOOL isEmpty;

@end
