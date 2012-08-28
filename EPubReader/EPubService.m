//
//  EPubService.m
//  EPubReader
//
//  Created by David Díaz on 09/08/12.
//  Copyright (c) 2012 David Díaz. All rights reserved.
//

#import "EPubService.h"
#import "ZipArchive.h"
#import "Chapter.h"

@implementation EPubService

- (void)dealloc {
	[epubFilePath release];
    [super dealloc];
}

-(void)obtainEPub:(NSString*)path;{
    epubFilePath = path;
    [self parseEpub];
}

- (void) parseEpub{
	[self unzipAndSaveFileNamed:epubFilePath];
    
	NSString* opfPath = [self parseManifestFile];
	[self parseOPF:opfPath];
}


-(void) sendChapters:(NSArray *) chapters{
    
    NSDictionary *userInfo;
    userInfo = [NSDictionary dictionaryWithObject: chapters forKey:@"chapters"];
    
    NSNotification * notification = [NSNotification notificationWithName:@"chapters" object:self userInfo:userInfo];
    
    [[NSNotificationQueue defaultQueue]
     enqueueNotification: notification
     postingStyle:NSPostWhenIdle
     coalesceMask:NSNotificationCoalescingOnName
     forModes:nil];
}


- (void)unzipAndSaveFileNamed:(NSString*)fileName{
	
	ZipArchive* za = [[ZipArchive alloc] init];
    //	NSLog(@"%@", fileName);
    //	NSLog(@"unzipping %@", epubFilePath);
	if( [za UnzipOpenFile:epubFilePath]){
		NSString *strPath=[NSString stringWithFormat:@"%@/UnzippedEpub",[self applicationDocumentsDirectory]];
        //		NSLog(@"%@", strPath);
		//Delete all the previous files
		NSFileManager *filemanager=[[NSFileManager alloc] init];
		if ([filemanager fileExistsAtPath:strPath]) {
			NSError *error;
			[filemanager removeItemAtPath:strPath error:&error];
		}
		[filemanager release];
		filemanager=nil;
		//start unzip
		BOOL ret = [za UnzipFileTo:[NSString stringWithFormat:@"%@/",strPath] overWrite:YES];
		if( NO==ret ){
			// error handler here
			UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error"
														  message:@"Error while unzipping the epub"
														 delegate:self
												cancelButtonTitle:@"OK"
												otherButtonTitles:nil];
			[alert show];
			[alert release];
			alert=nil;
		}
		[za UnzipCloseFile];
	}
	[za release];
}

- (NSString *)applicationDocumentsDirectory {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

- (NSString*) parseManifestFile{
	NSString* manifestFilePath = [NSString stringWithFormat:@"%@/UnzippedEpub/META-INF/container.xml", [self applicationDocumentsDirectory]];
    //	NSLog(@"%@", manifestFilePath);
	NSFileManager *fileManager = [[NSFileManager alloc] init];
	if ([fileManager fileExistsAtPath:manifestFilePath]) {
		//		NSLog(@"Valid epub");
		CXMLDocument* manifestFile = [[[CXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:manifestFilePath] options:0 error:nil] autorelease];
		CXMLNode* opfPath = [manifestFile nodeForXPath:@"//@full-path[1]" error:nil];
        //		NSLog(@"%@", [NSString stringWithFormat:@"%@/UnzippedEpub/%@", [self applicationDocumentsDirectory], [opfPath stringValue]]);
		return [NSString stringWithFormat:@"%@/UnzippedEpub/%@", [self applicationDocumentsDirectory], [opfPath stringValue]];
	} else {
		NSLog(@"ERROR: ePub not Valid");
		return nil;
	}
	[fileManager release];
}

- (void) parseOPF:(NSString*)opfPath{
	CXMLDocument* opfFile = [[CXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:opfPath] options:0 error:nil];
    
	NSArray* itemsArray = [opfFile nodesForXPath:@"//opf:item" namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.idpf.org/2007/opf" forKey:@"opf"] error:nil];
    
    NSString* ncxFileName;
	
    NSMutableDictionary* itemDictionary = [[NSMutableDictionary alloc] init];
	for (CXMLElement* element in itemsArray) {
        
		[itemDictionary setValue:[[element attributeForName:@"href"] stringValue] forKey:[[element attributeForName:@"id"] stringValue]];
        
        if([[[element attributeForName:@"media-type"] stringValue] isEqualToString:@"application/x-dtbncx+xml"]){
            ncxFileName = [[element attributeForName:@"href"] stringValue];
        }
        
        if([[[element attributeForName:@"media-type"] stringValue] isEqualToString:@"application/xhtml+xml"]){
            ncxFileName = [[element attributeForName:@"href"] stringValue];
        }
	}
	
    int lastSlash = [opfPath rangeOfString:@"/" options:NSBackwardsSearch].location;
	NSString* ebookBasePath = [opfPath substringToIndex:(lastSlash +1)];
    CXMLDocument* ncxToc = [[CXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", ebookBasePath, ncxFileName]] options:0 error:nil];
    NSMutableDictionary* titleDictionary = [[NSMutableDictionary alloc] init];
    
    
    for (CXMLElement* element in itemsArray) {
        
        NSString* href = [[element attributeForName:@"href"] stringValue];
        NSString* xpath = [NSString stringWithFormat:@"//ncx:content[@src='%@']/../ncx:navLabel/ncx:text", href];
        NSArray* navPoints = [ncxToc nodesForXPath:xpath namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.daisy.org/z3986/2005/ncx/" forKey:@"ncx"] error:nil];
       
        if([navPoints count]!=0){
            CXMLElement* titleElement = [navPoints objectAtIndex:0];
            [titleDictionary setValue:[titleElement stringValue] forKey:href];
        }
    }
    
	
	NSArray* itemRefsArray = [opfFile nodesForXPath:@"//opf:itemref" namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.idpf.org/2007/opf" forKey:@"opf"] error:nil];

	NSMutableArray* tmpArray = [[NSMutableArray alloc] init];
    int count = 0;
    
	for (CXMLElement* element in itemRefsArray) {
        
        NSString* chapHref = [itemDictionary valueForKey:[[element attributeForName:@"idref"] stringValue]];
        
        Chapter* chapterTmp = [[Chapter alloc] init];
        [chapterTmp setIndex: count++];
        [chapterTmp setPath: [NSString stringWithFormat:@"%@%@", ebookBasePath, chapHref]];
        [chapterTmp setTitle: [titleDictionary valueForKey:chapHref]];
        [tmpArray addObject:chapterTmp];
        [chapterTmp release];
	}
	
	[self sendChapters: tmpArray];
	
	[opfFile release];
	[tmpArray release];
	[ncxToc release];
	[itemDictionary release];
	[titleDictionary release];
}



@end
