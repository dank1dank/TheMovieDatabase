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
#define kCellHeight 				150.f
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
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:(255.f/255.f) green:(210.f/255.f) blue:(0.f/255.f) alpha:1]};
    self.navigationController.navigationBar.barTintColor = [UIColor darkGrayColor];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:(255.f/255.f) green:(210.f/255.f) blue:(0.f/255.f) alpha:1];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.searchMovieSearchBar.barTintColor = [UIColor darkGrayColor];
    
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

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
}

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
        [self.searchMovieSearchBar resignFirstResponder];
        self.searchArray = nil;
        [self.tableView reloadData];
        self.tableView.contentOffset = CGPointZero;
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.searchMovieSearchBar.text = nil;
    [self.searchMovieSearchBar resignFirstResponder];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self tableRowsNumber];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kCellHeight;
}

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    MovieTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellId];
    
    Movie *movie = nil == self.searchArray ? self.moviesArray[indexPath.row] : self.searchArray[indexPath.row];
    
    [cell.posterImageView sd_setImageWithURL:movie.imageUrl placeholderImage:[UIImage imageNamed:@"defaultPoster"]];
    cell.nameMovieLabel.text = movie.nameMovie;
    cell.yearMovieLabel.text = movie.yearMovie;
    cell.ratingMovieLabel.text = movie.ratingMovie;
    cell.genreMovieLabel.text = movie.genreMovie;
    cell.descriptionMovieLabel.text = movie.descriptionText;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Movie *movie = nil == self.searchArray ? self.moviesArray[indexPath.row] : self.searchArray[indexPath.row];
    [self performSegueWithIdentifier:kMainToDetailSegueId sender:movie];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.searchMovieSearchBar resignFirstResponder];
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

#pragma mark - Private

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
