//
//  SGDSection.m
//  Segundo
//
//  Created by Dustin Bachrach on 2/18/14.
//  Copyright (c) 2014 MediaHound. All rights reserved.
//

#import "SGDSection.h"
#import "SGDStore.h"
#import "SGDStoreResponder.h"
#import "SGDRow.h"
#import "SGDRow+Internal.h"
#import "SGDHeaderFooter+Internal.h"


@interface SGDSection ()

@property (strong, nonatomic) NSMutableArray* mutableRows;
@property (strong, nonatomic, readwrite) SGDHeaderFooter* header;
@property (strong, nonatomic, readwrite) SGDHeaderFooter* footer;

// From SGDSection+Internal
@property (weak, nonatomic, readwrite) SGDStore* store;
@property (nonatomic, readwrite) NSInteger index;

@end


@implementation SGDSection

- (void)updateRowPointers
{
    NSInteger i = 0;
    
    for (SGDRow* row in self.mutableRows) {
        row.section = self;
        row.index = i;
        i++;
    }
}

- (NSArray*)rows
{
    return self.mutableRows;
}

- (void)appendRows:(NSArray*)rows
{
    [self insertRows:rows
           atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.rows.count, rows.count)]];
}

- (void)insertRows:(NSArray*)rows atIndexes:(NSIndexSet*)indexes
{
    [self.mutableRows insertObjects:rows atIndexes:indexes];
    [self updateRowPointers];
    
    // TODO: Figure out a better way to do storeDidChange
    if ([self.store.delegate respondsToSelector:@selector(storeDidChange:)]) {
        [self.store.delegate storeDidChange:self.store];
    }
    
    if ([self.store.delegate respondsToSelector:@selector(store:didInsertRows:inSection:)]) {
        [self.store.delegate store:self.store didInsertRows:indexes inSection:self.index];
    }
}

- (void)deleteRow:(NSUInteger)index
{
    [self deleteRows:[NSIndexSet indexSetWithIndex:index]];
}

- (void)deleteRows:(NSIndexSet*)indexes
{
    [self.mutableRows removeObjectsAtIndexes:indexes];
    [self updateRowPointers];
    
    // TODO: Figure out a better way to do storeDidChange
    if ([self.store.delegate respondsToSelector:@selector(storeDidChange:)]) {
        [self.store.delegate storeDidChange:self.store];
    }
    
    if ([self.store.delegate respondsToSelector:@selector(store:didDeleteRows:inSection:)]) {
        [self.store.delegate store:self.store didDeleteRows:indexes inSection:self.index];
    }
}

- (void)setHeader:(SGDHeaderFooter*)header
{
    _header = header;
    
    _header.section = self;
}

- (SGDRow*)rowAtIndex:(NSUInteger)index
{
    SGDRow* row = nil;
    
    if (index < self.rows.count) {
        row = self.rows[index];
    }
    return row;
}

+ (instancetype)emptySection
{
    return [self sectionWithRows:@[]];
}

+ (instancetype)sectionWithEmptyDataForCellClass:(Class<SGDCell>)cellClass
                                           count:(NSUInteger)count
{
    NSMutableArray* emptyData = [NSMutableArray array];
    for (NSUInteger i = 0; i < count; i++) {
        [emptyData addObject:[NSNull null]];
    }
    return [self sectionWithData:emptyData cellClass:cellClass];
}

+ (instancetype)sectionWithData:(NSArray*)data
                      cellClass:(Class<SGDCell>)cellClass
{
    return [self sectionWithData:data
                       cellClass:cellClass
                          header:nil];
}

+ (instancetype)sectionWithData:(NSArray*)data
                      cellClass:(Class<SGDCell>)cellClass
                         header:(SGDHeaderFooter*)header
{
    return [self sectionWithData:data
                       cellClass:cellClass
                          header:header
                          footer:nil];
}

+ (instancetype)sectionWithData:(NSArray*)data
                      cellClass:(Class<SGDCell>)cellClass
                         header:(SGDHeaderFooter*)header
                         footer:(SGDHeaderFooter*)footer
{
    NSMutableArray* rows = [NSMutableArray array];
    
    for (id element in data) {
        SGDRow* row = [SGDRow rowWithData:element cellClass:cellClass];
        [rows addObject:row];
    }
    
    return [SGDSection sectionWithRows:rows
                               header:header
                               footer:footer];
}

+ (instancetype)sectionWithEmptyDataForCellClasses:(NSArray*)cellClasses
{
    return [self sectionWithEmptyDataForCellClasses:cellClasses header:nil];
}

+ (instancetype)sectionWithEmptyDataForCellClasses:(NSArray*)cellClasses
                                            header:(SGDHeaderFooter*)header
{
    NSMutableArray* emptyData = [NSMutableArray array];
    for (NSUInteger i = 0; i < cellClasses.count; i++) {
        [emptyData addObject:[NSNull null]];
    }
    
    return [self sectionWithData:emptyData cellClasses:cellClasses allowsSelection:YES header:header context:nil];
}

+ (instancetype)sectionWithData:(NSArray*)data
                    cellClasses:(NSArray*)cellClasses
{
    return [self sectionWithData:data cellClasses:cellClasses allowsSelection:YES header:nil context:nil];
}

+ (instancetype)sectionWithData:(NSArray*)data
                    cellClasses:(NSArray*)cellClasses
                allowsSelection:(BOOL)allowsSelection
                         header:(SGDHeaderFooter*)header
                        context:(id)context
{
    NSMutableArray* rows = [NSMutableArray array];
    
    for (NSUInteger i = 0; i < data.count; i++) {
        SGDRow* row = [SGDRow rowWithData:data[i] cellClass:cellClasses[i] context:context];
        row.allowsSelection = allowsSelection;
        [rows addObject:row];
    }
    
    return [SGDSection sectionWithRows:rows header:header];
}

+ (instancetype)sectionWithRows:(NSArray*)rows
{
    return [self sectionWithRows:rows
                          header:nil];
}

+ (instancetype)sectionWithRows:(NSArray*)rows
                         header:(SGDHeaderFooter*)header
{
    return [self sectionWithRows:rows
                          header:header
                          footer:nil];
}

+ (instancetype)sectionWithRows:(NSArray*)rows
                         header:(SGDHeaderFooter*)header
                         footer:(SGDHeaderFooter*)footer
{
    SGDSection* section = [[SGDSection alloc] init];
    section.mutableRows = rows.mutableCopy;
    [section updateRowPointers];
    section.header = header;
    section.footer = footer;
    return section;
}

- (NSSet*)allCellClasses
{
    NSMutableSet* classes = [NSMutableSet set];
    for (SGDRow* row in self.rows) {
        [classes addObject:row.cellClass];
    }
    return classes;
}

@end
