//
//  EPubViewController.m
//  EPubReader
//
//  Created by David Díaz on 08/08/12.
//  Copyright (c) 2012 David Díaz. All rights reserved.
//

#import "EPubViewController.h"
#import "ChapterWebDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "Chapter.h"

@interface EPubViewController ()

@end

@implementation EPubViewController

@synthesize epubDelegate;
@synthesize webView;
@synthesize pageSlider;
@synthesize pageLabel;
int count = 0;

- (void)dealloc
{
    self.epubDelegate = nil;
    [currentFontText release];
    
    [webView release];
    [pageSlider release];
    [pageLabel release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [webView setDelegate:self];
    
    webView.opaque = NO;
    
	UIScrollView* sv = nil;
	for (UIView* v in  webView.subviews) {
		if([v isKindOfClass:[UIScrollView class]]){
			sv = (UIScrollView*) v;
			sv.scrollEnabled = NO;
			sv.bounces = NO;
		}
	}
    
    currentTextSize = 100;
	currentFontText = @"Times New Roman";
	currentSpineIndex = 0;
    currentPageInSpineIndex = 0;
    
    UISwipeGestureRecognizer* rightSwipeRecognizer = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gotoNextPage)] autorelease];
	[rightSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [rightSwipeRecognizer setNumberOfTouchesRequired: 1];
	
	UISwipeGestureRecognizer* leftSwipeRecognizer = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gotoPrevPage)] autorelease];
	[leftSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [leftSwipeRecognizer setNumberOfTouchesRequired: 1];

	[webView addGestureRecognizer:rightSwipeRecognizer];
	[webView addGestureRecognizer:leftSwipeRecognizer];
    
    [epubDelegate obtainEPub : [[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"vhugo" ofType:@"epub"]] path]];
    
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [self setPageSlider:nil];
    [self setPageLabel:nil];
    [super viewDidUnload];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [self updatePagination];
	return YES;
}



-(void)createChapters: (NSArray *) chapters{
    
    NSMutableArray* tmpArray = [[NSMutableArray alloc] init];

    for(Chapter * chapter in chapters){
        
        ChapterWebDelegate * tmpChapter = [[ChapterWebDelegate alloc] initWithPath: [chapter path] title:[chapter title] chapterIndex:[chapter index]];
        
        [tmpChapter setChapterDelegate: self];
        [tmpArray addObject: tmpChapter];
        [tmpChapter release]; 
    }
     
    [self setSpineArray: tmpArray];
    epubLoaded = YES;
    
    [self loadConfHTML];
    [self updatePagination];
}

- (int) getGlobalPageCount{
	int pageCount = 0;
	for(int i=0; i<currentSpineIndex; i++){
		pageCount+= [[[self spineArray] objectAtIndex:i] pageCount];
	}
	pageCount+=currentPageInSpineIndex+1;
	return pageCount;
}


- (void) chapterDidFinishLoad:(ChapterWebDelegate*)chapter{
    
    paginating = NO;
    totalPagesCount+=chapter.pageCount;
    
	if(chapter.chapterIndex + 1 < [ [self spineArray] count])
        [[ [self spineArray] objectAtIndex:chapter.chapterIndex+1] loadChapterWithWindowSize:webView.bounds fontPercentSize:currentTextSize fontFamily:currentFontText];
	
    
    [self updateSlider];
}

- (void) loadSpine:(int)spineIndex atPageIndex:(int)pageIndex highlightSearchResult:(SearchResult*)theResult{
    
    self.webView.hidden = YES;
	
	self.currentSearchResult = theResult;
    
	
	NSURL* url = [NSURL fileURLWithPath:[[[self spineArray] objectAtIndex:spineIndex] spinePath]];
	[self.webView loadRequest:[NSURLRequest requestWithURL:url]];
	currentPageInSpineIndex = pageIndex;
	currentSpineIndex = spineIndex;
    if(!paginating)
        [self updateSlider];
}



- (void) updatePagination{
    if(epubLoaded && !paginating)
    {
        paginating = YES;
        totalPagesCount=0;
        
        [self loadSpine:currentSpineIndex atPageIndex:currentPageInSpineIndex  highlightSearchResult:nil];
        
        [[ [self spineArray] objectAtIndex:0] loadChapterWithWindowSize:webView.bounds fontPercentSize:currentTextSize fontFamily:currentFontText];
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    NSString *varMySheet = @"var mySheet = document.styleSheets[0];";
	
	NSString *addCSSRule =  @"function addCSSRule(selector, newRule) {"
	"if (mySheet.addRule) {"
	"mySheet.addRule(selector, newRule);"								// For Internet Explorer
	"} else {"
	"ruleIndex = mySheet.cssRules.length;"
	"mySheet.insertRule(selector + '{' + newRule + ';}', ruleIndex);"   // For Firefox, Chrome, etc.
	"}"
	"}";
	
	NSString *insertRule1 = [NSString stringWithFormat:@"addCSSRule('html', 'padding: 0px; height: %fpx; -webkit-column-gap: 0px; -webkit-column-width: %fpx;')", self.webView.frame.size.height, self.webView.frame.size.width];
	NSString *insertRule2 = [NSString stringWithFormat:@"addCSSRule('p', 'text-align: justify;')"];
	NSString *setTextSizeRule = [NSString stringWithFormat:@"addCSSRule('body', '-webkit-text-size-adjust: %d%%;')", currentTextSize];
	NSString *setFontFamilyRule = [NSString stringWithFormat:@"addCSSRule('body', 'font-family:\"%@\" !important;')", currentFontText];
	NSString *setHighlightColorRule = [NSString stringWithFormat:@"addCSSRule('highlight', 'background-color: yellow;')"];
	
	NSString *setImageRule = [NSString stringWithFormat:@"addCSSRule('img', 'max-width: %fpx; height:auto;')", self.webView.frame.size.width *0.75];
    
	
	[ self.webView stringByEvaluatingJavaScriptFromString:varMySheet];
	
	[self.webView stringByEvaluatingJavaScriptFromString:addCSSRule];
    
	[self.webView stringByEvaluatingJavaScriptFromString:insertRule1];
	
	[self.webView stringByEvaluatingJavaScriptFromString:insertRule2];
	
	[self.webView stringByEvaluatingJavaScriptFromString:setTextSizeRule];
	
	[self.webView stringByEvaluatingJavaScriptFromString:setFontFamilyRule];
	
	[self.webView stringByEvaluatingJavaScriptFromString:setHighlightColorRule];
	
	[self.webView stringByEvaluatingJavaScriptFromString:setImageRule];


   	int totalWidth = [[[self webView] stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollWidth"] intValue];
	
	totalWidth = [[[self webView] stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollWidth"] intValue];
	
	if ([self webView].scrollView.contentSize.height != [self webView].frame.size.height) {
		[self loadSpine:currentSpineIndex atPageIndex:currentPageInSpineIndex highlightSearchResult:nil];
	}else {
        
		pagesInCurrentSpineCount = (int)((float)totalWidth/[self webView].bounds.size.width);
		[self gotoPageInCurrentSpine:currentPageInSpineIndex ];
	}

}

- (void) gotoPageInCurrentSpine:(int)pageIndex{
	if(pageIndex>=pagesInCurrentSpineCount){
		pageIndex = pagesInCurrentSpineCount - 1;
		currentPageInSpineIndex = pagesInCurrentSpineCount - 1;
	}
	
	float pageOffset = pageIndex*webView.bounds.size.width;
    
	NSString* goToOffsetFunc = [NSString stringWithFormat:@" function pageScroll(xOffset){ window.scroll(xOffset,0); } "];
	NSString* goTo =[NSString stringWithFormat:@"pageScroll(%f)", pageOffset];
	
	[webView stringByEvaluatingJavaScriptFromString:goToOffsetFunc];
	[webView stringByEvaluatingJavaScriptFromString:goTo];
    
    if(!paginating)
        [self updateSlider];
	
	webView.hidden = NO;
	[self saveConfHTML];
}



-(void)saveConfHTML{
	
	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
	[defs setInteger:currentTextSize forKey:@"fontSize"];
	[defs setObject:currentFontText forKey:@"fontName"];
	[defs setInteger:currentSpineIndex forKey:@"currentSpineIndex"];
	[defs setInteger:currentPageInSpineIndex forKey:@"currentPageInSpineIndex"];
	[defs synchronize];
}


-(void)loadConfHTML{
	
	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
	
	NSString *fName = [defs stringForKey:@"fontName"];
		
	int fSize = [defs integerForKey:@"fontSize"];
    
	int cSpineIndex = [defs integerForKey:@"currentSpineIndex"];
	
	int cPageInSpineIndex = [defs integerForKey:@"currentPageInSpineIndex"];
    
    if(fSize)
		currentTextSize = fSize;
    
    if (fName)
		currentFontText = fName;

    if(cSpineIndex)
		currentSpineIndex = cSpineIndex;
	
	if(cPageInSpineIndex) 
		currentPageInSpineIndex = cPageInSpineIndex;
	
}

- (void) gotoNextSpine {
	if(!paginating){
		if(currentSpineIndex+1<[ [self spineArray] count]){
			[self loadSpine:++currentSpineIndex atPageIndex:0 highlightSearchResult:nil];
            [self validateTransitionAnimation:@"pageCurl"];
		}
	}
}

- (void) gotoNextPage {
	if(!paginating){
		if(currentPageInSpineIndex+1<pagesInCurrentSpineCount)
        {
			[self gotoPageInCurrentSpine:++currentPageInSpineIndex];
			[self validateTransitionAnimation:@"pageCurl"];
		}
        else
			[self gotoNextSpine];
		
	}
}

- (void) gotoPrevPage {
	if (!paginating)
    {
		if(currentPageInSpineIndex-1>=0)
        {
			[self validateTransitionAnimation:@"pageUnCurl"];
			[self gotoPageInCurrentSpine:--currentPageInSpineIndex];
		}
        else if(currentSpineIndex!=0)
        {
            int targetPage = [[ [self spineArray] objectAtIndex:(currentSpineIndex-1)] pageCount];
            [self validateTransitionAnimation:@"pageUnCurl"];
            [self loadSpine:--currentSpineIndex atPageIndex:targetPage-1 highlightSearchResult:nil];
        }
    }
}

-(void) validateTransitionAnimation: (NSString*)type{
    
    
    switch (self.interfaceOrientation) {
        case 4:
            [self makeTransitionAnimation:type withOrientation: @"fromRight"];
            break;
        case 3:
            [self makeTransitionAnimation:type withOrientation: @"fromDown"];
            break;
        case 1:
            [self makeTransitionAnimation:type withOrientation: @"fromRight"];
            break;
        case 2:
            [self makeTransitionAnimation:type withOrientation: @"fromLeft"];
            break;
            
        default:
            break;
    }
    
}

-(void) makeTransitionAnimation: (NSString*)type withOrientation: (NSString*) subtype {

    CATransition *transition = [CATransition animation];
     
    [transition setDelegate:self];
    [transition setDuration:0.5f];
    [transition setType:type];
    [transition setSubtype: subtype];
    [[[self view]layer] addAnimation:transition forKey:@"pageCurlAnimation"];
    
   

}

-(void) updateSlider{
    
    if(totalPagesCount > [self getGlobalPageCount]){
        [pageLabel setText:[NSString stringWithFormat:@"%d of %d",[self getGlobalPageCount], totalPagesCount]];
		[pageSlider setValue:(float)100*(float)[self getGlobalPageCount]/(float)totalPagesCount animated:YES];
    }
}

- (IBAction) slidingStarted:(id)sender{
    int targetPage = ((pageSlider.value/(float)100)*(float)totalPagesCount);
    
    if (targetPage==0)
        targetPage++;
    
	[pageLabel setText:[NSString stringWithFormat:@"%d/%d", targetPage, totalPagesCount]];

}

- (IBAction) slidingEnded:(id)sender{
    int targetPage = (int)((pageSlider.value/(float)100)*(float)totalPagesCount);
    int pageSum = 0;
	int chapterIndex = 0;
	int pageIndex = 0;
    
    if (targetPage==0)
        targetPage++;
    
    for(chapterIndex=0; chapterIndex<[[self spineArray] count]; chapterIndex++){
        
        pageSum+=[[[self spineArray] objectAtIndex:chapterIndex] pageCount];
        if(pageSum>=targetPage){
            pageIndex = [[[self spineArray] objectAtIndex:chapterIndex] pageCount] - 1 - pageSum + targetPage;
			break;
        }
    }
    
    [self loadPage:chapterIndex atPageIndex:pageIndex highlightSearchResult:nil];
}

- (void) loadPage:(int)spineIndex atPageIndex:(int)pageIndex highlightSearchResult:(SearchResult*)theResult{
	
	int dir = 0;
	
    if(spineIndex < currentSpineIndex)
        dir = -1;
    else if(spineIndex > currentSpineIndex)
        dir = 1;
    else if (pageIndex < currentPageInSpineIndex)
        dir = -1;
    else if (pageIndex > currentPageInSpineIndex)
        dir = 1;    
	
	if (dir == 1)
        [self validateTransitionAnimation:@"pageCurl"];
	else if (dir == -1)
        [self validateTransitionAnimation:@"pageUnCurl"];
	
	[self loadSpine:spineIndex atPageIndex:pageIndex highlightSearchResult:theResult];
	
}

@end
