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
#import "FontView.h"
#import "MFSideMenu.h"
#import "SliderViewController.h"

@implementation EPubViewController

@synthesize epubDelegate;
@synthesize sliderDelegate;
@synthesize webView;
@synthesize chapterListButton;
@synthesize fontListButton;
@synthesize spineArray;
@synthesize toolbar;
@synthesize sliderView;
@synthesize btnSave;
int count = 0;



- (void)dealloc
{
    self.epubDelegate = nil;
    [currentFontText release];
    
    [webView release];
    [chapterListButton release];
    [fontListButton release];
    [spineArray release];
    [toolbar release];
    [sliderView release];
    [btnSave release];


       [super dealloc];
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
        
                
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [webView setDelegate:self];
    
    webView.opaque = NO;

    // Creating the UISearchBar and adding it to the
	// UINavigationController
    
    /*
	UISearchBar *theSearchBar = [[UISearchBar alloc]
                                 initWithFrame:CGRectMake(0.0f,0.0f,320.0f,0.0f)];
	[theSearchBar sizeToFit];
	self.navigationItem.titleView = theSearchBar;
	self.navigationItem.titleView.autoresizingMask =
    UIViewAutoresizingFlexibleWidth;
	[theSearchBar release];
   */


    UIImage *image = [UIImage imageNamed:@"icono_fuente_m.gif"];
	_menu = [[KSPopoverView alloc] initWithType:KSPopoverTypeOnOffLabel
										  image:image
										  point:CGPointMake(688.0f, 930.0f)];
	_menu.delegate = self;
	_menu.position = KSPopoverPositionTopCenter;
    _menu.offset = 50;
	//_menu.debug = YES;
	[self.view addSubview:_menu];
    
	[_menu addButtonWithTitle:@"Helvetica"];
	[_menu addButtonWithTitle:@"Arial"];
	[_menu addButtonWithTitle:@"Times New Roman"];
	[_menu addButtonWithTitle:@"Palatino"];


    
    
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

    
    UIPinchGestureRecognizer *pinchRecognizer =
    [[UIPinchGestureRecognizer alloc]
     initWithTarget:self
     action:@selector(pinchDetected:)];
    
    [webView addGestureRecognizer:pinchRecognizer];
	
	[webView addGestureRecognizer:rightSwipeRecognizer];
	[webView addGestureRecognizer:leftSwipeRecognizer];
    
    [pinchRecognizer release];
    
    [epubDelegate obtainEPub : [[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"vhugo" ofType:@"epub"]] path]];
    
        
    slider = [[SliderViewController alloc] initWithNibName:@"SliderViewController" bundle:nil];
    [slider setSliderViewDelegate:self];
    
    [ sliderView addSubview:[slider view]];

   
    [[slider pageLabel ] setAlpha:0];
    [[slider pageSlider ] setAlpha:0];
    

    
}

#pragma mark -
- (void)popoverView:(KSPopoverView *)view selectedButtonIndex:(NSInteger)buttonIndex
           withInfo:(NSDictionary *)info {
    NSLog(@"Pushed %dth button. info:%@", buttonIndex, info);
	KSPopoverViewButtonBase *button = [view labelAtIndex:buttonIndex];
    
    [fontView setFontName:currentFontText];
    [fontView setFontSize:currentTextSize];
    
    [self changeFont:button.text];
        
        

}

-(IBAction)showChapterList:(id)sender{
    NSLog(@"Show Chapter List");
    [self toggleSideMenuPressed:nil];
}

- (IBAction)pinchDetected:(UIGestureRecognizer *)sender {
    

    CGFloat scale = 
    [(UIPinchGestureRecognizer *)sender scale];
    CGFloat velocity =
    [(UIPinchGestureRecognizer *)sender velocity];
    
    NSString *resultString = [[NSString alloc] initWithFormat:
                              @"Pinch - scale = %f, velocity = %f",
                              scale, velocity];
    NSLog(@"%@", resultString);
    [resultString release];
    
    if(velocity < 0){
        /*
        if (paginating) {
            return;
        }
        */
        if(currentTextSize-2>=80){
			currentTextSize-=2;
            NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'",
                                  currentTextSize];
            [webView stringByEvaluatingJavaScriptFromString:jsString];
            [jsString release];
			
		}
        
        
    }else{
        
        if(currentTextSize+2<=200){
			currentTextSize+=2;
            NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'",
                                  currentTextSize];
            [webView stringByEvaluatingJavaScriptFromString:jsString];
            [jsString release];
		}
    }
    
    if(UIGestureRecognizerStateEnded == [sender state]){
        // do something
        
        [self updatePagination];
    }
    
    
}

- (IBAction) fontClicked:(id)sender{
    
      
	if (fontPopover == nil) {
		
		if (fontView == nil) {
			fontView = [[FontView alloc] initWithNibName:@"FontView" bundle:nil];
            [fontView setEpubViewController:self];
		}
		
		fontPopover = [[UIPopoverController alloc] initWithContentViewController:fontView];
		[fontPopover setPopoverContentSize:CGSizeMake(200, 200)]; 
	}
	
	if (![fontPopover isPopoverVisible]) {
        
		[fontView setFontName:currentFontText];
		[fontView setFontSize:currentTextSize];
		[fontView resetButtons];
		
		[fontPopover presentPopoverFromBarButtonItem:fontListButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
}


-(void)changeFontSize:(int)fontSize{
	currentTextSize = fontSize;
	[self updatePagination];
	[self saveConfHTML];
}

-(void)changeFont:(NSString*)fontName{
	
	currentFontText = fontName;
	[self updatePagination];
	[self saveConfHTML];
    
	NSLog(@"la actual fuente %@",currentFontText);
}



- (void)viewDidUnload
{
    [self setWebView:nil];
    
    [super viewDidUnload];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    NSLog(@"interfaceOrientation = %d", interfaceOrientation);
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
    [tmpArray release];
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

- (IBAction) showChapterIndex:(id)sender{
    
    /*
	if(chaptersPopover==nil){
		
        
        ChapterListViewController* chapterListView = [[ChapterListViewController alloc] initWithNibName:@"ChapterListViewController" bundle:[NSBundle mainBundle]];
        [chapterListView setSpineArrayManagerDelegate:self];
		chaptersPopover = [[UIPopoverController alloc] initWithContentViewController:chapterListView];
		[chaptersPopover setPopoverContentSize:CGSizeMake(400, 600)];
		[chapterListView release];
	}
	if ([chaptersPopover isPopoverVisible]) {
		[chaptersPopover dismissPopoverAnimated:YES];
	}else{
		[chaptersPopover presentPopoverFromBarButtonItem:chapterListButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
    */

}



- (void) chapterDidFinishLoad:(ChapterWebDelegate*)chapter{
    
    paginating = NO;
    totalPagesCount+=chapter.pageCount;
    
	if(chapter.chapterIndex + 1 < [ [self spineArray] count])
        [[ [self spineArray] objectAtIndex:chapter.chapterIndex+1] loadChapterWithWindowSize:webView.bounds fontPercentSize:currentTextSize fontFamily:currentFontText];
    else{
       
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.1f];
        [[slider pageSlider] setAlpha:1];
        [[slider pageLabel] setAlpha:1];
        [UIView commitAnimations];
        
        
        
                
        [slider updateSlider];
    }
}

- (void) loadSpine:(int)spineIndex atPageIndex:(int)pageIndex highlightSearchResult:(SearchResult*)theResult{
    
    self.webView.hidden = YES;
	
	//self.currentSearchResult = theResult;
    
	
	NSURL* url = [NSURL fileURLWithPath:[[[self spineArray] objectAtIndex:spineIndex] spinePath]];
	[self.webView loadRequest:[NSURLRequest requestWithURL:url]];
	currentPageInSpineIndex = pageIndex;
	currentSpineIndex = spineIndex;
    
    if(!paginating)
        [slider updateSlider];
    else{
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.1f];
        [[slider pageSlider] setAlpha:0];
        [[slider pageLabel] setAlpha:0];
        [UIView commitAnimations];

    }
    
   
    
}



- (void) updatePagination{
    if(epubLoaded && !paginating)
    {
        paginating = YES;
        totalPagesCount=0;
        
        [self loadSpine:currentSpineIndex atPageIndex:currentPageInSpineIndex  highlightSearchResult:nil];
        
        [[ [self spineArray] objectAtIndex:0] loadChapterWithWindowSize:webView.bounds fontPercentSize:currentTextSize fontFamily:currentFontText];
    }
   
    NSLog(@"spineArrayIndex = %d", currentSpineIndex);

  
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
        [slider updateSlider];
    
	
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
            [self makeTransitionAnimation:type withOrientation: @"fromTop"];
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
    [[[self webView]layer] addAnimation:transition forKey:@"pageCurlAnimation"];
    
   

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

-(NSArray*)getCurrentSpineArray
{
    return self.spineArray;
}


-(EPubViewController*)getSelf{
    
    return self;
}

-(BOOL)getPaginating{
    
    return paginating;
}

-(int)getCurrentSpineIndex{
    
    return currentSpineIndex;
}

-(int)getTotalPagesCount{
    
    return totalPagesCount;
}


@end
