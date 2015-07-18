//
//  MHRequester.h
//  mediaHound
//
//  Created by Dustin Bachrach on 9/24/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>

@protocol MHRequester;


@protocol MHRequesterDataSource <NSObject>

@required

@property (strong, nonatomic) id model; // TODO: Try to get rid of having to store a model

/**
 * Begin the model fetching process.
 */
- (PMKPromise*)fetchModel;

@end


@protocol MHRequesterDelegate <NSObject>

@required

- (void)requesterDidBeginRefreshing:(id<MHRequester>)requester;
- (void)requesterWillBeginLoading:(id<MHRequester>)requester;
- (void)requesterDidFinishRequest:(id<MHRequester>)requester;
- (void)requester:(id<MHRequester>)requester needsBatchUpdatesPerformed:(void (^)())updates animated:(BOOL)animated;

/**
 * Invoked when a the model is updated.
 * Can occur more than once.
 * Always will be called on the main thread.
 */
- (void)modelDidLoad:(id)model;

- (void)didReset;

- (BOOL)animatesRefresh;


@optional
- (void)requester:(id<MHRequester>)requester didEncounterError:(NSError*)error;

- (void)requesterDidBeiginFetchingAnotherPage:(id<MHRequester>)requester;

- (BOOL)validateModel:(id)model;

@end



@protocol MHRequester <NSObject>

@required

@property (weak, nonatomic) id<MHRequesterDelegate> delegate;
@property (weak, nonatomic) id<MHRequesterDataSource> dataSource;

- (void)refresh;

// TODO: Rethink design and rename this
- (void)refreshWithoutReload;

@end



