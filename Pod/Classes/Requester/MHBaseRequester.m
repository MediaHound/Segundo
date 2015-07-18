//
//  MHBaseRequester.m
//  Pods
//
//  Created by Dustin Bachrach on 1/12/15.
//
//

#import "MHBaseRequester.h"


@implementation MHBaseRequester

@synthesize dataSource;
@synthesize delegate;

- (void)refresh
{
    // Do nothing
}

- (void)refreshWithoutReload
{
    // Do nothing
}

- (void)handleFetchError:(NSError*)error
{
    if ([error.domain isEqualToString:NSURLErrorDomain] && error.code == NSURLErrorCancelled) {
        // Allow cancelation errors
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(requester:didEncounterError:)]) {
        [self.delegate requester:self didEncounterError:error];
    }
}

@end
