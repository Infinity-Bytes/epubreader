//
//  Chapter.h
//  EPubReader
//
//  Created by David Díaz on 09/08/12.
//  Copyright (c) 2012 David Díaz. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Chapter : NSObject

@property(retain,nonatomic)NSString*path;
@property(retain,nonatomic)NSString*title;
@property(retain, nonatomic)NSString*text;
@property(nonatomic)int index;
@end
