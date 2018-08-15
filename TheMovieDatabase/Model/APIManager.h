//
//  APIManager.h
//  TheMovieDatabase
//
//  Created by Vladislav Manoylo on 8/14/18.
//  Copyright © 2018 Vladislav Manoylo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIManager : NSObject

+ (APIManager *) sharedInstance;

- (void)getMovieListForPage:(NSInteger)page withCompletion:(void(^)(NSArray* movies, NSError *error))completion;
- (void)getGenresListWithCompletion:(void(^)(void))completion;
- (void)getMovieFromSearchString:(NSString*)searchString withCompletion:(void(^)(NSArray* movies, NSError *error))completion;
@end
