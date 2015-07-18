//
//  MHSection.m
//  mediaHound
//
//  Created by Dustin Bachrach on 2/18/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import "MHSection.h"
#import "MHStore.h"
#import "MHStoreResponder.h"
#import "MHRow.h"
#import "MHRow+Internal.h"
#import "MHHeaderFooter+Internal.h"


@interface MHSection ()

@property (strong, nonatomic) NSMutableArray* mutableRows;
@property (strong, nonatomic, readwrite) MHHeaderFooter* header;
@property (strong, nonatomic, readwrite) MHHeaderFooter* footer;

// From MHSection+Internal
@property (weak, nonatomic, readwrite) MHStore* store;
@property (nonatomic, readwrite) NSInteger index;

@end


@implementation MHSection

- (void)updateRowPointers
{
    NSInteger i = 0;
    
    for (MHRow* row in self.mutableRows) {
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

- (void)setHeader:(MHHeaderFooter*)header
{
    _header = header;
    
    _header.section = self;
}

- (MHRow*)rowAtIndex:(NSUInteger)index
{
    MHRow* row = nil;
    
    if (index < self.rows.count) {
        row = self.rows[index];
    }
    return row;
}

+ (instancetype)emptySection
{
    return [self sectionWithRows:@[]];
}

+ (instancetype)sectionWithEmptyDataForCellClass:(Class<MHCell>)cellClass
                                           count:(NSUInteger)count
{
    NSMutableArray* emptyData = [NSMutableArray array];
    for (NSUInteger i = 0; i < count; i++) {
        [emptyData addObject:[NSNull null]];
    }
    return [self sectionWithData:emptyData cellClass:cellClass];
}

+ (instancetype)sectionWithData:(NSArray*)data
                      cellClass:(Class<MHCell>)cellClass
{
    return [self sectionWithData:data
                       cellClass:cellClass
                          header:nil];
}

+ (instancetype)sectionWithData:(NSArray*)data
                      cellClass:(Class<MHCell>)cellClass
                         header:(MHHeaderFooter*)header
{
    return [self sectionWithData:data
                       cellClass:cellClass
                          header:header
                          footer:nil];
}

+ (instancetype)sectionWithData:(NSArray*)data
                      cellClass:(Class<MHCell>)cellClass
                         header:(MHHeaderFooter*)header
                         footer:(MHHeaderFooter*)footer
{
    NSMutableArray* rows = [NSMutableArray array];
    
    for (id element in data) {
        MHRow* row = [MHRow rowWithData:element cellClass:cellClass];
        [rows addObject:row];
    }
    
    return [MHSection sectionWithRows:rows
                               header:header
                               footer:footer];
}

+ (instancetype)sectionWithEmptyDataForCellClasses:(NSArray*)cellClasses
{
    return [self sectionWithEmptyDataForCellClasses:cellClasses header:nil];
}

+ (instancetype)sectionWithEmptyDataForCellClasses:(NSArray*)cellClasses
                                            header:(MHHeaderFooter*)header
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
                         header:(MHHeaderFooter*)header
                        context:(id)context
{
    NSMutableArray* rows = [NSMutableArray array];
    
    for (NSUInteger i = 0; i < data.count; i++) {
        MHRow* row = [MHRow rowWithData:data[i] cellClass:cellClasses[i] context:context];
        row.allowsSelection = allowsSelection;
        [rows addObject:row];
    }
    
    return [MHSection sectionWithRows:rows header:header];
}

+ (instancetype)sectionWithRows:(NSArray*)rows
{
    return [self sectionWithRows:rows
                          header:nil];
}

+ (instancetype)sectionWithRows:(NSArray*)rows
                         header:(MHHeaderFooter*)header
{
    return [self sectionWithRows:rows
                          header:header
                          footer:nil];
}

+ (instancetype)sectionWithRows:(NSArray*)rows
                         header:(MHHeaderFooter*)header
                         footer:(MHHeaderFooter*)footer
{
    MHSection* section = [[MHSection alloc] init];
    section.mutableRows = rows.mutableCopy;
    [section updateRowPointers];
    section.header = header;
    section.footer = footer;
    return section;
}

- (NSSet*)allCellClasses
{
    NSMutableSet* classes = [NSMutableSet set];
    for (MHRow* row in self.rows) {
        [classes addObject:row.cellClass];
    }
    return classes;
}

@end
