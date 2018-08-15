//
//  APIManager.m
//  TheMovieDatabase
//
//  Created by Vladislav Manoylo on 8/14/18.
//  Copyright © 2018 Vladislav Manoylo. All rights reserved.
//

#import "APIManager.h"
#import "AFNetworking.h"

#import "Movie.h"

@interface APIManager ()

@property (nonatomic, strong) NSArray *genres;

@end

@implementation APIManager

static NSString *APIKey = @"1f54bd990f1cdfb230adb312546d765d";
static NSString *BASE_URL = @"https://api.themoviedb.org/3";

+ (APIManager *) sharedInstance {
    
    static APIManager *instance = nil;
    if (instance == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [[APIManager alloc]init];
        });
    }
    return instance;
}

- (void)getMovieListForPage:(NSInteger)page withCompletion:(void(^)(NSArray* movies, NSError *error))completion {
    
    NSString *urlString = [BASE_URL stringByAppendingString:@"/discover/movie"];
    NSString *pageString = [@(page) stringValue];
    NSDictionary *params = @{@"api_key":APIKey, @"page":pageString, @"sort_by":@"popularity.desc"};
    
    [[AFHTTPSessionManager manager] GET:urlString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSArray *results = [responseObject objectForKey:@"results"];
        if ([results isKindOfClass:[NSArray class]]) {
            //Get movie from server responce
            NSArray *movies = [self arrayWithMoviesFromResponceArray:results];
            completion(movies, nil);
        } else {
            NSError *error = [NSError errorWithDomain:@"parse.error" code:1 userInfo:nil];
            completion(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completion(nil, error);
    }];
}

- (void)getGenresListWithCompletion:(void(^)(void))completion {
    
    NSString *urlString = [BASE_URL stringByAppendingString:@"/genre/movie/list"];
    NSDictionary *params = @{@"api_key":APIKey};
    
    [[AFHTTPSessionManager manager] GET:urlString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        //Get all genres from server responce
        [APIManager sharedInstance].genres = [responseObject objectForKey:@"genres"];
        completion();
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        completion();
    }];
}

- (void)getMovieFromSearchString:(NSString*)searchString withCompletion:(void(^)(NSArray* movies, NSError *error))completion {
    
    NSString *urlString = [BASE_URL stringByAppendingString:@"/search/movie"];
    NSDictionary *params = @{@"query":urlString, @"api_key":APIKey};
    
    [[AFHTTPSessionManager manager] GET:urlString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSArray *results = [responseObject objectForKey:@"results"];
        if ([results isKindOfClass:[NSArray class]]) {
            //Get movie from server responce
            NSArray *movies = [self arrayWithMoviesFromResponceArray:results];
            completion(movies, nil);
        } else {
            NSError *error = [NSError errorWithDomain:@"parse.error" code:1 userInfo:nil];
            completion(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completion(nil, error);
    }];
}

- (NSArray*) arrayWithMoviesFromResponceArray:(NSArray*)resultArray {
    
    NSMutableArray *moviesArray = [NSMutableArray new];
    for (NSDictionary* movieDict in resultArray) {
        Movie *movie = [[Movie alloc] initWithDictionary:movieDict andWithGenres:[APIManager sharedInstance].genres];
        [moviesArray addObject:movie];
    }
    return moviesArray;
}
@end
