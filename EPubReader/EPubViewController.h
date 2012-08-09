//
//  EPubViewController.h
//  EPubReader
//
//  Created by David Díaz on 08/08/12.
//  Copyright (c) 2012 David Díaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IWebViewDelegate.h"
#import "IEPubDelegate.h"


@interface EPubViewController : UIViewController<IWebViewDelegate>

@property(retain,nonatomic) id<IEPubDelegate> epubDelegate;

@end
