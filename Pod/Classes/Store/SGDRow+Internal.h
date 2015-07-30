//
//  SGDRow+Private.h
//  Segundo
//
//  Created by Dustin Bachrach on 3/19/14.
//  Copyright (c) 2014 MediaHound. All rights reserved.
//

#import "SGDRow.h"


@interface SGDRow (Internal)

@property (weak, nonatomic, readwrite) SGDSection* section;
@property (nonatomic, readwrite) NSInteger index;

@end
