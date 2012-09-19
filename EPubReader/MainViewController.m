//
//  MainViewController.m
//  EPubReader
//
//  Created by Ivan Madrid on 29/08/12.
//  Copyright (c) 2012 David Díaz. All rights reserved.
//

#import "MainViewController.h"
#import "UIViewController+MFSideMenu.h"
#import "SearchResultsViewController.h"
#import "SearchTextViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize spineArrayDelegate, searchResViewController, searchTextDelegate;

-(void)dealloc
{
    
    spineArrayDelegate = nil;
    [searchResViewController release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithTitle:@"Buscar" style:UIBarButtonItemStylePlain target:self action:@selector(showSearchResults:)];
    self.navigationItem.rightBarButtonItem = searchButton;
    _searchButton = searchButton;
    [searchButton release];
    
     [self setupSideMenuBarButtonItem];
    

    
}

-(IBAction)showSearchResults:(id)sender
{
    SearchTextViewController *searchTextViewController = [[SearchTextViewController new] initWithNibName:@"SearchTextViewController" bundle:nil];
    
    [self setSearchTextDelegate:searchResViewController];
    //[searchTextViewController.tableView addSubview:[searchResViewController view]];
    searchTextViewController.tableView = [searchResViewController view];
    
    if(searchResultsPopover==nil){
		searchResultsPopover = [[UIPopoverController alloc] initWithContentViewController:searchTextViewController];
		[searchResultsPopover setPopoverContentSize:CGSizeMake(400, 600)];
        
	}
	
    
    if (![searchResultsPopover isPopoverVisible]) {
		[searchResultsPopover presentPopoverFromRect:searchTextViewController.view.bounds inView:[self view]permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        [searchTextViewController.tableView addSubview:[searchResViewController view]];

	}
    
    

}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
   
    //	NSLog(@"Searching for %@", [searchBar text]);
	if(!searching){
		searching = YES;
		
        
        [searchTextDelegate searchString:[searchBar text]];
        [searchBar resignFirstResponder];
        
    }

    
}

-(void) setSearching:(BOOL)value{
    
    searching = value;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return interfaceOrientation == UIInterfaceOrientationPortrait;
}

@end
