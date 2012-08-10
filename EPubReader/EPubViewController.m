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

- (void)dealloc
{
    self.epubDelegate = nil;
    [currentFontText release];
    
    [webView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	float x = [((UITouch*)[touches anyObject]) locationInView:self.view].x;
	
	if(x < 150){
		//touch to the left
		[self gotoPrevPage];
	}else {
		//touch to the right
		[self gotoNextPage];
	}
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
	
	UISwipeGestureRecognizer* leftSwipeRecognizer = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gotoPrevPage)] autorelease];
	[leftSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
	
	[webView addGestureRecognizer:rightSwipeRecognizer];
	[webView addGestureRecognizer:leftSwipeRecognizer];
    
    [epubDelegate obtainEPub : [[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"vhugo" ofType:@"epub"]] path]];
    
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [super viewDidUnload];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
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


- (void) chapterDidFinishLoad:(ChapterWebDelegate*)chapter{
    totalPagesCount+=chapter.pageCount;
    
	if(chapter.chapterIndex + 1 < [ [self spineArray] count])
        [[ [self spineArray] objectAtIndex:chapter.chapterIndex+1] loadChapterWithWindowSize:webView.bounds fontPercentSize:currentTextSize fontFamily:currentFontText];
	else {
		paginating = NO;
		NSLog(@"Pagination Ended!");
	}

}

- (void) loadSpine:(int)spineIndex atPageIndex:(int)pageIndex highlightSearchResult:(SearchResult*)theResult{
    
    self.webView.hidden = YES;
	
	self.currentSearchResult = theResult;
    
	
	NSURL* url = [NSURL fileURLWithPath:[[[self spineArray] objectAtIndex:spineIndex] spinePath]];
	[self.webView loadRequest:[NSURLRequest requestWithURL:url]];
	currentPageInSpineIndex = pageIndex;
	currentSpineIndex = spineIndex;
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
			CATransition *transition = [CATransition animation];
			[transition setDelegate:self];
			[transition setDuration:0.5f];
			[transition setType:@"pageCurl"];
			[transition setSubtype:@"fromRight"];
			[self.view.layer addAnimation:transition forKey:@"CurlAnim"];
		}
	}
}

- (void) gotoNextPage {
	if(!paginating){
		if(currentPageInSpineIndex+1<pagesInCurrentSpineCount){
			[self gotoPageInCurrentSpine:++currentPageInSpineIndex];
			CATransition *transition = [CATransition animation];
			[transition setDelegate:self];
			[transition setDuration:0.5f];
			[transition setType:@"pageCurl"];
			[transition setSubtype:@"fromRight"];
			[self.view.layer addAnimation:transition forKey:@"CurlAnim"];
		} else {
			[self gotoNextSpine];
		}
	}
}

- (void) gotoPrevPage {
	if (!paginating) {
		if(currentPageInSpineIndex-1>=0){
            
			CATransition *transition = [CATransition animation];
			[transition setDelegate:self];
			[transition setDuration:0.5f];
			[transition setType:@"pageUnCurl"];
			[transition setSubtype:@"fromRight"];
			[self.view.layer addAnimation:transition forKey:@"UnCurlAnim"];
			[self gotoPageInCurrentSpine:--currentPageInSpineIndex];
			
		} else if(currentSpineIndex!=0){
            
				CATransition *transition = [CATransition animation];
				[transition setDelegate:self];
				[transition setDuration:0.5f];
				[transition setType:@"pageUnCurl"];
				[transition setSubtype:@"fromRight"];
				[self.view.layer addAnimation:transition forKey:@"UnCurlAnim"];
				int targetPage = [[ [self spineArray] objectAtIndex:(currentSpineIndex-1)] pageCount];
				[self loadSpine:--currentSpineIndex atPageIndex:targetPage-1 highlightSearchResult:nil];
            
        }
    }
}


@end
