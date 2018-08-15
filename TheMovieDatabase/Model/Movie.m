//
//  Movie.m
//  TheMovieDatabase
//
//  Created by Vladislav Manoylo on 8/14/18.
//  Copyright © 2018 Vladislav Manoylo. All rights reserved.
//

#import "Movie.h"

static NSString *imageURL = @"https://image.tmdb.org/t/p/w342";

@implementation Movie

- (id)initWithDictionary:(NSDictionary*) movieDictionary andWithGenres:(NSArray*)genres{
    
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.nameMovie = [movieDictionary objectForKey:@"title"];
    self.yearMovie =  [Movie yearFromMovieDictionary:movieDictionary];
    self.releaseDate = [Movie dateWithReleaseDateWith:movieDictionary];
    self.ratingMovie = [Movie ratingMovie:movieDictionary];
    self.genreMovie = [Movie genresToStringFrom:genres movieDictionary:movieDictionary];
    self.descriptionText = [movieDictionary objectForKey:@"overview"];

    NSString *posterPath = [movieDictionary objectForKey:@"poster_path"];
    if ([posterPath isKindOfClass:[NSString class]]) {
        self.imageUrl = [NSURL URLWithString:[imageURL stringByAppendingString:posterPath]];
    }
    
    return self;
}

#pragma mark - Private methods

+ (NSString*)dateWithReleaseDateWith:(NSDictionary*)movieDictionary {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:[movieDictionary objectForKey:@"release_date"]];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    NSString *dateee = [dateFormatter stringFromDate:date];
    
    return dateee;
}

+ (NSString*) ratingMovie:(NSDictionary*)movieDictionary {
    
    NSString *rating = @"0";
    id ratingValue = [movieDictionary objectForKey:@"vote_average"];
    if ([ratingValue isKindOfClass:[NSNumber class]]) {
        rating = [ratingValue stringValue];
    } else if ([ratingValue isKindOfClass:[NSString class]]) {
        rating = ratingValue;
    }
    
    if (rating.length > 3) {
        rating = [rating substringWithRange:NSMakeRange(0, 3)];
    }
    return rating;
}

+ (NSString*) yearFromMovieDictionary:(NSDictionary*)movieDictionary{
    
    NSString *year = movieDictionary[@"release_date"];
    if (year.length >=4) {
        
        NSString *onlyYear = [year substringToIndex:4];
        return onlyYear;
    } else {
        return year;
    }
}

+ (NSString *)genresToStringFrom:(NSArray *)genresList movieDictionary:(NSDictionary *)movieDictionary {
    
    if (nil == genresList) {
        return @"No genre";
    }
    
    NSArray *movieGenresIds = movieDictionary[@"genre_ids"];
    
    NSArray *filteredGenres = [genresList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"id IN %@", movieGenresIds]];
    NSArray *genresNames = [filteredGenres valueForKeyPath:@"name"];
    
    return [genresNames componentsJoinedByString:@", "];
}

@end
