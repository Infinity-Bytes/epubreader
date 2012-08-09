
#import <Foundation/Foundation.h>

@interface UIWebView (SearchWebView)

- (NSInteger)highlightAllOccurencesOfString:(NSString*)str;
- (void)removeAllHighlights;
- (void)searchAchor:(NSString*)str;

@end