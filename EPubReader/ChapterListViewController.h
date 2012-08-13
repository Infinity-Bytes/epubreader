//
//  ViewController.h
//  EPubReader
//
//  Created by Ivan Madrid on 10/08/12.
//  Copyright (c) 2012 David Díaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EPubViewController.h"
#import "ISpineArrayManagerDelegate.h"

@interface ChapterListViewController : UITableViewController{
    
}

@property(nonatomic, assign) id<ISpineArrayManagerDelegate> spineArrayManagerDelegate;

@end
