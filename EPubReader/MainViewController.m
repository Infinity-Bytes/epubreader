//
//  MainViewController.m
//  EPubReader
//
//  Created by Ivan Madrid on 29/08/12.
//  Copyright (c) 2012 David Díaz. All rights reserved.
//

#import "MainViewController.h"
#import "UIViewController+MFSideMenu.h"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize spineArrayDelegate;

-(void)dealloc
{
    
    spineArrayDelegate = nil;
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
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Buscar" style:UIBarButtonItemStylePlain target:self action:@selector(:)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    [anotherButton release];
    
     [self setupSideMenuBarButtonItem];
    

    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    
	if(searchResultsPopover==nil){
		searchResultsPopover = [[UIPopoverController alloc] initWithContentViewController:searchResViewController];
		[searchResultsPopover setPopoverContentSize:CGSizeMake(400, 600)];
        
	}
	if (![searchResultsPopover isPopoverVisible]) {
		[searchResultsPopover presentPopoverFromRect:searchBar.bounds inView:searchBar permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
    //	NSLog(@"Searching for %@", [searchBar text]);
	if(!searching){
		searching = YES;
		[searchResViewController searchString:[searchBar text]];
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
