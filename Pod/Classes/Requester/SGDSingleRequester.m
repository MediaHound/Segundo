//
//  SGDSingleRequester.m
//  Segundo
//
//  Created by Dustin Bachrach on 1/12/15.
//
//

#import "SGDSingleRequester.h"
#import "SGDRequesterPagedResponse.h"


@implementation SGDSingleRequester

- (void)reset
{
    if ([self.delegate respondsToSelector:@selector(didReset)]) {
        [self.delegate requester:self
      needsBatchUpdatesPerformed:^{ [self.delegate didReset]; }
                        animated:[self.delegate animatesRefresh]
                      completion:nil];
    }
}

- (void)refresh
{
    [self reset];
    
    [self.delegate requesterDidBeginRefreshing:self];
    
    [self.dataSource fetchModel].then(^(id model) {
        if (!model) {
            return;
        }
        
        if ([model conformsToProtocol:@protocol(SGDRequesterPagedResponse)]) {
            model = [model content];
        }
        
        if (![self.delegate respondsToSelector:@selector(validateModel:)] || [self.delegate validateModel:model]) {
            [self.delegate requester:self needsBatchUpdatesPerformed:^{                
                [self.delegate requesterWillBeginLoading:self];
                [self.delegate modelDidLoad:model];
            }
                            animated:[self.delegate animatesRefresh]
                          completion:^(BOOL finished) {
                              [self.delegate requesterDidFinishRequest:self];
                          }];
        }
    }).catch(^(NSError* error) {
        [self handleFetchError:error];
        [self.delegate requesterDidFinishRequest:self];
    });
}

@end
