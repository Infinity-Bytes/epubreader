//
//  ChapterWebDelegate.m
//  EPubReader
//
//  Created by David Díaz on 09/08/12.
//  Copyright (c) 2012 David Díaz. All rights reserved.
//

#import "ChapterWebDelegate.h"
#import "NSString+HTML.h"

@implementation ChapterWebDelegate

@synthesize spinePath;
@synthesize title;
@synthesize text;

@synthesize pageCount;
@synthesize chapterIndex;
@synthesize fontPercentSize;

@synthesize windowSize;
@synthesize chapterDelegate;

- (void)dealloc
{
    [title release];
	[spinePath release];
	[text release];
    [super dealloc];
}

- (id) initWithPath:(NSString*)theSpinePath title:(NSString*)theTitle chapterIndex:(int) theIndex
{
    self = [super init];
    if(self)
    {
        spinePath = [theSpinePath retain];
        title = [theTitle retain];
        chapterIndex = theIndex;
        
		NSString* html = [[NSString alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:theSpinePath]] encoding:NSUTF8StringEncoding];
        
		text = [[html stringByConvertingHTMLToPlainText] retain];
        
		[html release];
    }
    return self;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"Load");
}

@end
