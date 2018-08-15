//
//  Movie.h
//  TheMovieDatabase
//
//  Created by Vladislav Manoylo on 8/14/18.
//  Copyright © 2018 Vladislav Manoylo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Movie : NSObject

@property (strong, nonatomic) NSString *nameMovie;
@property (strong, nonatomic) NSString *ratingMovie;
@property (strong, nonatomic) NSString *yearMovie;
@property (strong, nonatomic) NSString *genreMovie;
@property (strong, nonatomic) NSString *descriptionText;
@property (strong, nonatomic) NSDate *releaseDate;
@property (strong, nonatomic) NSURL *imageUrl;

- (id)initWithDictionary:(NSDictionary*) movieDictionary andWithGenres:(NSArray*)genres;

@end

