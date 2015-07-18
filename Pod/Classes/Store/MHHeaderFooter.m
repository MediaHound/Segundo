//
//  MHHeader.m
//  mediaHound
//
//  Created by Dustin Bachrach on 4/20/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import "MHHeaderFooter.h"
#import "MHSection.h"
#import "MHStore.h"


@interface MHHeaderFooter ()

@property (strong, nonatomic, readwrite) id data;

@property (strong, nonatomic, readwrite) Class<MHHeaderFooterCell> cellClass;

// From MHHeaderFooter+Internal
@property (weak, nonatomic, readwrite) MHSection* section;

@end


@implementation MHHeaderFooter

+ (instancetype)headerFooterWithData:(id)data cellClass:(Class<MHHeaderFooterCell>)cellClass
{
    MHHeaderFooter* headerFooter = [[MHHeaderFooter alloc] init];
    headerFooter.data = data;
    headerFooter.cellClass = cellClass;
    return headerFooter;
}

- (MHStore*)store
{
    return self.section.store;
}

@end
