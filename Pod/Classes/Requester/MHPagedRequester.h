//
//  MHPagedRequester.h
//  Pods
//
//  Created by Dustin Bachrach on 1/12/15.
//
//

#import "MHBaseRequester.h"


@interface MHPagedRequester : MHBaseRequester

- (void)refreshNextPage;

@property (nonatomic, readonly, getter = isFetchingNewPage) BOOL fetchingNewPage;

@property (nonatomic, readonly) BOOL morePagesAvailable;

@end
