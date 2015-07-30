//
//  SGDBaseRequester.m
//  Segundo
//
//  Created by Dustin Bachrach on 1/12/15.
//
//

#import "SGDBaseRequester.h"


@implementation SGDBaseRequester

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
