//
//  MainViewController.m
//  TheMovieDatabase
//
//  Created by Vladislav Manoylo on 8/13/18.
//  Copyright © 2018 Vladislav Manoylo. All rights reserved.
//

#import "MainViewController.h"
#import "MovieTableViewCell.h"
#import "DetailMovieViewController.h"

#import "Movie.h"
#import "APIManager.h"

#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"

#define kCellId                     @"MovieTableViewCell_ID"
#define kCellHeight 				150
#define kMainToDetailSegueId        @"MainToDetail"

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

//UI
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchMovieSearchBar;

//Data
@property (nonatomic, strong) NSMutableArray *moviesArray;
@property (nonatomic, strong) NSArray *searchArray;
@property (nonatomic, assign) NSInteger page;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.moviesArray = [NSMutableArray new];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:(255/255.f) green:(255/210.f) blue:(0/255.f) alpha:1]};
    
    self.navigationController.navigationBar.barTintColor = [UIColor darkGrayColor];
    self.navigationController.navigationBar.tintColor = [UIColor yellowColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.searchMovieSearchBar.barTintColor = [UIColor redColor];
//    self.searchMovieSearchBar.
    
    //Set page count
    self.page = 1;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak __typeof(self) weakSelf = self;
    //Get genre list
        [[APIManager sharedInstance] getGenresListWithCompletion:^{
            [weakSelf updateMoviesList];
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)updateMoviesList {
    
    __weak __typeof(self) weakSelf = self;
    //Get movie list
    [[APIManager sharedInstance] getMovieListForPage:self.page withCompletion:^(NSArray *movies, NSError *error) {
        if (error) {
            [self showAlertWithError:error];
        } else {
            [weakSelf.moviesArray addObjectsFromArray:movies];
            [weakSelf.tableView reloadData];
        }
    }];
}

- (NSInteger)tableRowsNumber {
    
    if (self.searchArray) {
        return self.searchArray.count;
    }
    return self.moviesArray.count;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //Get movie with search string
    __weak __typeof(self) weakSelf = self;
    [[APIManager sharedInstance] getMovieFromSearchString:searchBar.text withCompletion:^(NSArray *movies, NSError *error) {
        
        if (error) {
            [self showAlertWithError:error];
        } else {
            weakSelf.searchArray = [movies mutableCopy];
            [weakSelf.tableView reloadData];
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        }
    }];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

    if (searchText.length < 1) {
        self.searchArray = nil;
        [self.tableView reloadData];
        self.tableView.contentOffset = CGPointZero;
    }
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self tableRowsNumber];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kCellHeight;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    MovieTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellId];

    Movie *movie = nil == self.searchArray ? self.moviesArray[indexPath.row] : self.searchArray[indexPath.row];
    
    [cell.posterImageView sd_setImageWithURL:movie.imageUrl placeholderImage:[UIImage imageNamed:@"defaultPoster"]];
    cell.nameMovieLabel.text = movie.nameMovie;
    cell.yearMovieLabel.text = movie.yearMovie;
    cell.ratingMovieLabel.text = movie.ratingMovie;
    cell.genreMovieLabel.text = movie.genreMovie;
    
    [cell.descriptionMovieTextView setText:movie.descriptionText];
    cell.descriptionMovieTextView.contentOffset = CGPointZero;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Movie *movie = nil == self.searchArray ? self.moviesArray[indexPath.row] : self.searchArray[indexPath.row];
    [self performSegueWithIdentifier:kMainToDetailSegueId sender:movie];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (nil == self.searchArray && indexPath.row == [self tableRowsNumber] - 1) {

        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        //Increase page count
        self.page++;
        [self updateMoviesList];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    DetailMovieViewController *controller = segue.destinationViewController;
    controller.movie = sender;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    if ([identifier isEqualToString:kMainToDetailSegueId] && ![sender isKindOfClass:[Movie class]]) {
        return NO;
    }
    return YES;
}

- (void)showAlertWithError:(NSError*)error {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error"
                                                                             message:error.localizedDescription
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                       style:UIAlertActionStyleCancel
                                                     handler:nil];
    [alertController addAction:okAction];
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}

@end
