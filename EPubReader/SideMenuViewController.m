//
//  SideMenuViewController.m
//  MFSideMenuDemo
//
//  Created by Michael Frederick on 3/19/12.

#import "SideMenuViewController.h"
#import "MFSideMenu.h"
#import "EPubViewController.h"

@implementation SideMenuViewController

@synthesize spineArrayManagerDelegate;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
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
    return [[self.spineArrayManagerDelegate getCurrentSpineArray] count];

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
    cell.textLabel.text = [[[self.spineArrayManagerDelegate getCurrentSpineArray] objectAtIndex:[indexPath row]] title];
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
     [MFSideMenuManager sharedManager].navigationController.menuState = MFSideMenuStateHidden;
}

@end
