//
//  IEPubDelegate.h
//  EPubReader
//
//  Created by David Díaz on 09/08/12.
//  Copyright (c) 2012 David Díaz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EPubViewController;

@protocol IEPubDelegate <NSObject>

-(void) obtainEPub: (NSString*)path;
-(EPubViewController*)getSelf;
-(int)getCurrentSpineIndex;
@end
