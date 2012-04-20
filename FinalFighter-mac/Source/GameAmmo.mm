
#import "GameSoundPlayer.h"
#import "GameTank.h"
#import "GameAmmo.h"
#import "GameAmmoGrenade.h"
#import "GameAmmoFlame.h"
#import "GameAmmoRocket.h"
#import "GameAmmoMine.h"
#import "GameUserData.h"

@implementation GameAmmo
@synthesize damagePoints;
@synthesize sender;
@synthesize type;

+ (GameAmmo *)ammoWithPosition:(CGPoint)aPos angle:(float)aAngle type:(GameWeaponType)aType sender:(GameObject *)aSender
{
    switch (aType) {
        case kWeaponGrenade:
            return [[[GameAmmoGrenade alloc] initWithPosition:aPos angle:aAngle type:aType sender:aSender] autorelease];
        case kWeaponFlame:
            return [[[GameAmmoFlame alloc] initWithPosition:aPos angle:aAngle type:aType sender:aSender] autorelease];
        case kWeaponRocket:
            return [[[GameAmmoRocket alloc] initWithPosition:aPos angle:aAngle type:aType sender:aSender] autorelease];
        case kWeaponMine:
            return [[[GameAmmoMine alloc] initWithPosition:aPos angle:aAngle type:aType sender:aSender] autorelease];
        default:
            return [[[GameAmmo alloc] initWithPosition:aPos angle:aAngle type:aType sender:aSender] autorelease];
    }
}

- (id)initWithPosition:(CGPoint)aPos angle:(float)aAngle type:(GameWeaponType)aType sender:(GameObject *)aSender
{
    self = [super initWithLayer:aSender.layer];
    if (!self) {
        return self;
    }
    
    sender = aSender;
    type = aType;
    maxAge = [self getMaxAge];
    lethalAge = [self getLethalAge];
    category = catAmmo;
    
    [self initSprite];
    sprite.position = aPos;
    sprite.zOrder = 15;
    sprite.visible = NO;
    [layer addChild:sprite];

    b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
	bodyDef.userData = [GameUserData userDataWithObject:self];
    bodyDef.linearDamping = [self getDamping];
    bodyDef.angularDamping = [self getDamping];
    bodyDef.bullet = YES;
    bodyDef.position.x = aPos.x / PTM_RATIO;
    bodyDef.position.y = aPos.y / PTM_RATIO;
	body = world->CreateBody(&bodyDef);
    
	b2CircleShape shape;
    shape.m_p.Set(0, 0);
    shape.m_radius = 0.1;
	
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &shape;
	fixtureDef.density = 1.0f;
	fixtureDef.friction = 1.0f;
    fixtureDef.filter.categoryBits = catAmmo;
    fixtureDef.filter.maskBits = catAll & ~catTank & ~catAmmo;
    fixtureDef.restitution = [self getRestitution];
	fixture = body->CreateFixture(&fixtureDef);
    
    float speed = [self getSpeed];
    float a = CC_DEGREES_TO_RADIANS((aAngle * -1) - 90);
    b2Vec2 velocity = speed * b2Vec2(cos(a), sin(a));
    body->ApplyLinearImpulse(velocity, body->GetWorldCenter());
    body->ApplyAngularImpulse(0.5);    
    
    [self playLaunchSound];
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
    
    if (explodeAnimation) {
        [explodeAnimation release];
        explodeAnimation = nil;
    }
    
    if (animation) {
        [animation release];
        animation = nil;
    }
}

- (int)damagePoints
{
    return 5;
}

- (float)getLethalAge
{
    return 0.035f;
}

- (float)getDamping
{
    return 2.0f;
}

- (float)getSpeed
{
    return 1.0f;
}

- (float)getRestitution
{
    return 0.5f;
}

- (float)getMaxAge
{
    return 0.3;
}

- (void)initSprite
{
    sprite = [CCSprite spriteWithSpriteFrameName:@"ammo_minigun.png"];
}

- (void)playLaunchSound
{
    [[GameSoundPlayer getInstance] play:@"weapon_m"];
}

- (void)playExplodeSound
{
    [[GameSoundPlayer getInstance] play:[NSString stringWithFormat:@"weapon_m%li", (random() % 3) + 1]];
}

- (void)showExplosion
{
    if (!explodeAnimation) {
        NSMutableArray *animFrames = [NSMutableArray arrayWithCapacity:8];
        
        for (int i = 0; i < 7; i++) {
            CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"explosion_minigun_%d.png", i]];
            [animFrames addObject:frame];
        }
        
        explodeAnimation = [[CCAnimation animationWithSpriteFrames:animFrames delay:0.019f] retain];
        explodeAnimation.restoreOriginalFrame = YES;
    }

    CCSprite *sprite2 = [CCSprite spriteWithSpriteFrameName:@"explosion_minigun_0.png"];
    sprite2.position = sprite.position;
    sprite2.zOrder = 100;
    [layer addChild:sprite2];
    
    [sprite2 runAction:[CCSequence actions:[CCAnimate actionWithAnimation:explodeAnimation],
                        [CCCallFuncND actionWithTarget:self selector:@selector(explodeDone:) data:sprite2],
                        nil]];
}

- (void)explode
{
    if (exploding) {
        return;
    }
    
    sprite.visible = NO;
    exploding = YES;
    [self showExplosion];
    [self playExplodeSound];
}

- (void)explodeDone:(CCSprite *)aSprite
{
    [aSprite removeFromParentAndCleanup:YES];
    [self destroy];
}

- (void)ageTimeout
{
    [self destroy];
}

- (void)tick:(ccTime)dt
{
    if (!exploding) {
        sprite.position = CGPointMake(body->GetPosition().x * PTM_RATIO, body->GetPosition().y * PTM_RATIO);
        sprite.rotation = -1 * (CC_RADIANS_TO_DEGREES(body->GetAngle()) + 90);
    }
    
    if (age >= maxAge && !exploding) {
        [self ageTimeout];
    } else {
        age += dt;        
    }
    
    if (age >= lethalAge && !isLethal) {
        b2Filter filter;
        filter = fixture->GetFilterData();
        filter.maskBits = [self getMaskBits];
        fixture->SetFilterData(filter);
        sprite.visible = YES;
        isLethal = YES;
    }
}

- (uint16)getMaskBits
{
    return catAll & ~catAmmo;
}

- (void)contact:(GameObject *)object
{
    if (object.category == catAmmo || object.category == catTankSensor) {
        return;
    }
    
    [self explode];
}

- (void)increaseSenderFrags
{
    if (!sender) {
        return;
    }
    
    GameTank *tank = (GameTank *)sender;
    [tank increaseFragsByWeapon:type];
}

@end
