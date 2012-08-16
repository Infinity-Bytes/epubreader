//
//  IChapterDelegate.h
//  EPubReader
//
//  Created by David Díaz on 09/08/12.
//  Copyright (c) 2012 David Díaz. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ChapterWebDelegate;

@protocol IChapterDelegate <NSObject>
@required
- (void) chapterDidFinishLoad:(ChapterWebDelegate*)chapter;
- (int) getCurrentFontPercentSize;
- (NSString*) getSpinePath;
-(CGRect)getCurrentWindowSize;
@end
