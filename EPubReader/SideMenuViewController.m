//
//  SideMenuViewController.m
//  MFSideMenuDemo
//
//  Created by Michael Frederick on 3/19/12.

#import "SideMenuViewController.h"
#import "MFSideMenu.h"
#import "EPubViewController.h"

@implementation SideMenuViewController

@synthesize spineArrayManagerDelegate, spineArray;

-(void)dealloc{
    
    spineArray = nil;
    [super dealloc];
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
}

- (id) initWithSpineArray:(NSArray*)array {
    if (self = [super init]) {
        
        [self setupSideMenuBarButtonItem];

        self = [[SideMenuViewController alloc] init];
        
        self.spineArray = array;
               }
    
    return self;
}

#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"Capitulos  %d", section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self spineArray]  count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.lineBreakMode = UILineBreakModeMiddleTruncation;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.text = [[self.spineArray objectAtIndex:[indexPath row]] title];
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

    [[self spineArrayManagerDelegate] loadSpine:[indexPath row] atPageIndex:0 highlightSearchResult:nil];

     [MFSideMenuManager sharedManager].navigationController.menuState = MFSideMenuStateHidden;
    
    
}

@end
