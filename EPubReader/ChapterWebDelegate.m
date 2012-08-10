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


- (void) loadChapterWithWindowSize:(CGRect)theWindowSize fontPercentSize:(int) theFontPercentSize fontFamily:(NSString*)theFontFamily{
	fontPercentSize = theFontPercentSize;
    windowSize = theWindowSize;
	_fontFamily = theFontFamily;
    
    UIWebView* webView = [[UIWebView alloc] initWithFrame:windowSize];
    [webView setDelegate:self];
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:spinePath]];
    [webView loadRequest:urlRequest];
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
	
	
	NSString *insertRule1 = [NSString stringWithFormat:@"addCSSRule('html', 'padding: 0px; height: %fpx; -webkit-column-gap: 0px; -webkit-column-width: %fpx;')", webView.frame.size.height, webView.frame.size.width];
	NSString *insertRule2 = [NSString stringWithFormat:@"addCSSRule('p', 'text-align: justify;')"];
	NSString *setTextSizeRule = [NSString stringWithFormat:@"addCSSRule('body', '-webkit-text-size-adjust: %d%%;')",fontPercentSize];
    NSString *setFontFamilyRule = [NSString stringWithFormat:@"addCSSRule('body', 'font-family:\"%@\" !important;')", _fontFamily];
	NSString *setImageRule = [NSString stringWithFormat:@"addCSSRule('img', 'max-width: %fpx; height:auto;')", webView.frame.size.width *0.75];
	
	[webView stringByEvaluatingJavaScriptFromString:varMySheet];
	
	[webView stringByEvaluatingJavaScriptFromString:addCSSRule];
    
	[webView stringByEvaluatingJavaScriptFromString:insertRule1];
	
	[webView stringByEvaluatingJavaScriptFromString:insertRule2];
	
    [webView stringByEvaluatingJavaScriptFromString:setTextSizeRule];
	
	[webView stringByEvaluatingJavaScriptFromString:setFontFamilyRule];
	
	[webView stringByEvaluatingJavaScriptFromString:setImageRule];
	int totalWidth = [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollWidth"] intValue];
    
	pageCount = (int)((float)totalWidth/webView.bounds.size.width);
    
    [webView dealloc];
    [[self chapterDelegate] chapterDidFinishLoad:self];

}

@end
