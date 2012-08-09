//
//  ChapterWebDelegate.h
//  EPubReader
//
//  Created by David Díaz on 09/08/12.
//  Copyright (c) 2012 David Díaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IChapterDelegate.h"


@interface ChapterWebDelegate : NSObject <UIWebViewDelegate>

@property (nonatomic, readonly) NSString* spinePath;
@property (nonatomic, readonly) NSString* title;
@property (nonatomic, readonly) NSString* text;

@property (nonatomic, readonly) int pageCount;
@property (nonatomic, readonly) int chapterIndex;
@property (nonatomic, readonly) int fontPercentSize;

@property (nonatomic, readonly) CGRect windowSize;
@property(nonatomic,retain) id<IChapterDelegate> chapterDelegate;

- (id) initWithPath:(NSString*)theSpinePath title:(NSString*)theTitle chapterIndex:(int) theIndex;
@end
