//
//  SGDHeader.h
//  Segundo
//
//  Created by Dustin Bachrach on 4/20/14.
//  Copyright (c) 2014 MediaHound. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SGDSection;
@class SGDStore;
@protocol SGDHeaderFooterCell;


@interface SGDHeaderFooter : NSObject

@property (weak, nonatomic, readonly) SGDSection* section;
@property (weak, nonatomic, readonly) SGDStore* store;

@property (strong, nonatomic, readonly) id data;

@property (strong, nonatomic, readonly) Class<SGDHeaderFooterCell> cellClass;

+ (instancetype)headerFooterWithData:(id)data cellClass:(Class<SGDHeaderFooterCell>)cellClass;

@end
