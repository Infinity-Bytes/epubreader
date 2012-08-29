//
//  EPubService.h
//  EPubReader
//
//  Created by David Díaz on 09/08/12.
//  Copyright (c) 2012 David Díaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IEPubService.h"
#import "TouchXML.h"

@interface EPubService : NSObject<IEPubService>
{
	NSString* epubFilePath;
    NSArray* spineArray;
}


- (void) parseEpub;
- (void) unzipAndSaveFile;
- (NSString*) applicationDocumentsDirectory;
- (NSString*) parseManifestFile;
- (void) parseOPF:(NSString*)opfPath;
-(NSArray*) getSpineArray;

@end
