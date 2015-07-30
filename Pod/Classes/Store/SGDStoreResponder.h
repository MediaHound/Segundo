//
//  SGDStoreResponder.h
//  Segundo
//
//  Created by Dustin Bachrach on 6/26/14.
//  Copyright (c) 2014 MediaHound. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SGDRow;
@class SGDStore;
@protocol SGDCell;


@protocol SGDStoreResponder <NSObject>

@optional
- (void)didSelectRow:(SGDRow*)row;
- (void)storeDidChange:(SGDStore*)store;
- (void)willDisplayCell:(id<SGDCell>)cell;
- (void)willEndDisplayCell:(id<SGDCell>)cell;

- (BOOL)storeShouldAllowSelection:(SGDStore*)store;

- (void)store:(SGDStore*)store didInsertSectionAtIndex:(NSUInteger)index;
- (void)store:(SGDStore*)store didAppendSections:(NSIndexSet*)sections;
- (void)store:(SGDStore*)store didDeleteSections:(NSIndexSet*)sections;
- (void)store:(SGDStore*)store didInsertRows:(NSIndexSet*)indexes inSection:(NSUInteger)sectionIndex;
- (void)store:(SGDStore*)store didDeleteRows:(NSIndexSet*)indexes inSection:(NSUInteger)sectionIndex;
- (void)store:(SGDStore*)store didUpdateRowAtIndexPath:(NSIndexPath*)indexPath inPlace:(BOOL)inPlace;
- (void)store:(SGDStore*)store
performBatchUpdates:(void (^)(void))updates
   completion:(void (^)(BOOL finished))completion
     animated:(BOOL)animated;

@end
