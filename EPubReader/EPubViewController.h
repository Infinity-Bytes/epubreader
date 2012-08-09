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


@interface EPubViewController : UIViewController<IWebViewDelegate, IChapterDelegate, UIWebViewDelegate>{
    
    int currentSpineIndex;
	int currentPageInSpineIndex;
	int pagesInCurrentSpineCount;
	int currentTextSize;
	int totalPagesCount;
    NSString *currentFontText;
    
    BOOL epubLoaded;
    BOOL paginating;
    BOOL searching;
}


@property(retain,nonatomic) id<IEPubDelegate> epubDelegate;
@property(retain,nonatomic) NSArray* spineArray;

@property (retain, nonatomic) IBOutlet UIWebView *webView;


@end
