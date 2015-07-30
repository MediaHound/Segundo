//
//  SGDRow.m
//  Segundo
//
//  Created by Dustin Bachrach on 2/18/14.
//  Copyright (c) 2014 MediaHound. All rights reserved.
//

#import "SGDRow.h"
#import "SGDCell.h"
#import "SGDSection.h"
#import "SGDRow+Internal.h"
#import "SGDSection+Internal.h"
#import "SGDStore.h"
#import "SGDStoreResponder.h"


@interface SGDRow ()

@property (strong, nonatomic, readwrite) id data;
@property (strong, nonatomic, readwrite) Class<SGDCell> cellClass;
@property (strong, nonatomic, readwrite) id context;

// From SGDRow+Internal
@property (weak, nonatomic, readwrite) SGDSection* section;
@property (nonatomic, readwrite) NSInteger index;

@end


@implementation SGDRow

- (instancetype)init
{
    if (self = [super init]) {
        _allowsSelection = YES;
        _zIndex = 0;
    }
    return self;
}

+ (instancetype)rowWithData:(id)data cellClass:(Class<SGDCell>)cellClass
{
    return [self rowWithData:data cellClass:cellClass context:nil];
}

+ (instancetype)rowWithData:(id)data cellClass:(Class<SGDCell>)cellClass context:(id)context
{
    SGDRow* row = [[SGDRow alloc] init];
    row.data = data;
    row.cellClass = cellClass;
    row.context = context;
    row.allowsSelection = [cellClass allowsSelection];
    row.zIndex = [cellClass zIndex];
    
    [cellClass preemptivelyLoadResourcesForData:data];
    
    return row;
}

- (SGDStore*)store
{
    return self.section.store;
}

- (NSIndexPath*)indexPath
{
    return [NSIndexPath indexPathForRow:self.index inSection:self.section.index];
}

- (void)updateData:(id)data
{
    [self updateData:data inPlace:NO];
}

- (void)updateData:(id)data inPlace:(BOOL)inPlace
{
    [self updateData:data cellClass:self.cellClass inPlace:inPlace];
}

- (void)updateCellClass:(Class<SGDCell>)cellClass
{
    [self updateData:self.data cellClass:cellClass];
}

- (void)updateData:(id)data cellClass:(Class<SGDCell>)cellClass
{
    [self updateData:data cellClass:cellClass inPlace:NO];
}

- (void)updateData:(id)data cellClass:(Class<SGDCell>)cellClass inPlace:(BOOL)inPlace
{
    self.data = data;
    self.cellClass = cellClass;
    
    [self.cellClass preemptivelyLoadResourcesForData:data];
    
    if ([self.store.delegate respondsToSelector:@selector(store:didUpdateRowAtIndexPath:inPlace:)]) {
        [self.store.delegate store:self.store didUpdateRowAtIndexPath:self.indexPath inPlace:inPlace];
    }
}

@end
