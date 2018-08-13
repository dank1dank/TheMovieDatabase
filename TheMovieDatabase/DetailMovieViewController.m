//
//  DetailMovieViewController.m
//  TheMovieDatabase
//
//  Created by Vladislav Manoylo on 8/13/18.
//  Copyright © 2018 Vladislav Manoylo. All rights reserved.
//

#import "DetailMovieViewController.h"

@interface DetailMovieViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameMovieLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingMovieLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearMovieLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterMovieImageView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@end

@implementation DetailMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
