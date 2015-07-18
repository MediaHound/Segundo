//
//  RKiOS7Loading.h
//  iOS7StyleLoading
//
//  Created by raj on 15/12/13.
//  Copyright (c) 2013 iPhone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHLoadingIndicator.h"


@interface MHCircularLoadingIndicator : UIView <MHLoadingIndicator>

/**
 * The width of the line used to draw the indicator view.
 **/
@property (nonatomic) CGFloat lineWidth;

@property (nonatomic) CGFloat verticalOffset;

@end
