//
//  SGDStore.m
//  Segundo
//
//  Created by Dustin Bachrach on 2/18/14.
//  Copyright (c) 2014 MediaHound. All rights reserved.
//

#import "SGDStore.h"
#import "SGDStoreResponder.h"
#import "SGDSection.h"
#import "SGDRow.h"
#import "SGDHeaderFooter.h"
#import "SGDSection+Internal.h"


@interface SGDStore ()

@property (strong, nonatomic) NSMutableArray* mutableSections;

@end


@implementation SGDStore

- (void)updateSectionPointers
{
    NSInteger i = 0;
    
    for (SGDSection* section in self.mutableSections) {
        section.store = self;
        section.index = i;
        i++;
    }
}

- (NSArray*)sections
{
    return self.mutableSections;
}

- (void)performBatchUpdates:(void (^)(void))updates
{
    [self performBatchUpdates:updates completion:nil];
}

- (void)performBatchUpdates:(void (^)(void))updates
                 completion:(void (^)(BOOL finished))completion
{
    [self performBatchUpdates:updates completion:completion animated:YES];
}

- (void)performBatchUpdates:(void (^)(void))updates
                 completion:(void (^)(BOOL finished))completion
                   animated:(BOOL)animated
{
    if ([self.delegate respondsToSelector:@selector(store:performBatchUpdates:completion:animated:)]) {
        [self.delegate store:self performBatchUpdates:updates completion:completion animated:animated];
    }
    else {
        if (updates) {
            updates();
        }
        if (completion) {
            completion(YES);
        }
    }
}

- (void)insertSection:(SGDSection*)section atIndex:(NSUInteger)index
{
    [self.mutableSections insertObject:section atIndex:index];
    [self updateSectionPointers];
    
    if ([self.delegate respondsToSelector:@selector(storeDidChange:)]) {
        [self.delegate storeDidChange:self];
    }
    
    if ([self.delegate respondsToSelector:@selector(store:didInsertSectionAtIndex:)]) {
        [self.delegate store:self didInsertSectionAtIndex:index];
    }
}

- (void)appendSections:(NSArray*)newSections
{
    // TODO: Check if in batch mode, and enter batch mode if not already in
    if (newSections.count > 0) {
        NSUInteger previousSectionCount = self.sections.count;
        
        [self.mutableSections addObjectsFromArray:newSections];
        [self updateSectionPointers];
        
        if ([self.delegate respondsToSelector:@selector(storeDidChange:)]) {
            [self.delegate storeDidChange:self];
        }
        
        if ([self.delegate respondsToSelector:@selector(store:didAppendSections:)]) {
            NSIndexSet* indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(previousSectionCount,
                                                                                      newSections.count)];
            [self.delegate store:self didAppendSections:indexSet];
        }
    }
}

- (void)deleteSections:(NSIndexSet*)indexSet
{
    [self.mutableSections removeObjectsAtIndexes:indexSet];
    [self updateSectionPointers];
    
    // TODO: Figure out a better way to do storeDidChange
    if ([self.delegate respondsToSelector:@selector(storeDidChange:)]) {
        [self.delegate storeDidChange:self];
    }
    
    if ([self.delegate respondsToSelector:@selector(store:didDeleteSections:)]) {
        [self.delegate store:self didDeleteSections:indexSet];
    }
}

- (void)removeAllSections
{
    [self deleteSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.sections.count)]];
}

- (SGDSection*)sectionAtIndex:(NSUInteger)index
{
    SGDSection* section = nil;
    if (index < self.sections.count) {
        section = self.sections[index];
    }
    return section;
}

- (SGDRow*)rowAtIndexPath:(NSIndexPath*)indexPath
{
    SGDSection* section = [self sectionAtIndex:indexPath.section];
    SGDRow* row = [section rowAtIndex:indexPath.row];
    return row;
}

+ (instancetype)simpleStoreWithData:(NSArray*)data cellClass:(Class<SGDCell>)cellClass
{
    SGDSection* section = [SGDSection sectionWithData:data cellClass:cellClass];
    
    return [self storeWithSections:@[section]];
}

+ (instancetype)simpleStoreWithData:(NSArray*)data cellClasses:(NSArray*)cellClasses
{
    return [self simpleStoreWithData:data cellClasses:cellClasses allowsSelection:YES];
}

+ (instancetype)simpleStoreWithData:(NSArray*)data
                        cellClasses:(NSArray*)cellClasses
                    allowsSelection:(BOOL)allowsSelection
{
    SGDSection* section = [SGDSection sectionWithData:data
                                        cellClasses:cellClasses
                                    allowsSelection:allowsSelection
                                             header:nil
                                            context:nil];
    
    return [self storeWithSections:@[section]];
}

+ (instancetype)storeWithSections:(NSArray*)sections
{
    SGDStore* store = [[SGDStore alloc] initWithSections:sections];
    return store;
}

+ (instancetype)emptyStore
{
    return [[SGDStore alloc] init];
}

- (instancetype)init
{
    return [self initWithSections:@[]];
}

- (instancetype)initWithSections:(NSArray*)sections
{
    if (self = [super init]) {
        _mutableSections = sections.mutableCopy;
        [self updateSectionPointers];
    }
    return self;
}

- (BOOL)isEmpty
{
    BOOL isEmpty = YES;
    for (SGDSection* section in self.sections) {
        if (section.rows.count > 0) {
            isEmpty = NO;
            break;
        }
    }
    return isEmpty;
}

- (NSSet*)allCellClasses
{
    NSMutableSet* classes = [NSMutableSet set];
    for (SGDSection* section in self.sections) {
        [classes unionSet:section.allCellClasses];
    }
    return classes;
}

- (NSSet*)allHeaderFooterCellClasses
{
    NSMutableSet* classes = [NSMutableSet set];
    for (SGDSection* section in self.sections) {
        SGDHeaderFooter* header = section.header;
        if (header) {
            [classes addObject:header.cellClass];
        }
    }
    return classes;
}

@end
