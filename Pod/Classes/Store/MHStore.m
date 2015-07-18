//
//  MHStore.m
//  mediaHound
//
//  Created by Dustin Bachrach on 2/18/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import "MHStore.h"
#import "MHStoreResponder.h"
#import "MHSection.h"
#import "MHRow.h"
#import "MHHeaderFooter.h"
#import "MHSection+Internal.h"


@interface MHStore ()

@property (strong, nonatomic) NSMutableArray* mutableSections;

@end


@implementation MHStore

- (void)updateSectionPointers
{
    NSInteger i = 0;
    
    for (MHSection* section in self.mutableSections) {
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

- (void)insertSection:(MHSection*)section atIndex:(NSUInteger)index
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

- (MHSection*)sectionAtIndex:(NSUInteger)index
{
    MHSection* section = nil;
    if (index < self.sections.count) {
        section = self.sections[index];
    }
    return section;
}

- (MHRow*)rowAtIndexPath:(NSIndexPath*)indexPath
{
    MHSection* section = [self sectionAtIndex:indexPath.section];
    MHRow* row = [section rowAtIndex:indexPath.row];
    return row;
}

+ (instancetype)simpleStoreWithData:(NSArray*)data cellClass:(Class<MHCell>)cellClass
{
    MHSection* section = [MHSection sectionWithData:data cellClass:cellClass];
    
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
    MHSection* section = [MHSection sectionWithData:data
                                        cellClasses:cellClasses
                                    allowsSelection:allowsSelection
                                             header:nil
                                            context:nil];
    
    return [self storeWithSections:@[section]];
}

+ (instancetype)storeWithSections:(NSArray*)sections
{
    MHStore* store = [[MHStore alloc] initWithSections:sections];
    return store;
}

+ (instancetype)emptyStore
{
    return [[MHStore alloc] init];
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
    for (MHSection* section in self.sections) {
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
    for (MHSection* section in self.sections) {
        [classes unionSet:section.allCellClasses];
    }
    return classes;
}

- (NSSet*)allHeaderFooterCellClasses
{
    NSMutableSet* classes = [NSMutableSet set];
    for (MHSection* section in self.sections) {
        MHHeaderFooter* header = section.header;
        if (header) {
            [classes addObject:header.cellClass];
        }
    }
    return classes;
}

@end
