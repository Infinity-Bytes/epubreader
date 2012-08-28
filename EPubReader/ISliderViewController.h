//
//  ISliderViewController.h
//  EPubReader
//
//  Created by Ivan Madrid on 23/08/12.
//  Copyright (c) 2012 David Díaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchResult.h"

@protocol ISliderViewController <NSObject>

- (int) getGlobalPageCount;
-(int)getTotalPagesCount;
-(NSArray*) getCurrentSpineArray;
- (void) loadPage:(int)spineIndex atPageIndex:(int)pageIndex highlightSearchResult:(SearchResult*)theResult;
-(void)updateSlider; 

@end
