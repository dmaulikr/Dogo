//
//  DGArticleFetcher.h
//  Dogo
//
//  Created by Marsal on 07/09/15.
//  Copyright (c) 2015 Marsal Silveira. All rights reserved.
//

#pragma mark - <DGArticleFetcherDelegate>

/**
 * Protocol to receive Success or Error notification
 */
@protocol DGArticleFetcherDelegate <NSObject>

//! Receive a success message
- (void)fetchDataSuccess:(NSArray *)articles;

//! Receive an error message
- (void)fetchDataError:(NSError *)error;

@end

#pragma mark - <DGArticleFetcher>

/*
 * Class responsible to encapsulate all business rules about fetch and manage the app articles.
 */
@interface DGArticleFetcher : NSObject

#pragma mark - Properties

@property (nonatomic, weak) id<DGArticleFetcherDelegate> delegate;

#pragma mark - Init

//! Initialize and return a new DGArticleFetcher instance with a delegate
- (instancetype)initWithDelegate:(id<DGArticleFetcherDelegate>) delegate;

#pragma mark - Fetch Data

/*
 * Responsible for fetch Articles following these rules:
 *  - If app doesn't have any Article saved into database (SQLite) get all articles from website and save its into into app;
 *  - Get all app and return its to delegate;
 * If reset @param is 'true' all device articles will be erased and refetch them from web again.
 */
- (void)fetchData:(BOOL)reset;

#pragma mark - Utils

//! Return if device has or doesn't have internet/network connection
- (BOOL)hasNetworkConnection;

@end