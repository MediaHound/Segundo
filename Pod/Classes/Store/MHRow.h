//
//  MHRow.h
//  mediaHound
//
//  Created by Dustin Bachrach on 2/18/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MHCell;
@class MHSection;
@class MHStore;


@interface MHRow : NSObject

@property (weak, nonatomic, readonly) MHSection* section;
@property (weak, nonatomic, readonly) MHStore* store;
@property (nonatomic, readonly) NSIndexPath* indexPath;

@property (nonatomic) BOOL allowsSelection;

@property (nonatomic) NSInteger zIndex;

@property (strong, nonatomic, readonly) id data;

@property (strong, nonatomic, readonly) Class<MHCell> cellClass;

@property (strong, nonatomic, readonly) id context;

+ (instancetype)rowWithData:(id)data cellClass:(Class<MHCell>)cellClass;

+ (instancetype)rowWithData:(id)data cellClass:(Class<MHCell>)cellClass context:(id)context;

- (void)updateData:(id)data;
- (void)updateData:(id)data inPlace:(BOOL)inPlace;
- (void)updateCellClass:(Class<MHCell>)cellClass;
- (void)updateData:(id)data cellClass:(Class<MHCell>)cellClass;

@end
