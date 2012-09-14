//
//  SideMenuViewController.h
//  MFSideMenuDemo
//
//  Created by Michael Frederick on 3/19/12.

#import <UIKit/UIKit.h>
#import "ISpineArrayManagerDelegate.h"

@interface SideMenuViewController : UITableViewController{
    

 
}

@property(nonatomic, retain)   NSArray* spineArray;
@property(nonatomic, assign) id<ISpineArrayManagerDelegate> spineArrayManagerDelegate;


- (id) initWithSpineArray:(NSArray*)array;
@end