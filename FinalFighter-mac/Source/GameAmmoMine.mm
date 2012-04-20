
#import "GameAmmoMine.h"

@implementation GameAmmoMine

- (void)initSprite
{
    sprite = [CCSprite spriteWithSpriteFrameName:@"ammo_mine_0.png"];
    
    if (!animation) {
        NSMutableArray *animFrames = [NSMutableArray arrayWithCapacity:11];
        
        for (int i = 0; i < 11; i++) {
            CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"ammo_mine_%d.png", i]];
            [animFrames addObject:frame];
        }
        
        animation = [[CCAnimation animationWithSpriteFrames:animFrames delay:0.019f] retain];
        animation.restoreOriginalFrame = YES;
    }
    
    [sprite runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]]];
}

- (int)damagePoints
{
    return 30;
}

- (float)getSpeed
{
    return 1.0f;
}

- (float)getMaxAge
{
    return 100.0f;
}

- (float)getDamping
{
    return 10.0f;
}

- (uint16)getMaskBits
{
    return catAll & ~catAmmo;
}

- (void)ageTimeout
{
    [self explode];
}

- (void)playExplodeSound
{
    [[GameSoundPlayer getInstance] play:GameSoundExplosion];
}

- (void)playLaunchSound
{
    [[GameSoundPlayer getInstance] play:GameSoundWeaponGrenade];
}

- (void)contact:(GameObject *)object
{
    if (object.category == catAmmo || object.category == catTankSensor) {
        return;
    }
    
    [self explode];
}

@end
