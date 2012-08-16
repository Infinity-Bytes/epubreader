//
//  SearchResultsViewController.h
//  AePubReader
//
//  Created by Federico Frappi on 05/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISpineArrayManagerDelegate.h"
#import "IChapterDelegate.h"


@interface SearchResultsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate> {
    UITableView* resultsTableView;
    NSMutableArray* results;
   
    
    int currentChapterIndex;
    NSString* currentQuery;
}

@property (nonatomic, retain) IBOutlet UITableView* resultsTableView;
@property (nonatomic, retain) NSMutableArray* results;
@property (nonatomic, retain) NSString* currentQuery;
@property(nonatomic, assign) id<ISpineArrayManagerDelegate> spineArrayManagerDelegate;
@property(nonatomic, assign) id<IChapterDelegate> chapterDelegate;


- (void) searchString:(NSString*)query;
- (void) searchString:(NSString *)query inChapterAtIndex:(int)index;
@end
