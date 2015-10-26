//
//  SGDPagedRequester.m
//  Segundo
//
//  Created by Dustin Bachrach on 1/12/15.
//
//

#import "SGDPagedRequester.h"
#import "SGDRequesterPagedResponse.h"


@interface SGDPagedRequester ()

@property (nonatomic, readwrite, getter = isFetchingNewPage) BOOL fetchingNewPage;

@property (strong, nonatomic) id<SGDRequesterPagedResponse> latestResponse;

@property (nonatomic) NSInteger lastResetId; // Always access from main thread

@end


@implementation SGDPagedRequester

- (instancetype)init
{
    if (self = [super init]) {
        [self resetInternal];
    }
    return self;
}

- (void)refresh
{
    [self reset];
    [self refreshNextPage];
}

- (void)reset
{
    if ([self.delegate respondsToSelector:@selector(didReset)]) {
        [self.delegate requester:self
      needsBatchUpdatesPerformed:^{
                [self.delegate didReset];
            }
                        animated:[self.delegate animatesRefresh]
                      completion:nil];
    }
    
    [self resetInternal];
}

- (void)resetInternal
{
    self.latestResponse = nil;
    self.lastResetId = arc4random();
}

- (void)refreshNextPage
{
    if (!self.morePagesAvailable) {
        return;
    }
    
    self.fetchingNewPage = YES;
    
    
    AnyPromise* fetchedModel = nil;
    if (!self.latestResponse) {
        [self.delegate requesterDidBeginRefreshing:self];
        fetchedModel = [self.dataSource fetchModel];
    }
    else {
        [self.delegate requesterDidBeiginFetchingAnotherPage:self];
        fetchedModel = [self.latestResponse fetchNext];
    }
    
    NSInteger currentResetId = self.lastResetId;
    
    fetchedModel.then(^(id<SGDRequesterPagedResponse> response) {
        if (!response) {
            return;
        }
        
        NSAssert([response conformsToProtocol:@protocol(SGDRequesterPagedResponse)], @"SGDPagedRequester requires the model to conform to SGDRequesterPagedResponse");
        
        // Was reset while we were fetching
        if (currentResetId != self.lastResetId) {
            return;
        }
        
        self.latestResponse = response;
        
        if ((![self.delegate respondsToSelector:@selector(validateModel:)] || [self.delegate validateModel:response])) {
            [self.delegate requester:self
          needsBatchUpdatesPerformed:^{
                [self.delegate requesterWillBeginLoading:self];
                [self.delegate modelDidLoad:response];
             }
                            animated:[self.delegate animatesRefresh]
                          completion:^(BOOL finished) {
                              [self.delegate requesterDidFinishRequest:self];
                              self.fetchingNewPage = NO;
                          }];
        }
        
    }).catch(^(NSError* error) {
        [self handleFetchError:error];
        [self.delegate requesterDidFinishRequest:self];
    });
}

- (BOOL)morePagesAvailable
{
    if (!self.latestResponse) {
        return YES;
    }
    if (self.latestResponse.hasMorePages) {
        return YES;
    }
    
    return NO;
}

@end
