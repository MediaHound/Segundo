//
//  MHHeader.h
//  mediaHound
//
//  Created by Dustin Bachrach on 4/20/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MHSection;
@class MHStore;
@protocol MHHeaderFooterCell;


@interface MHHeaderFooter : NSObject

@property (weak, nonatomic, readonly) MHSection* section;
@property (weak, nonatomic, readonly) MHStore* store;

@property (strong, nonatomic, readonly) id data;

@property (strong, nonatomic, readonly) Class<MHHeaderFooterCell> cellClass;

+ (instancetype)headerFooterWithData:(id)data cellClass:(Class<MHHeaderFooterCell>)cellClass;

@end
