
#import "GameTank.h"
#import "GameLevel.h"
#import "GameItem.h"
#import "GameAmmo.h"
#import "GameSoundPlayer.h"
#import "GameUserData.h"
#import "GameFont.h"

@implementation GameTank
@synthesize armory;
@synthesize moveUp;
@synthesize moveDown;
@synthesize moveLeft;
@synthesize moveRight;
@synthesize fire;
@synthesize deathCount;
@synthesize health;
@synthesize tankIndex;
@synthesize frags;
@synthesize exploding;

- (id)initWithLayer:(WorldLayer *)aLayer tank:(int)aTank
{
    self = [super initWithLayer:aLayer];
    if (!self) {
        return self;
    }
    
    armory = [[GameArmory alloc] init];
    tankIndex = aTank;
    category = catTank;
    
    if (tankIndex == -1 || tankIndex > numTanks - 1) {
        tankIndex = arc4random() % numTanks;
    }
    
    NSString *label = GameTankLabels[aTank];
    NSString *tankShadowFrameName;
    NSString *turretShadowFrameName;
    if ([label hasPrefix:@"Enforcer"]) {
        tankShadowFrameName = @"tank1_shadow_0.png";
        turretShadowFrameName = @"tank1_shadow_1.png";
    } else {
        tankShadowFrameName = @"tank2_shadow_0.png";
        turretShadowFrameName = @"tank2_shadow_1.png";
    }
    
    tankShadowSprite = [CCSprite spriteWithSpriteFrameName:tankShadowFrameName];
    tankShadowSprite.visible = NO;
    tankShadowSprite.anchorPoint = ccp(0.5f, 0.5f);
    tankShadowSprite.opacity = 200.0f;
    [layer addChild:tankShadowSprite z:5];

    turretShadowSprite = [CCSprite spriteWithSpriteFrameName:turretShadowFrameName];
    turretShadowSprite.visible = NO;
    turretShadowSprite.anchorPoint = ccp(0.5f, 0.5f);
    turretShadowSprite.opacity = 200.0f;
    [layer addChild:turretShadowSprite z:6];
    
    sprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"tanks_%d.png", tankIndex]];
    sprite.visible = NO;
    sprite.anchorPoint = ccp(0.5f, 0.5f);
    [layer addChild:sprite z:10];
    
    turretSprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"turrets_%d.png", tankIndex]];
    turretSprite.visible = NO;
    turretSprite.anchorPoint = ccp(0.5f, 0.5f);
    [layer addChild:turretSprite z:20];
    
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.userData = [GameUserData userDataWithObject:self];
    bodyDef.linearDamping = 8.0;
    bodyDef.angularDamping = 10.0;
    body = world->CreateBody(&bodyDef);

    b2CircleShape dynamicBox;
    dynamicBox.m_p.Set(0, 0);
    dynamicBox.m_radius = 0.6;
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &dynamicBox;	
    fixtureDef.density = 1.0f;
    fixtureDef.friction = 0.0f;
    fixtureDef.filter.categoryBits = catTank;
    fixtureDef.restitution = 0.5;
    fixture = body->CreateFixture(&fixtureDef);

    b2Vec2 vertices[4];
    b2PolygonShape p;
    b2FixtureDef fd;
    vertices[0].Set(+ 0.0f, + 0.5f);
    vertices[1].Set(+ 0.0f, - 0.5f);
    vertices[2].Set(+ 2.0f, - 0.5f);
    vertices[3].Set(+ 2.0f, + 0.5f);
    p.Set(vertices, 4);
    fd.shape = &p;
    fd.filter.categoryBits = catTankSensor;
    fd.filter.maskBits = catWall | catTank;
    fd.isSensor = YES;
    body->CreateFixture(&fd);

    vertices[0].Set(+ 0.0f, + 0.5f);
    vertices[1].Set(+ 2.0f, + 0.5f);
    vertices[2].Set(+ 2.0f, + 0.9f);
    vertices[3].Set(+ 0.0f, + 0.9f);
    p.Set(vertices, 4);
    fd.shape = &p;
    fd.filter.categoryBits = catTankSensor;
    fd.filter.maskBits = catWall | catTank;
    fd.isSensor = YES;
    fd.userData = (void *) 1;
    body->CreateFixture(&fd);

    vertices[0].Set(+ 0.0f, - 0.9f);
    vertices[1].Set(+ 2.0f, - 0.9f);
    vertices[2].Set(+ 2.0f, - 0.5f);
    vertices[3].Set(+ 0.0f, - 0.5f);
    p.Set(vertices, 4);
    fd.shape = &p;
    fd.filter.categoryBits = catTankSensor;
    fd.filter.maskBits = catWall | catTank;
    fd.isSensor = YES;
    fd.userData = (void *) 2;
    body->CreateFixture(&fd);

    b2CircleShape c;
    c.m_p.Set(0, 0);
    c.m_radius = 7.0;
    b2FixtureDef fd2;
    fd2.shape = &c;
    fd2.filter.categoryBits = catTankSensor;
    fd2.filter.maskBits = catTank;
    fd2.isSensor = YES;
    fd2.userData = (void *) 3;
    body->CreateFixture(&fd2);

#ifdef SHOW_TANK_HEALTH_LABEL
    healthLabel = [CCLabelBMFont labelWithString:@"" fntFile:GameFontDefault];
    healthLabel.opacity = 200;
    healthLabel.scale = 1.0;
    [layer addChild:healthLabel z:30];
#endif

    return self;
}

- (void)dealloc
{
    [armory release];
    armory = nil;
    
    if (explodeAnimation) {
        [explodeAnimation release];
        explodeAnimation = nil;
    }
    
    [super dealloc];
}

- (void)showExplosion
{
    if (!explodeAnimation) {
        NSMutableArray *animFrames = [NSMutableArray arrayWithCapacity:30];
        
        for (int i = 0; i < 30; i++) {
            CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"explosion_tank_%d.png", i]];
            [animFrames addObject:frame];
        }
        
        explodeAnimation = [[CCAnimation animationWithSpriteFrames:animFrames delay:0.019f] retain];
    }
    
    CCSprite *sprite2 = [CCSprite spriteWithSpriteFrameName:@"explosion_tank_0.png"];
    sprite2.position = sprite.position;
    sprite2.zOrder = 100;
    sprite2.scale = 1.5;
    [layer addChild:sprite2];
    
    [sprite2 runAction:[
                        CCSequence actions:[CCAnimate actionWithAnimation:explodeAnimation],
                        [CCCallBlock actionWithBlock:^{
                            sprite2.visible = NO;
                            /* koerper kurz aus dem weg raeumen */
                            b2Vec2 pos;
                            pos.x = -10000 / PTM_RATIO;
                            pos.y = -10000 / PTM_RATIO;
                            body->SetTransform(pos, 0);
                        }],
                        [CCDelayTime actionWithDuration:1.5f],
                        [CCCallFuncND actionWithTarget:self selector:@selector(explodeDone:) data:sprite2],
                        nil]];
}

- (void)explode
{
    if (exploding) {
        return;
    }
    
    sprite.visible = NO;
    turretSprite.visible = NO;
    tankShadowSprite.visible = NO;
    turretShadowSprite.visible = NO;
    exploding = YES;
    [self showExplosion];
    [[GameSoundPlayer getInstance] play:GameSoundExplosion];
}

- (void)explodeDone:(CCSprite *)aSprite
{
    [aSprite removeFromParentAndCleanup:YES];
    
    [self reset];
}

- (void)tick:(ccTime)dt
{
    sprite.position = CGPointMake(body->GetPosition().x * PTM_RATIO, body->GetPosition().y * PTM_RATIO);
    sprite.rotation = -1 * (CC_RADIANS_TO_DEGREES(body->GetAngle()) + 90);
    turretSprite.position = CGPointMake(body->GetPosition().x * PTM_RATIO, body->GetPosition().y * PTM_RATIO);
    
    tankShadowSprite.position = sprite.position;
    tankShadowSprite.rotation = sprite.rotation;
    turretShadowSprite.position = turretSprite.position;
    
#ifdef SHOW_TANK_HEALTH_LABEL
    if (healthLabel) {
        healthLabel.position = sprite.position;
        healthLabel.string = [NSString stringWithFormat:@"%i", health];        
    }
#endif
    
    if (exploding) {
        return;
    }
    
    if (moveUp) {
        float a = body->GetAngle();
        float speed = 60.0f * dt;
        b2Vec2 velocity = speed * b2Vec2(cos(a), sin(a));
        body->ApplyLinearImpulse(velocity, body->GetWorldCenter());
    }
    
    if (moveDown) {
        float a = body->GetAngle();
        float speed = 60.0f * dt;
        b2Vec2 velocity = speed * b2Vec2(cos(a), sin(a));
        body->ApplyLinearImpulse(- velocity, body->GetWorldCenter());
    }
    
    if (moveLeft) {
        [self moveLeftImpulse:dt];
    }
    
    if (moveRight) {
        [self moveRightImpulse:dt];
    }
    
    if (fire) {
        [self doFire];
    }
    
    if (fireDelay > 0) {
        fireDelay -= dt;
    }
}

- (void)moveLeftImpulse:(ccTime)dt
{
    body->ApplyAngularImpulse(dt * 12.0f);
}

- (void)moveRightImpulse:(ccTime)dt
{
    body->ApplyAngularImpulse(- (dt * 12.0f));
}

- (void)reset
{
    [armory reset];
    GameStartCoords *c = [layer.level.startCoordsManager get];
    [self resetWithStartCoords:c];
}

- (void)resetWithStartCoords:(GameStartCoords *)c
{
    health = 100;
    sprite.visible = YES;
    turretSprite.visible = YES;
    tankShadowSprite.visible = YES;
    turretShadowSprite.visible = YES;
    exploding = NO;
    
    b2Vec2 pos;
    pos.x = c.x / PTM_RATIO;
    pos.y = c.y / PTM_RATIO;
    body->SetTransform(pos, CC_DEGREES_TO_RADIANS(c.rotate));    
}

- (void)consumeItem:(GameItem *)aItem
{
    if (aItem.type == kItemRepair) {
        [self repair];
        return;
    }
    
    [armory consumeItem:aItem.type];
}

- (void)repair
{
    if (health >= 150) {
        return;
    }
    
    health += 50;
    
    if (health >= 150) {
        health = 150;
    }
}

- (void)cheat
{
    health = 999999;
}

- (void)applyDamage:(GameAmmo *)aAmmo
{
    if (exploding) {
        return;
    }

    if (aAmmo.sender == self && aAmmo.type != kWeaponMine) {
        return;
    }
    
    health -= aAmmo.damagePoints;
    
    if (health <= 0) {
        if ([aAmmo.sender isEqual:self]) {
            [self decreaseFrags];
        } else {
            [aAmmo increaseSenderFrags];
        }
        
        deathCount++;
        [self explode];
    } else {
        id a1 = [CCTintTo actionWithDuration:0.1f red:255.0f green:0.0f blue:0.0f];
        id a2 = [CCTintTo actionWithDuration:0.1f red:255.0f green:255.0f blue:255.0f];
        [sprite runAction:[CCSequence actions:a1, a2, nil]];
        id at1 = [CCTintTo actionWithDuration:0.1f red:255.0f green:0.0f blue:0.0f];
        id at2 = [CCTintTo actionWithDuration:0.1f red:255.0f green:255.0f blue:255.0f];
        [turretSprite runAction:[CCSequence actions:at1, at2, nil]];
    }
}

- (BOOL)doFire
{
    GameWeapon *w = armory.selectedWeapon;
    
    if (fireDelay > 0) {
        return NO;
    }
    
    if (![w consumeBullet]) {
        return NO;
    }
    
    /* throwback tank on rocket launch */
    if (w.type == kWeaponRocket) {
        float a = -1 * CC_DEGREES_TO_RADIANS(turretSprite.rotation + 90);
        float speed = 10.0;
        b2Vec2 velocity = speed * b2Vec2(cos(a), sin(a));
        body->ApplyLinearImpulse(- velocity, body->GetWorldCenter());
    }
    
    GameAmmo *a = [GameAmmo ammoWithPosition:sprite.position
                         angle:turretSprite.rotation
                          type:w.type
                        sender:self];
    
    [a retain]; /* wird von destroyqueue abgeraeumt */
    
    if (w.isRelentless) {
        fireDelay = 0.1;
    } else {
        fireDelay = 0.5;
    }
    
    if (!w.hasAmmo) {
        [self.armory selectBestLoadedWeapon];
        fire = NO;
    }
    
    return YES;
}

- (void)nextWeapon
{
    GameWeapon *w = armory.selectedWeapon;
    
    [armory next];
    
    if (w == armory.selectedWeapon) {
        [[GameSoundPlayer getInstance] play:GameSoundWeaponChangeEmpty];
        return;
    }
    
    [[GameSoundPlayer getInstance] play:GameSoundWeaponChange];
}

- (void)prevWeapon
{
    GameWeapon *w = armory.selectedWeapon;
    
    [armory prev];
    
    if (w == armory.selectedWeapon) {
        [[GameSoundPlayer getInstance] play:GameSoundWeaponChangeEmpty];
        return;
    }
    
    [[GameSoundPlayer getInstance] play:GameSoundWeaponChange];
}

- (void)sensorContact:(GameObject *)aObject begin:(BOOL)aBegin fixture:(b2Fixture *)aFixture
{
    /* abstract */
    //NSLog(@"contact with %@ begin:%i", [aObject className], aBegin);
}

- (void)contact:(GameObject *)aObject
{
    if (aObject.category == catItem) {
        [self consumeItem:(GameItem *)aObject];
    } else if (aObject.category == catAmmo) {
        GameAmmo *ammo = (GameAmmo *)aObject;
        [self applyDamage:ammo];
    }
}

- (void)increaseFragsByWeapon:(GameWeaponType)aType
{
    frags++;
    
    [layer.hudLayer updatePlayersList];
    
    [layer checkFragLimit:self];
}

- (void)decreaseFrags
{
    frags--;
    
    [layer.hudLayer updatePlayersList];
}

@end
