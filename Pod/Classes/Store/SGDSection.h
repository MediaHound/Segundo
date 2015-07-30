//
//  SGDSection.h
//  Segundo
//
//  Created by Dustin Bachrach on 2/18/14.
//  Copyright (c) 2014 MediaHound. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SGDCell;

@class SGDRow;
@class SGDStore;
@class SGDHeaderFooter;


@interface SGDSection : NSObject

@property (weak, nonatomic, readonly) SGDStore* store;
@property (nonatomic, readonly) NSInteger index;

@property (strong, nonatomic, readonly) NSArray* rows;

@property (strong, nonatomic, readonly) SGDHeaderFooter* header;
@property (strong, nonatomic, readonly) SGDHeaderFooter* footer;

- (SGDRow*)rowAtIndex:(NSUInteger)index;

- (void)appendRows:(NSArray*)rows;
- (void)insertRows:(NSArray*)rows atIndexes:(NSIndexSet*)indexes;
- (void)deleteRow:(NSUInteger)index;
- (void)deleteRows:(NSIndexSet*)indexes;

+ (instancetype)emptySection;
+ (instancetype)sectionWithEmptyDataForCellClasses:(NSArray*)cellClasses;
+ (instancetype)sectionWithEmptyDataForCellClasses:(NSArray*)cellClasses
                                            header:(SGDHeaderFooter*)header;

+ (instancetype)sectionWithEmptyDataForCellClass:(Class<SGDCell>)cellClass
                                           count:(NSUInteger)count;

+ (instancetype)sectionWithData:(NSArray*)data
                      cellClass:(Class<SGDCell>)cellClass;

+ (instancetype)sectionWithData:(NSArray*)data
                      cellClass:(Class<SGDCell>)cellClass
                         header:(SGDHeaderFooter*)header;

+ (instancetype)sectionWithData:(NSArray*)data
                      cellClass:(Class<SGDCell>)cellClass
                         header:(SGDHeaderFooter*)header
                         footer:(SGDHeaderFooter*)footer;

+ (instancetype)sectionWithData:(NSArray*)data cellClasses:(NSArray*)cellClasses;

+ (instancetype)sectionWithData:(NSArray*)data
                    cellClasses:(NSArray*)cellClasses
                allowsSelection:(BOOL)allowsSelection
                         header:(SGDHeaderFooter*)header
                        context:(id)context;

+ (instancetype)sectionWithRows:(NSArray*)rows;

+ (instancetype)sectionWithRows:(NSArray*)rows
                         header:(SGDHeaderFooter*)header;

+ (instancetype)sectionWithRows:(NSArray*)rows
                         header:(SGDHeaderFooter*)header
                         footer:(SGDHeaderFooter*)footer;

@property (strong, nonatomic, readonly) NSSet* allCellClasses;

@end
