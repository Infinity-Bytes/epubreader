//
//  ChapterListDelegate.h
//  EPubReader
//
//  Created by Ivan Madrid on 13/08/12.
//  Copyright (c) 2012 David Díaz. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EPubViewController;

@protocol ChapterListDelegate <NSObject>
@required

@property(nonatomic, assign) NSArray *spineArray;

@end
