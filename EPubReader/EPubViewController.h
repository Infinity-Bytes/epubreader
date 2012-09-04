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
#import "SearchResultsViewController.h"
#import "ISpineArrayManagerDelegate.h"
#import "ISliderViewController.h"
#import "SliderViewController.h"
#import "KSPopoverView/KSPopoverView.h"

@class FontView;

@interface EPubViewController : UIViewController<IWebViewDelegate, IChapterDelegate, UIWebViewDelegate, ISpineArrayManagerDelegate, UISearchBarDelegate, IEPubDelegate, ISliderViewController, KSPopoverViewDelegate>{
    
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
    UIPopoverController* searchResultsPopover;
    UIPopoverController *fontPopover;
 
    FontView *fontView;
    
    UIBarButtonItem* fontListButton;
    
    SearchResult* currentSearchResult;
    
    SearchResultsViewController* searchResViewController;
    
    SliderViewController *slider;
    
    KSPopoverView *_menu;
  

    }


@property(retain,nonatomic) id<IEPubDelegate> epubDelegate;
@property(retain, nonatomic) SliderViewController* sliderDelegate;
@property(retain,nonatomic) NSArray* spineArray;
@property (nonatomic, retain) SearchResult* currentSearchResult;

@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (retain, nonatomic) IBOutlet UIView *sliderView;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *chapterListButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *fontListButton;
@property(nonatomic, retain)  UIBarButtonItem *btnSave; 

-(void)changeFont:(NSString*)fontName;

@end
