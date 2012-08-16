//
//  FontView.m
//  AePubReader
//
//  Created by Edgar Garcia on 14/04/12.
//  Copyright (c) 2012 Blend. All rights reserved.
//

#import "FontView.h"


@implementation FontView

@synthesize fontName;
@synthesize epubViewController;
@synthesize fontSize;

-(void)dealloc{
    
    fontName = nil;
    
    [super dealloc];
}
-(void)resetButtons {
	NSArray *buttons = [NSArray arrayWithObjects: fontNameBt1, fontNameBt2, fontNameBt3, fontNameBt4, nil];
	
	for(UIButton *bt in buttons) {
	
		
		[bt setTitleColor:[UIColor colorWithRed:0.196 green:0.310 blue:0.522 alpha:1.000] forState:UIControlStateNormal];
		
		if([bt.titleLabel.text isEqualToString:self.fontName]) {
			[bt setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
		}
	}
	

}




-(IBAction)fontNameAction:(id)sender{

    
	if ([self.epubViewController getPaginating]) {
		return;
	}
     
	//if(!paginating){
	
	UIButton *bt = (UIButton*)sender;
	
	self.fontName = bt.titleLabel.text;
	[self resetButtons];
	[self.epubViewController changeFont:self.fontName];
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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
