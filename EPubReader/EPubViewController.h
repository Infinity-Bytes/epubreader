//
//  EPubViewController.h
//  EPubReader
//
//  Created by David Díaz on 08/08/12.
//  Copyright (c) 2012 David Díaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IWebViewDelegate.h"
#import "IEPubDelegate.h"
#import "IChapterDelegate.h"
#import "SearchResult.h"
//#import "ChapterListViewController.h"
#import "ISpineArrayManagerDelegate.h"

@interface EPubViewController : UIViewController<IWebViewDelegate, IChapterDelegate, UIWebViewDelegate, ISpineArrayManagerDelegate>{
    
    int currentSpineIndex;
	int currentPageInSpineIndex;
	int pagesInCurrentSpineCount;
	int currentTextSize;
	int totalPagesCount;
    NSString *currentFontText;
    
    BOOL epubLoaded;
    BOOL paginating;
    BOOL searching;
    
    UIPopoverController* chaptersPopover;

   // ChapterListViewController *chapterListView;
}


@property(retain,nonatomic) id<IEPubDelegate> epubDelegate;
@property(retain,nonatomic) NSArray* spineArray;
@property (nonatomic, retain) SearchResult* currentSearchResult;


@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (retain, nonatomic) IBOutlet UISlider *pageSlider;
@property (retain, nonatomic) IBOutlet UILabel *pageLabel;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *chapterListButton;

- (NSArray*)getSpineArray;


@end
