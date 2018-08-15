//
//  DetailMovieViewController.m
//  TheMovieDatabase
//
//  Created by Vladislav Manoylo on 8/13/18.
//  Copyright © 2018 Vladislav Manoylo. All rights reserved.
//

#import "DetailMovieViewController.h"
#import "Movie.h"
#import "UIImageView+WebCache.h"

@interface DetailMovieViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameMovieLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingMovieLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearMovieLabel;
@property (weak, nonatomic) IBOutlet UILabel *genreMovieLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterMovieImageView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@end

@implementation DetailMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"The Movie Database";
    
    self.nameMovieLabel.text = self.movie.nameMovie;
    self.ratingMovieLabel.text = [NSString stringWithFormat:@"Rating: %@", self.movie.ratingMovie];
    self.yearMovieLabel.text = [NSString stringWithFormat:@"Release date: %@", self.movie.releaseDate];
    self.genreMovieLabel.text = [NSString stringWithFormat:@"Genre: %@", self.movie.genreMovie];
    self.descriptionTextView.text = self.movie.descriptionText;
    [self.posterMovieImageView sd_setImageWithURL:self.movie.imageUrl placeholderImage:[UIImage imageNamed:@"defaultPoster"]];
}

@end
