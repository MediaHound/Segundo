//
//  SGDBaseRequester.h
//  Segundo
//
//  Created by Dustin Bachrach on 1/12/15.
//
//

#import <Foundation/Foundation.h>
#import "SGDRequester.h"


@interface SGDBaseRequester : NSObject <SGDRequester>

- (void)handleFetchError:(NSError*)error;

@end
