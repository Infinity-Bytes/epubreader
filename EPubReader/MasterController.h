//
//  MasterController.h
//  EPubReader
//
//  Created by David Díaz on 08/08/12.
//  Copyright (c) 2012 David Díaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IWebViewDelegate.h"
#import "IEPubService.h"
#import "IEPubDelegate.h"

@interface MasterController : NSObject<IEPubDelegate>


@property(nonatomic,retain)id<IWebViewDelegate> webViewDelegate;
@property(nonatomic,retain)id<IEPubService> epubService;

@end
