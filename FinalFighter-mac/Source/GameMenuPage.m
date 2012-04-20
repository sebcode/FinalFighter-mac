
#import "GameMenuPage.h"
#import "GameMenuItemImage.h"

@implementation GameMenuPage
@synthesize delegate;

- (void)start
{
    /* abstract */
}

- (void)update
{
    /* abstract */
}

- (GameMenuItemImage *)createItemWithImage:(NSString *)aImage selected:(NSString *)aImageSelected selector:(SEL)aSelector
{
    GameMenuItemImage *i;
    
    CCSprite *s1 = [CCSprite spriteWithSpriteFrameName:aImage];
    CCSprite *s2 = [CCSprite spriteWithSpriteFrameName:aImageSelected];
    i = [GameMenuItemImage itemWithNormalSprite:s1 selectedSprite:s2 target:self selector:aSelector];
    i.anchorPoint = ccp(0, 0);
    i.position = ccp(0, 0);
    i.onSelectSelector = @selector(onSelectItem:);
    i.onUnselectSelector = @selector(onUnselectItem:);
    i.selectorTarget = self;
    i.opacity = 150.0f;
    
    return i;
}

- (void)onSelectItem:(id)aSender
{
    [delegate onSelectItem:aSender];
}

- (void)onUnselectItem:(id)aSender
{
    [delegate onUnselectItem:aSender];
}

@end
