
#import "GameLevelOverkillz.h"

@implementation GameLevelOverkillz

- (id)initWithLayer:(WorldLayer *)aLayer
{
    self = [super initWithLayer:aLayer];
    if (!self) {
        return self;
    }

    sprite2 = [CCSprite spriteWithFile:@"Ov-0.png"];
    sprite2.anchorPoint = ccp(0, 0);
    sprite2.position = ccp(0, 1452.0f);
    [layer addChild:sprite2];

    sprite3 = [CCSprite spriteWithFile:@"Ov-3.png"];
    sprite3.anchorPoint = ccp(0, 0);
    sprite3.position = ccp(1250.0f, 0);
    [layer addChild:sprite3];

    sprite4 = [CCSprite spriteWithFile:@"Ov-1.png"];
    sprite4.anchorPoint = ccp(0, 0);
    sprite4.position = ccp(1250.0f, 1452.0f);
    [layer addChild:sprite4];
    
#ifdef WIREFRAME
    sprite2.visible = NO;
    sprite3.visible = NO;
    sprite4.visible = NO;
#endif
    
    return self;
}

- (CGSize)getSize
{
    CGSize size;
    size.width = 2500;
    size.height = 1952;
    return size;
}

- (NSString *) getFilename;
{
    return @"Ov-2.png";
}

- (void) createCollisionMap
{
#include "Overkillz.inc"
}

- (void) createItems
{
#include "Overkillz_Items.inc"
}

+ (NSString *)getLabel;
{
    return @"OVERKILLZ";
}

+ (int)menuImageIndex;
{
    return LEVEL_OVERKILLZ_IMAGE_INDEX;
}

@end
