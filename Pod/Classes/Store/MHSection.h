//
//  MHSection.h
//  mediaHound
//
//  Created by Dustin Bachrach on 2/18/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MHCell;

@class MHRow;
@class MHStore;
@class MHHeaderFooter;


@interface MHSection : NSObject

@property (weak, nonatomic, readonly) MHStore* store;
@property (nonatomic, readonly) NSInteger index;

@property (strong, nonatomic, readonly) NSArray* rows;

@property (strong, nonatomic, readonly) MHHeaderFooter* header;
@property (strong, nonatomic, readonly) MHHeaderFooter* footer;

- (MHRow*)rowAtIndex:(NSUInteger)index;

- (void)appendRows:(NSArray*)rows;
- (void)insertRows:(NSArray*)rows atIndexes:(NSIndexSet*)indexes;
- (void)deleteRow:(NSUInteger)index;
- (void)deleteRows:(NSIndexSet*)indexes;

+ (instancetype)emptySection;
+ (instancetype)sectionWithEmptyDataForCellClasses:(NSArray*)cellClasses;
+ (instancetype)sectionWithEmptyDataForCellClasses:(NSArray*)cellClasses
                                            header:(MHHeaderFooter*)header;

+ (instancetype)sectionWithEmptyDataForCellClass:(Class<MHCell>)cellClass
                                           count:(NSUInteger)count;

+ (instancetype)sectionWithData:(NSArray*)data
                      cellClass:(Class<MHCell>)cellClass;

+ (instancetype)sectionWithData:(NSArray*)data
                      cellClass:(Class<MHCell>)cellClass
                         header:(MHHeaderFooter*)header;

+ (instancetype)sectionWithData:(NSArray*)data
                      cellClass:(Class<MHCell>)cellClass
                         header:(MHHeaderFooter*)header
                         footer:(MHHeaderFooter*)footer;

+ (instancetype)sectionWithData:(NSArray*)data cellClasses:(NSArray*)cellClasses;

+ (instancetype)sectionWithData:(NSArray*)data
                    cellClasses:(NSArray*)cellClasses
                allowsSelection:(BOOL)allowsSelection
                         header:(MHHeaderFooter*)header
                        context:(id)context;

+ (instancetype)sectionWithRows:(NSArray*)rows;

+ (instancetype)sectionWithRows:(NSArray*)rows
                         header:(MHHeaderFooter*)header;

+ (instancetype)sectionWithRows:(NSArray*)rows
                         header:(MHHeaderFooter*)header
                         footer:(MHHeaderFooter*)footer;

@property (strong, nonatomic, readonly) NSSet* allCellClasses;

@end
