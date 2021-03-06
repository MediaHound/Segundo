//
//  SGDRow.h
//  Segundo
//
//  Created by Dustin Bachrach on 2/18/14.
//  Copyright (c) 2014 MediaHound. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SGDCell;
@class SGDSection;
@class SGDStore;


@interface SGDRow : NSObject

@property (weak, nonatomic, readonly) SGDSection* section;
@property (weak, nonatomic, readonly) SGDStore* store;
@property (nonatomic, readonly) NSIndexPath* indexPath;

@property (nonatomic) BOOL allowsSelection;

@property (nonatomic) NSInteger zIndex;

@property (strong, nonatomic, readonly) id data;

@property (strong, nonatomic, readonly) Class<SGDCell> cellClass;

@property (strong, nonatomic, readonly) id context;

+ (instancetype)rowWithData:(id)data cellClass:(Class<SGDCell>)cellClass;

+ (instancetype)rowWithData:(id)data cellClass:(Class<SGDCell>)cellClass context:(id)context;

- (void)refreshInPlace;

- (void)updateData:(id)data;
- (void)updateData:(id)data inPlace:(BOOL)inPlace;
- (void)updateCellClass:(Class<SGDCell>)cellClass;
- (void)updateData:(id)data cellClass:(Class<SGDCell>)cellClass;

@end
