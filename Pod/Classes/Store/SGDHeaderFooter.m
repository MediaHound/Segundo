//
//  SGDHeader.m
//  Segundo
//
//  Created by Dustin Bachrach on 4/20/14.
//  Copyright (c) 2014 MediaHound. All rights reserved.
//

#import "SGDHeaderFooter.h"
#import "SGDSection.h"
#import "SGDStore.h"


@interface SGDHeaderFooter ()

@property (strong, nonatomic, readwrite) id data;

@property (strong, nonatomic, readwrite) Class<SGDHeaderFooterCell> cellClass;

// From SGDHeaderFooter+Internal
@property (weak, nonatomic, readwrite) SGDSection* section;

@end


@implementation SGDHeaderFooter

+ (instancetype)headerFooterWithData:(id)data cellClass:(Class<SGDHeaderFooterCell>)cellClass
{
    SGDHeaderFooter* headerFooter = [[SGDHeaderFooter alloc] init];
    headerFooter.data = data;
    headerFooter.cellClass = cellClass;
    return headerFooter;
}

- (SGDStore*)store
{
    return self.section.store;
}

@end
