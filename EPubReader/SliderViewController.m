//
//  SliderViewController.m
//  EPubReader
//
//  Created by Ivan Madrid on 23/08/12.
//  Copyright (c) 2012 David Díaz. All rights reserved.
//

#import "SliderViewController.h"

@interface SliderViewController ()

@end

@implementation SliderViewController
@synthesize pageLabel, pageSlider, sliderViewDelegate;

-(void)dealloc{
    
    [pageLabel release];
    [pageSlider release];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

-(void) updateSlider{
    
    if([[self sliderViewDelegate] getTotalPagesCount] >= [[self sliderViewDelegate] getGlobalPageCount]){
        [pageLabel setText:[NSString stringWithFormat:@"%d of %d",[sliderViewDelegate getGlobalPageCount], [[self sliderViewDelegate] getTotalPagesCount] ]];
		[pageSlider setValue:(float)100*(float)[[self sliderViewDelegate] getGlobalPageCount]/(float) [[self sliderViewDelegate] getTotalPagesCount]  animated:YES];
    }
}

- (IBAction) slidingStarted:(id)sender{
    int targetPage = ((pageSlider.value/(float)100)*(float)[sliderViewDelegate getTotalPagesCount] );
    
    if (targetPage==0)
        targetPage++;
    
	[pageLabel setText:[NSString stringWithFormat:@"%d/%d", targetPage, [sliderViewDelegate getTotalPagesCount] ]];
    
}




- (IBAction) slidingEnded:(id)sender{
    int targetPage = (int)((pageSlider.value/(float)100)*(float)[[self sliderViewDelegate] getTotalPagesCount] );
    int pageSum = 0;
	int chapterIndex = 0;
	int pageIndex = 0;
    int mayor = [[[self sliderViewDelegate] getCurrentSpineArray] count];
    
    if (targetPage==0)
        targetPage++;
    
    for(chapterIndex=0; chapterIndex < mayor; chapterIndex++){
        pageSum+=[[[[self sliderViewDelegate] getCurrentSpineArray]  objectAtIndex:chapterIndex] pageCount];
        if(pageSum>=targetPage){
            pageIndex = [[[[self sliderViewDelegate] getCurrentSpineArray]  objectAtIndex:chapterIndex] pageCount] - 1 - pageSum + targetPage;
			break;
        }
    }
    
    chapterIndex = chapterIndex >= mayor ? mayor : chapterIndex;
    //chapterIndex = chapterIndex < 0 ? 0 : chapterIndex;
    
    [[self sliderViewDelegate]  loadPage:chapterIndex atPageIndex:pageIndex highlightSearchResult:nil];
}

@end
