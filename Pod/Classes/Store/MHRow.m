//
//  MHRow.m
//  mediaHound
//
//  Created by Dustin Bachrach on 2/18/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import "MHRow.h"
#import "MHCell.h"
#import "MHSection.h"
#import "MHRow+Internal.h"
#import "MHSection+Internal.h"
#import "MHStore.h"
#import "MHStoreResponder.h"


@interface MHRow ()

@property (strong, nonatomic, readwrite) id data;
@property (strong, nonatomic, readwrite) Class<MHCell> cellClass;
@property (strong, nonatomic, readwrite) id context;

// From MHRow+Internal
@property (weak, nonatomic, readwrite) MHSection* section;
@property (nonatomic, readwrite) NSInteger index;

@end


@implementation MHRow

- (instancetype)init
{
    if (self = [super init]) {
        _allowsSelection = YES;
        _zIndex = 0;
    }
    return self;
}

+ (instancetype)rowWithData:(id)data cellClass:(Class<MHCell>)cellClass
{
    return [self rowWithData:data cellClass:cellClass context:nil];
}

+ (instancetype)rowWithData:(id)data cellClass:(Class<MHCell>)cellClass context:(id)context
{
    MHRow* row = [[MHRow alloc] init];
    row.data = data;
    row.cellClass = cellClass;
    row.context = context;
    row.allowsSelection = [cellClass allowsSelection];
    row.zIndex = [cellClass zIndex];
    
    [cellClass preemptivelyLoadResourcesForData:data];
    
    return row;
}

- (MHStore*)store
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

- (void)updateCellClass:(Class<MHCell>)cellClass
{
    [self updateData:self.data cellClass:cellClass];
}

- (void)updateData:(id)data cellClass:(Class<MHCell>)cellClass
{
    [self updateData:data cellClass:cellClass inPlace:NO];
}

- (void)updateData:(id)data cellClass:(Class<MHCell>)cellClass inPlace:(BOOL)inPlace
{
    self.data = data;
    self.cellClass = cellClass;
    
    [self.cellClass preemptivelyLoadResourcesForData:data];
    
    if ([self.store.delegate respondsToSelector:@selector(store:didUpdateRowAtIndexPath:inPlace:)]) {
        [self.store.delegate store:self.store didUpdateRowAtIndexPath:self.indexPath inPlace:inPlace];
    }
}

@end
