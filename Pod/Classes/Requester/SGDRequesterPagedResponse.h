//
//  SGDRequesterPagedResponse.h
//  Segundo
//
//  Created by Dustin Bachrach on 1/12/15.
//
//

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>


/**
 * SGDPagedRequester requires the object that is returned from `-fetchModel`
 * to conform to SGDRequesterPagedResponse.
 * A paged response must store the current page's content in `content`.
 * It must provide `-fetchNext` method that asynchronously fetches the next
 * page of results.
 * It must also implement a `hasMorePages` to indicate whether more pages
 * can be fetched.
 */
@protocol SGDRequesterPagedResponse <NSObject>

@property (strong, nonatomic, readonly) id content;

@property (nonatomic, readonly) BOOL hasMorePages;

- (AnyPromise*)fetchNext;

@end
