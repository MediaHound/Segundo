//
//  MHSection+Internal.h
//  mediaHound
//
//  Created by Dustin Bachrach on 3/19/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import "MHSection.h"


@interface MHSection (Internal)

@property (weak, nonatomic, readwrite) MHStore* store;
@property (nonatomic, readwrite) NSInteger index;

@end
