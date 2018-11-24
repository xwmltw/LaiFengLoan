

#import <UIKit/UIKit.h>

@interface UITextField (ExtendRange)

- (NSRange)selectedRange;

- (void)setSelectedRange:(NSRange)range;

@end
