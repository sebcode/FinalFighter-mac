
#import "GameDecoration.h"

@implementation GameDecoration

- (id)initWithPosition:(CGPoint)pos type:(GameDecorationType)aType layer:(WorldLayer *)aLayer
{
    self = [super initWithLayer:aLayer];
    if (!self) {
        return self;
    }
    
    sprite = [CCSprite spriteWithSpriteFrameName:GameDecorationSprites[aType]];
    sprite.position = pos;
    sprite.zOrder = 100;
    [layer addChild:sprite];
    
    return self;
}

@end
