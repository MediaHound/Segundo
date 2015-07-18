//
//  MHBaseRequester.h
//  Pods
//
//  Created by Dustin Bachrach on 1/12/15.
//
//

#import <Foundation/Foundation.h>
#import "MHRequester.h"


@interface MHBaseRequester : NSObject <MHRequester>

- (void)handleFetchError:(NSError*)error;

@end
