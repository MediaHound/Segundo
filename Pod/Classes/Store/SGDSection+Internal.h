//
//  SGDSection+Internal.h
//  Segundo
//
//  Created by Dustin Bachrach on 3/19/14.
//  Copyright (c) 2014 MediaHound. All rights reserved.
//

#import "SGDSection.h"


@interface SGDSection (Internal)

@property (weak, nonatomic, readwrite) SGDStore* store;
@property (nonatomic, readwrite) NSInteger index;

@end
