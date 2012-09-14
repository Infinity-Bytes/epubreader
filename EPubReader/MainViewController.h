//
//  MainViewController.h
//  EPubReader
//
//  Created by Ivan Madrid on 29/08/12.
//  Copyright (c) 2012 David Díaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISpineArrayManagerDelegate.h"
#import "SearchResult.h"
#import "SearchResultsViewController.h"

@interface MainViewController : UIViewController<UISearchBarDelegate>{
    
    BOOL searching;
    UIPopoverController* searchResultsPopover;
    SearchResult* currentSearchResult;
    SearchResultsViewController* searchResViewController;

}
@property(retain, nonatomic) SearchResultsViewController* searchResViewController;
@property(nonatomic, retain) id<ISpineArrayManagerDelegate>spineArrayDelegate;
@property (nonatomic, retain) SearchResult* currentSearchResult;
@end
