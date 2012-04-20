
#import "GameAmmoRocket.h"

@implementation GameAmmoRocket

- (void)initSprite
{
    sprite = [self initSprite2];
}

- (float)getSpeed
{
    return 3.0f;
}

- (float)getRestitution
{
    return 0.0f;
}

- (int)damagePoints
{
    return 30;
}

- (float)getMaxAge
{
    return 1.0;
}

- (CCSprite *)initSprite2
{
    NSMutableArray *animFrames = [NSMutableArray array];
    
    for (int i = 0; i < 9; i++) {
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"ammo_rocket_%d.png", i]];
        [animFrames addObject:frame];
    }
    
    CCSprite *s = [CCSprite spriteWithSpriteFrame:[animFrames objectAtIndex:0]];
    
    CCAnimation *anim = [CCAnimation animationWithSpriteFrames:animFrames delay:0.025f];
    CCAnimate *animate = [CCAnimate actionWithAnimation:anim];
    [s runAction:[CCSequence actions:animate,
                  [CCCallFuncND actionWithTarget:self selector:@selector(cleanupSprite:) data:(void *)s],
                  nil]];
    
    return s;
}

- (void)cleanupSprite:(CCSprite *)aSprite
{
    if (aSprite == sprite) {
        return;
    }
    
    [aSprite removeFromParentAndCleanup:YES];
}

- (void)showExplosion
{
    if (!explodeAnimation) {
        NSMutableArray *animFrames = [NSMutableArray arrayWithCapacity:8];
        
        for (int i = 0; i < 7; i++) {
            CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"explosion_tank_%d.png", i]];
            [animFrames addObject:frame];
        }
        
        explodeAnimation = [[CCAnimation animationWithSpriteFrames:animFrames delay:0.019f] retain];
        explodeAnimation.restoreOriginalFrame = YES;
    }
    
    CCSprite *sprite2 = [CCSprite spriteWithSpriteFrameName:@"explosion_tank_0.png"];
    sprite2.position = sprite.position;
    sprite2.zOrder = 100;
    sprite2.scale = 1.5;
    [layer addChild:sprite2];
    
    [sprite2 runAction:[CCSequence actions:[CCAnimate actionWithAnimation:explodeAnimation],
                        [CCCallFuncND actionWithTarget:self selector:@selector(explodeDone:) data:sprite2],
                        nil]];
}

- (void)playLaunchSound
{
    [[GameSoundPlayer getInstance] play:GameSoundWeaponRocket];
}

- (void)playExplodeSound
{
    [[GameSoundPlayer getInstance] play:GameSoundExplosion];
}

- (float)getLethalAge
{
    return 0.01f;
}

- (void)tick:(ccTime)dt
{
    [super tick:dt];

    if (age >= maxAge && !exploding) {
        [self explode];
    } else {
        age += dt;
    }

    ageInt++;
    
    if (!exploding && ageInt % 1 == 0) {
        CCSprite *s = [self initSprite2];
        s.position = sprite.position;
        s.zOrder = 15;
        [layer addChild:s];
    }
}

- (void)contact:(GameObject *)object
{
    if (object.category == catAmmo || object.category == catTankSensor) {
        return;
    }
    
    [self explode];
}

@end
