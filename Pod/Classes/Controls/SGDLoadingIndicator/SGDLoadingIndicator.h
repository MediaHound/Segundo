//
//  SGDLoadingIndicator.h
//  Segundo
//
//  Created by Gareth Walters on 4/25/14.
//  Copyright (c) 2014 MediaHound. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 * A Loading Indicator must conform to the SGDLoadingIndicator protocol.
 */
@protocol SGDLoadingIndicator <NSObject>

@required

/**
 * Start the loading indicator.
 */
- (void)start;

/**
 * Stop the loading indicator.
 **/
- (void)stop;

/**
 * Creates and shows a loading indicator in a given view.
 * @param view The view to show the loading indicator on.
 * @return the loading indicator that was created.
 */
+ (id<SGDLoadingIndicator>)showLoadingIndicatorOnView:(UIView*)view;

/**
 * Hide an indicator that is on the given view.
 * @param view The view to look into to find a loading indicator to hide.
 * @return Whether a loading indicator was found and hidden.
 */
+ (BOOL)hideLoadingIndicatorOnView:(UIView*)view;

@end
