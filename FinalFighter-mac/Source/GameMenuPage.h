
#import "cocos2d.h"
#import "MenuLayer.h"

@interface GameMenuPage : CCNode
{
    MenuLayer *delegate;
}

- (void)start;
- (void)update;
- (GameMenuItemImage *)createItemWithImage:(NSString *)aImage selected:(NSString *)aImageSelected selector:(SEL)aSelector;

@property (assign) MenuLayer *delegate;

@end
