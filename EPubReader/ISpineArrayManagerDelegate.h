//
//  ISpineArrayManagerDelegate.h
//  EPubReader
//
//  Created by Ivan Madrid on 13/08/12.
//  Copyright (c) 2012 David Díaz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SearchResult;

@protocol ISpineArrayManagerDelegate <NSObject>


-(NSArray*)getCurrentSpineArray;
-(int)getCurrentTextSize;
-(void) setSearching:(BOOL)value;
- (void) loadSpine:(int)spineIndex atPageIndex:(int)pageIndex highlightSearchResult:(SearchResult*)theResult;
-(void)changeFont:(NSString*)fontName;
-(BOOL)getPaginating;
@end
