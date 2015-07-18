//
//  MHLoadingIndicator.h
//  mediaHound
//
//  Created by Gareth Walters on 4/25/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MHLoadingIndicator <NSObject>

@required

/**
 * Start the loading indicator.
 */
- (void)start;

/**
 * Stop the loading indicator.
 **/
- (void)stop;

// To show the indicator in the View
+ (id<MHLoadingIndicator>)showLoadingIndicatorOnView:(UIView*)view;

// To Hide the indicator in the View
+ (BOOL)hideLoadingIndicatorOnView:(UIView*)view;

@end
