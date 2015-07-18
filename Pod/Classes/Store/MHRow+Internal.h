//
//  MHRow+Private.h
//  mediaHound
//
//  Created by Dustin Bachrach on 3/19/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import "MHRow.h"


@interface MHRow (Internal)

@property (weak, nonatomic, readwrite) MHSection* section;
@property (nonatomic, readwrite) NSInteger index;

@end
