//
//  SGDRequester.h
//  Segundo
//
//  Created by Dustin Bachrach on 9/24/14.
//  Copyright (c) 2014 MediaHound. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>

@protocol SGDRequester;


@protocol SGDRequesterDataSource <NSObject>

@required

/**
 * Begin the model fetching process.
 */
- (AnyPromise*)fetchModel;

@end


@protocol SGDRequesterDelegate <NSObject>

@required

- (void)requesterDidBeginRefreshing:(id<SGDRequester>)requester;
- (void)requesterWillBeginLoading:(id<SGDRequester>)requester;
- (void)requesterDidFinishRequest:(id<SGDRequester>)requester;
- (void)requester:(id<SGDRequester>)requester needsBatchUpdatesPerformed:(void (^)())updates animated:(BOOL)animated completion:(void (^)(BOOL finished))completion;

/**
 * Invoked when a the model is updated.
 * Can occur more than once.
 * Always will be called on the main thread.
 */
- (void)modelDidLoad:(id)model;

- (void)didReset;

- (BOOL)animatesRefresh;


@optional
- (void)requester:(id<SGDRequester>)requester didEncounterError:(NSError*)error;

- (BOOL)requesterShouldBeginFetchingAnotherPage:(id<SGDRequester>)requester;

- (void)requesterDidBeiginFetchingAnotherPage:(id<SGDRequester>)requester;

- (BOOL)validateModel:(id)model;

@end



@protocol SGDRequester <NSObject>

@required

@property (weak, nonatomic) id<SGDRequesterDelegate> delegate;
@property (weak, nonatomic) id<SGDRequesterDataSource> dataSource;

- (void)refresh;

@end



