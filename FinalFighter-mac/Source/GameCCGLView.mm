
#import "GameCCGLView.h"

@implementation GameCCGLView

- (void)resetCursorRects
{
    NSCursor *aCursor = [NSCursor crosshairCursor];
    [self addCursorRect:[self visibleRect] cursor:aCursor];
    [aCursor setOnMouseEntered:YES];
}

@end
