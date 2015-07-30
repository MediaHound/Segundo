//
//  SGDPagedRequester.h
//  Segundo
//
//  Created by Dustin Bachrach on 1/12/15.
//
//

#import "SGDBaseRequester.h"


@interface SGDPagedRequester : SGDBaseRequester

- (void)refreshNextPage;

@property (nonatomic, readonly, getter = isFetchingNewPage) BOOL fetchingNewPage;

@property (nonatomic, readonly) BOOL morePagesAvailable;

@end
