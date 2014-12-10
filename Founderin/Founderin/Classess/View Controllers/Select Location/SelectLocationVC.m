//
//  SelectLocationVC.m
//  Founderin
//
//  Created by Neuron on 12/2/14.
//  Copyright (c) 2014 Neuron. All rights reserved.
//

#import "SelectLocationVC.h"
#import "SPGooglePlacesAutocomplete.h"

@interface SelectLocationVC () <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate, UISearchControllerDelegate>
{
    NSArray                             *searchResultPlaces;
    SPGooglePlacesAutocompleteQuery     *searchQuery;
    
    BOOL                                shouldBeginEditing;
}

@end

@implementation SelectLocationVC

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    searchQuery = [[SPGooglePlacesAutocompleteQuery alloc] initWithApiKey:@"AIzaSyAFsaDn7vyI8pS53zBgYRxu0HfRwYqH-9E"];
    shouldBeginEditing = YES;
    
    self.searchDisplayController.searchBar.placeholder = @"Search";
}

#pragma mark - Action Methods
- (IBAction)btnBack_Action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [searchResultPlaces count];
}

- (SPGooglePlacesAutocompletePlace *)placeAtIndexPath:(NSIndexPath *)indexPath
{
    return searchResultPlaces[indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SPGooglePlacesAutocompleteCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.font = Default_Font;
    cell.textLabel.text = [self placeAtIndexPath:indexPath].name;
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *address;
    
    address = [self placeAtIndexPath:indexPath].name;
    if ([self.delegate respondsToSelector:@selector(didSelectLocation:)])
    {
        [self.delegate didSelectLocation:address];
    }

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UISearchDisplayDelegate
- (void)handleSearchForSearchString:(NSString *)searchString
{
    searchQuery.input = searchString;
    [searchQuery fetchPlaces:^(NSArray *places, NSError *error)
    {
        if (error)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not fetch Places" message:error.localizedDescription
                delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            searchResultPlaces = places;
            [self.searchDisplayController.searchResultsTableView reloadData];
        }
    }];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self handleSearchForSearchString:searchString];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

#pragma mark -
#pragma mark UISearchBar Delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (![searchBar isFirstResponder])
    {
        // User tapped the 'clear' button.
        shouldBeginEditing = NO;
        [self.searchDisplayController setActive:NO];
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    if (shouldBeginEditing)
    {
        // Animate in the table view.
        NSTimeInterval animationDuration = 0.3;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:animationDuration];
        self.searchDisplayController.searchResultsTableView.alpha = 0.75;
        [UIView commitAnimations];
        
        [self.searchDisplayController.searchBar setShowsCancelButton:YES animated:YES];
    }
    BOOL boolToReturn = shouldBeginEditing;
    shouldBeginEditing = YES;
    return boolToReturn;
}

#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end