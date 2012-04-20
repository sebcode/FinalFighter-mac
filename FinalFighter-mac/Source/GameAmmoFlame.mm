
#import "GameAmmoFlame.h"
#import "GameLevel.h"

@implementation GameAmmoFlame

- (void)initSprite
{
    sprite = [CCSprite spriteWithSpriteFrameName:@"ammo_flame_0.png"];
    
    if (!animation) {
        NSMutableArray *animFrames = [NSMutableArray arrayWithCapacity:16];
        
        for (int i = 0; i < 16; i++) {
            CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"ammo_flame_%d.png", i]];
            [animFrames addObject:frame];
        }
        
        animation = [[CCAnimation animationWithSpriteFrames:animFrames delay:0.019f] retain];
        animation.restoreOriginalFrame = YES;
    }
    
    [sprite runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]]];
}

- (float)getRestitution
{
    return 0.01;
}

- (float)getMaxAge
{
    return 2.0;
}

- (int)damagePoints
{
    return 10;
}

- (void)playLaunchSound
{
    [[GameSoundPlayer getInstance] play:@"weapon_flame"];
}

- (void)playExplodeSound
{
    /* nope */
}

- (void)contact:(GameObject *)object
{
    if (object.category == catAmmo || object.category == catWall || object.category == catTankSensor) {
        return;
    }
    
    [self destroy];
}

@end
