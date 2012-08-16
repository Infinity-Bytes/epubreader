//
//  SideMenuViewController.h
//  MFSideMenuDemo
//
//  Created by Michael Frederick on 3/19/12.

#import <UIKit/UIKit.h>
#import "IEPubDelegate.h"

@interface SideMenuViewController : UITableViewController

@property (nonatomic, retain)id<IEPubDelegate>epubDelegate;

@end