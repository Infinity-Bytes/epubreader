//
//  ISearchTextDelegate.h
//  Editorial Digital
//
//  Created by Ivan Madrid on 18/09/12.
//  Copyright (c) 2012 David Díaz. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ISearchTextDelegate <NSObject>

- (void) searchString:(NSString*)query;

@end
