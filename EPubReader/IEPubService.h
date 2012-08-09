//
//  IEPubService.h
//  EPubReader
//
//  Created by David Díaz on 09/08/12.
//  Copyright (c) 2012 David Díaz. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IEPubService <NSObject>


-(void)obtainEPub:(NSString*)path;


@end
