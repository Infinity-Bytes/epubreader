//
//  HomeViewController.h
//  EPubReader
//
//  Created by Ivan Madrid on 10/09/12.
//  Copyright (c) 2012 David Díaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@interface HomeViewController : UIViewController<iCarouselDataSource, iCarouselDelegate>


@property (nonatomic, retain) IBOutlet iCarousel *carousel;

@end
