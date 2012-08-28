//
//  SliderViewController.h
//  EPubReader
//
//  Created by Ivan Madrid on 23/08/12.
//  Copyright (c) 2012 David Díaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISliderViewController.h"

@interface SliderViewController : UIViewController

@property (retain, nonatomic) IBOutlet UISlider *pageSlider;
@property (retain, nonatomic) IBOutlet UILabel *pageLabel;
@property(retain , nonatomic) id<ISliderViewController>sliderViewDelegate;


-(void)updateSlider;

@end
