
#import "GameAmmoGrenade.h"
#import "GameLevel.h"

@implementation GameAmmoGrenade

- (void)initSprite
{
    sprite = [CCSprite spriteWithSpriteFrameName:@"ammo_grenade.png"];
}

- (void)playLaunchSound
{
    [[GameSoundPlayer getInstance] play:GameSoundWeaponGrenade];
}

- (void)playExplodeSound
{
    [[GameSoundPlayer getInstance] play:GameSoundExplosion];
}

- (int)damagePoints
{
    return 20;
}

- (void)ageTimeout
{
    [self explode];
}

- (float)getMaxAge
{
    return 2.0;
}

- (void)contact:(GameObject *)object
{
    if (object.category == catWall || object.category == catAmmo || object.category == catTankSensor) {
        return;
    }

    [self explode];
}

- (void)showExplosion
{
    if (!explodeAnimation) {
        NSMutableArray *animFrames = [NSMutableArray arrayWithCapacity:14];
        
        for (int i = 0; i < 14; i++) {
            CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"explosion_grenade_%d.png", i]];
            [animFrames addObject:frame];
        }
        
        explodeAnimation = [[CCAnimation animationWithSpriteFrames:animFrames delay:0.019f] retain];
    }
    
    CCSprite *sprite2 = [CCSprite spriteWithSpriteFrameName:@"explosion_grenade_0.png"];
    sprite2.position = sprite.position;
    sprite2.zOrder = 100;
    [layer addChild:sprite2];
    
    [sprite2 runAction:[CCSequence actions:[CCAnimate actionWithAnimation:explodeAnimation],
                        [CCCallFuncND actionWithTarget:self selector:@selector(explodeDone:) data:sprite2],
                        nil]];
}

@end
