//
//  SGDRequesterPagedResponse.h
//  Segundo
//
//  Created by Dustin Bachrach on 1/12/15.
//
//

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>


@protocol SGDRequesterPagedResponse <NSObject>

@property (strong, nonatomic, readonly) id content;

@property (nonatomic, readonly) BOOL hasMorePages;

- (AnyPromise*)fetchNext;

@end
