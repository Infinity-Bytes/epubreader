//
//  HomeViewController.m
//  EPubReader
//
//  Created by Ivan Madrid on 10/09/12.
//  Copyright (c) 2012 David Díaz. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()<UIActionSheetDelegate>
@property (nonatomic, retain) NSMutableArray *items;
@end

@implementation HomeViewController
@synthesize carousel;
@synthesize items;

- (void)awakeFromNib
{
    //set up data
    //your carousel should always be driven by an array of
    //data of some kind - don't store data in your item views
    //or the recycling mechanism will destroy your data once
    //your item views move off-screen
    self.items = [NSMutableArray array];
    for (int i = 0; i < 100; i++)
    {
        [items addObject:[NSNumber numberWithInt:i]];
    }
}

- (void)dealloc
{
    //it's a good idea to set these to nil here to avoid
    //sending messages to a deallocated viewcontroller
    //this is true even if your project is using ARC, unless
    //you are targeting iOS 5 as a minimum deployment target
    carousel.delegate = nil;
    carousel.dataSource = nil;
    
    [carousel release];
    [items release];
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
    //configure carousel
    carousel.type = iCarouselTypeCoverFlow;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //self.view.backgroundColor = [UIColor grayColor];

    
  
    // The items to be displayed in the carousel
    items = [NSArray arrayWithObjects:
             
    [UIImage imageNamed:@"vhugo.jpeg"],
             
    [UIImage imageNamed:@"page.png"],
             
    [UIImage imageNamed:@"page.png"],
             
    [UIImage imageNamed:@"page.png"],
             
    [UIImage imageNamed:@"page.png"],
             
    nil];
    
    
    
    // Initialize and configure the carousel

    carousel = [[iCarousel alloc] initWithFrame:self.view.bounds];
    
    carousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    carousel.type = iCarouselTypeRotary;
    
    carousel.dataSource = self;
    
    
    
    [self.view addSubview:carousel];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    //free up memory by releasing subviews
    self.carousel = nil;

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return [items count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    UIImage *image = [items objectAtIndex:index];

    UIButton *button = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)] autorelease];
    
    [button setBackgroundImage:image forState:UIControlStateNormal];

    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
   
    button.titleLabel.font = [button.titleLabel.font fontWithSize:50];
 
    //[button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];

    button.tag=index;

    return button;
}


@end
