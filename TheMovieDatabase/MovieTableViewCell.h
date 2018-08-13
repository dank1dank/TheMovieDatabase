//
//  MovieTableViewCell.h
//  TheMovieDatabase
//
//  Created by Vladislav Manoylo on 8/13/18.
//  Copyright © 2018 Vladislav Manoylo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MovieTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameMovieLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearMovieLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingMovieLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionMovieTextView;

@end

NS_ASSUME_NONNULL_END
