
#import "GameMenu.h"
#import "GameMenuItemImage.h"
#import "GameSoundPlayer.h"

@implementation GameMenu

/* kopie vom original, weil original-methode nicht exportiert wird */
- (CCMenuItem *)itemForMouseEvent:(NSEvent *)event
{
	CGPoint location = [[CCDirector sharedDirector] convertEventToGL:event];
    
	CCMenuItem* item;
	CCARRAY_FOREACH(children_, item){
		// ignore invisible and disabled items: issue #779, #866
		if ( [item visible] && [item isEnabled] ) {
            
			CGPoint local = [item convertToNodeSpace:location];
            
			CGRect r = [item rect];
			r.origin = CGPointZero;
            
			if( CGRectContainsPoint( r, local ) )
				return item;
		}
	}
	return nil;
}

/* unterschied zum original: item nicht selecten, das macht ccMouseMoved */
- (BOOL)ccMouseDown:(NSEvent *)event
{
    if (!visible_ || !enabled_) {
        return NO;
    }
    
	selectedItem_ = [self itemForMouseEvent:event];
    
    if (selectedItem_) {
        state_ = kCCMenuStateTrackingTouch;
        return YES;
    }
    
    return NO;
}

/* unterschied zum original: item nicht unselecten, das macht ccMouseMoved */
- (BOOL)ccMouseUp:(NSEvent *)event
{
    if (!visible_ || !enabled_) {
        return NO;
    }
   
    if (state_ == kCCMenuStateTrackingTouch) {
        if (selectedItem_) {
            [[GameSoundPlayer getInstance] play:@"menu_click"];
            [selectedItem_ activate];
        }
        state_ = kCCMenuStateWaiting;
        
        return YES;
    }
    
    return NO;
}

/* neu */
- (BOOL)ccMouseMoved:(NSEvent *)event
{
    if (!visible_ || !enabled_) {
        return NO;
    }
    
    GameMenuItemImage *s = (GameMenuItemImage *) [self itemForMouseEvent:event];

    if (s == selectedItem_) {
        return NO;
    }
        
    if (!s) {
        if (selectedItem_) {
            [selectedItem_ unselected];
            selectedItem_ = nil;
        }

        return NO;
    }

    if (selectedItem_) {
        [selectedItem_ unselected];
        selectedItem_ = nil;
    }
    
    selectedItem_ = s;
    [selectedItem_ selected];
        
    return NO;
}

@end
