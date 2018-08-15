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

#define kFontSize                           15.f
#define kIsIPad                             UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#define kOffset                             8.f
#define kNavigationBarHeightLandscape       (kIsIPad ? 64.f : 33.f)
#define kImageRatio                         342.f/513.f

@interface DetailMovieViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameMovieLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingMovieLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearMovieLabel;
@property (weak, nonatomic) IBOutlet UILabel *genreMovieLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterMovieImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *posterMovieImageViewX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *posterMovieImageViewHeight;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionTextViewX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionTextViewY;

@end

@implementation DetailMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"The Movie Database";
    
    self.nameMovieLabel.text = self.movie.nameMovie;
    self.ratingMovieLabel.text = [NSString stringWithFormat:@"Rating: %@", self.movie.ratingMovie];
    
    NSString *yearMovieLabelText = [NSString stringWithFormat:@"Release date: %@", self.movie.releaseDate];
    NSMutableAttributedString *yearMovieLabelAttributed = [[NSMutableAttributedString alloc] initWithString:yearMovieLabelText attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:(255.f/255.f) green:(210.f/255.f) blue:(0.f/255.f) alpha:1]}];
    [yearMovieLabelAttributed addAttribute:NSForegroundColorAttributeName value:self.yearMovieLabel.textColor range:[yearMovieLabelText rangeOfString:self.movie.releaseDate]];
    self.yearMovieLabel.attributedText = yearMovieLabelAttributed;
    
    NSString *genreMovieLabelText = [NSString stringWithFormat:@"Genre: %@", self.movie.genreMovie];
    NSMutableAttributedString *genreMovieLabelAttributed = [[NSMutableAttributedString alloc] initWithString:genreMovieLabelText attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:(255.f/255.f) green:(210.f/255.f) blue:(0.f/255.f) alpha:1]}];
    [genreMovieLabelAttributed addAttribute:NSForegroundColorAttributeName value:self.genreMovieLabel.textColor range:[genreMovieLabelText rangeOfString:self.movie.genreMovie]];
    self.genreMovieLabel.attributedText = genreMovieLabelAttributed;
    
    self.descriptionTextView.text = self.movie.descriptionText;
    [self.posterMovieImageView sd_setImageWithURL:self.movie.imageUrl placeholderImage:[UIImage imageNamed:@"defaultPoster"]];
    
    self.descriptionTextView.contentOffset = CGPointZero;
}

- (void)viewLayoutMarginsDidChange {
    
    [super viewLayoutMarginsDidChange];
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    BOOL isLandscape = UIInterfaceOrientationLandscapeLeft == orientation || UIInterfaceOrientationLandscapeRight == orientation || kIsIPad;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    if (isLandscape) {
        
        self.posterMovieImageViewX.constant = kOffset;
        self.posterMovieImageViewHeight.constant = (kIsIPad ? screenSize.height/2 : (screenSize.height - kNavigationBarHeightLandscape - self.posterMovieImageView.frame.origin.y - kOffset));
        self.descriptionTextViewX.constant = self.posterMovieImageViewX.constant + self.posterMovieImageViewHeight.constant*kImageRatio + kOffset;
        self.descriptionTextViewY.constant = kOffset;
    } else {
        
        self.posterMovieImageViewHeight.constant = screenSize.height/3;
        self.posterMovieImageViewX.constant = (screenSize.width - self.posterMovieImageViewHeight.constant*kImageRatio)/2;
        self.descriptionTextViewX.constant = kOffset;
        self.descriptionTextViewY.constant = self.posterMovieImageViewHeight.constant + kOffset;
    }
    self.descriptionTextView.contentOffset = CGPointZero;
}

@end
