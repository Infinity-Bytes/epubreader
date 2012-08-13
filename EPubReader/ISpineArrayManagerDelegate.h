//
//  ISpineArrayManagerDelegate.h
//  EPubReader
//
//  Created by Ivan Madrid on 13/08/12.
//  Copyright (c) 2012 David Díaz. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ISpineArrayManagerDelegate <NSObject>

-(NSArray*)getCurrentSpineArray;
- (void) loadSpine:(int)spineIndex atPageIndex:(int)pageIndex highlightSearchResult:(SearchResult*)theResult;

@end
