//
//  MasterController.m
//  EPubReader
//
//  Created by David Díaz on 08/08/12.
//  Copyright (c) 2012 David Díaz. All rights reserved.
//

#import "MasterController.h"

@implementation MasterController

@synthesize epubService;
@synthesize webViewDelegate;


-(id) init
{
    self = [super init];
    if(self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createChapters:) name:@"chapters" object:nil];
        
    }
    return self;
}
- (void)dealloc
{
    self.epubService = nil;
    self.webViewDelegate = nil;
    [super dealloc];
}

-(void)obtainEPub:(NSString*)path{
    [[self epubService] obtainEPub:path];
}

-(void) createChapters: (NSNotification *) notificacion{
    NSDictionary *userInfo = [notificacion userInfo];
    [[self webViewDelegate] createChapters: [userInfo objectForKey:@"chapters"]];
}
@end
