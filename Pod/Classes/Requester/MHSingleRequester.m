//
//  MHSingleRequester.m
//  Pods
//
//  Created by Dustin Bachrach on 1/12/15.
//
//

#import "MHSingleRequester.h"
#import "MHRequesterPagedResponse.h"


@implementation MHSingleRequester

- (void)reset
{
    if ([self.delegate respondsToSelector:@selector(didReset)]) {
        [self.delegate requester:self
      needsBatchUpdatesPerformed:^{
                [self.delegate didReset];
            }
                        animated:[self.delegate animatesRefresh]];
    }
}

- (void)refresh
{
    [self reset];
    
    [self.delegate requesterDidBeginRefreshing:self];
    
    [self.dataSource fetchModel].then(^(id model) {
        if ([model conformsToProtocol:@protocol(MHRequesterPagedResponse)]) {
            model = [model content];
        }
        
        if (![self.delegate respondsToSelector:@selector(validateModel:)] || [self.delegate validateModel:model]) {
            [self.delegate requester:self needsBatchUpdatesPerformed:^{
                
                self.dataSource.model = model;
                
                [self.delegate requesterWillBeginLoading:self];
                [self.delegate modelDidLoad:model];
            } animated:[self.delegate animatesRefresh]];
            
            [self.delegate requesterDidFinishRequest:self];
        }
    }).catch(^(NSError* error) {
        [self handleFetchError:error];
        [self.delegate requesterDidFinishRequest:self];
    });
}

- (void)refreshWithoutReload
{
    [self reset];
    
    [self.delegate requesterDidBeginRefreshing:self];
    
    [self.delegate requester:self needsBatchUpdatesPerformed:^{
        [self.delegate requesterWillBeginLoading:self];
        [self.delegate modelDidLoad:self.dataSource.model];
    } animated:[self.delegate animatesRefresh]];
    
    [self.delegate requesterDidFinishRequest:self];
}

@end
