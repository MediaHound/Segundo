//
//  MHStoreResponder.h
//  mediaHound
//
//  Created by Dustin Bachrach on 6/26/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MHRow;
@class MHStore;
@protocol MHCell;


@protocol MHStoreResponder <NSObject>

@optional
- (void)didSelectRow:(MHRow*)row;
- (void)storeDidChange:(MHStore*)store;
- (void)willDisplayCell:(id<MHCell>)cell;
- (void)willEndDisplayCell:(id<MHCell>)cell;

- (BOOL)storeShouldAllowSelection:(MHStore*)store;

- (void)store:(MHStore*)store didInsertSectionAtIndex:(NSUInteger)index;
- (void)store:(MHStore*)store didAppendSections:(NSIndexSet*)sections;
- (void)store:(MHStore*)store didDeleteSections:(NSIndexSet*)sections;
- (void)store:(MHStore*)store didInsertRows:(NSIndexSet*)indexes inSection:(NSUInteger)sectionIndex;
- (void)store:(MHStore*)store didDeleteRows:(NSIndexSet*)indexes inSection:(NSUInteger)sectionIndex;
- (void)store:(MHStore*)store didUpdateRowAtIndexPath:(NSIndexPath*)indexPath inPlace:(BOOL)inPlace;
- (void)store:(MHStore*)store
performBatchUpdates:(void (^)(void))updates
   completion:(void (^)(BOOL finished))completion
     animated:(BOOL)animated;

@end
