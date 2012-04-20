
#import "GamePlayer.h"
#import "GameLevel.h"
#import "GameItem.h"
#import "GameAmmo.h"
#import "GameSoundPlayer.h"
#import "GameConstants.h"
#import "GameStats.h"
#import "GameItem.h"

@implementation GamePlayer
@synthesize collectStats;
@synthesize statMoveTurret;
@synthesize statMoveUp;
@synthesize statMoveDown;
@synthesize statMoveLeft;
@synthesize statMoveRight;
@synthesize statFire;
@synthesize statCollectGrenade;
@synthesize statCollectFlame;
@synthesize statCollectMine;
@synthesize statCollectRocket;
@synthesize statCollectRepair;
@synthesize canFire;

- (id)initWithLayer:(WorldLayer *)aLayer tank:(int)aTank
{
    self = [super initWithLayer:aLayer tank:aTank];
    if (!self) {
        return self;
    }
    
    NSString *key = [NSString stringWithFormat:@"playTank%@", GameTankLabels[aTank]];
    [[GameStats getInstance] incInt:key];
    
    level = aLayer.level;
    levelSize = [level getSize];
    hudLayer = aLayer.hudLayer;
    
    [hudLayer setHealth:health];
    [hudLayer setWeapon:armory.selectedWeapon];
    
    canFire = YES;
    
    return self;
}

- (id)initWithLayer:(WorldLayer *)aLayer
{
    return [self initWithLayer:aLayer tank:-1];
}

- (BOOL)switchWeapon:(GameWeaponType)aWeaponType
{
    GameWeapon *w = [self.armory getWeapon:aWeaponType];
    
    if (w == nil) {
        return NO;
    }
    
    if (self.armory.selectedWeapon == w) { /* already selected */
        [hudLayer setWeapon:w];
        return NO;
    }
    
    if (![self.armory selectWeapon:w]) {
        [[GameSoundPlayer getInstance] play:GameSoundWeaponChangeEmpty];
        return NO;
    }
    
    [[GameSoundPlayer getInstance] play:GameSoundWeaponChange];
    [hudLayer setWeapon:w];
    
    return YES;
}

- (void)nextWeapon
{
    [super nextWeapon];
    [hudLayer setWeapon:armory.selectedWeapon];
}

- (void)prevWeapon
{
    [super prevWeapon];
    [hudLayer setWeapon:armory.selectedWeapon];
}

- (void)tick:(ccTime)dt
{
    [super tick:dt];
    
    if (exploding) {
        return;
    }
    
    const b2Vec2 pos = body->GetPosition();
    float x = layer.position.x;
    float y = layer.position.y;
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    if (pos.x * PTM_RATIO >= (screenSize.width / 2)
        && pos.x * PTM_RATIO <= levelSize.width - (screenSize.width / 2)) {
        
        x = -1 * pos.x * PTM_RATIO + (screenSize.width / 2);
    } else if (pos.x * PTM_RATIO <= (screenSize.width / 2)) {
        x = 0;
    } else if (pos.x * PTM_RATIO >= levelSize.width - (screenSize.width / 2)) {
        x = -1 * (levelSize.width - screenSize.width);
    }
    
    if (pos.y * PTM_RATIO >= (screenSize.height / 2)
        && pos.y * PTM_RATIO <= levelSize.height - (screenSize.height / 2)) {
        
        y = -1 * pos.y * PTM_RATIO + (screenSize.height / 2);
    } else if (pos.y * PTM_RATIO <= (screenSize.height / 2)) {
        y = 0;
    } else if (pos.y * PTM_RATIO >= levelSize.height - (screenSize.height / 2)) {
        y = -1 * (levelSize.height - screenSize.height);
    }

    [layer setPosition:ccp(x, y)];
    
    if (collectStats) {
        if (moveUp) {
            statMoveUp += dt;
        }        
        if (moveDown) {
            statMoveDown += dt;
        }
        if (moveLeft) {
            statMoveLeft += dt;
        }
        if (moveRight) {
            statMoveRight += dt;
        }
        if (fire) {
            statFire += dt;
        }
    }
}

- (void)moveTurret:(CGPoint)loc
{
    b2Vec2 pos = body->GetPosition();
    
    float x = layer.position.x;
    float y = layer.position.y;
    
    float o = loc.x - (pos.x * PTM_RATIO) - x;
    float a = loc.y - (pos.y * PTM_RATIO) - y;
    float at = (float) CC_RADIANS_TO_DEGREES(atanf(o / a));
    
    if (a < 0) {
        if (o < 0) {
            at = 180 + abs(at);
        } else {
            at = 180 - abs(at);
        }
    }
    
    turretSprite.rotation = at + 180;
    turretShadowSprite.rotation = at + 180;
    
    if (collectStats) {
        statMoveTurret += 1.0f;
    }
}

- (BOOL)doFire
{
    if (!canFire) {
        return NO;
    }
    
    GameWeapon *w = armory.selectedWeapon;
    [hudLayer setWeapon:w];
    
    BOOL ret = [super doFire];

    [hudLayer setWeapon:w];
    return ret;
}

- (void)repair
{
    [super repair];
    [hudLayer setHealth:health];
}

- (void)cheat
{
    [super cheat];
    [hudLayer setHealth:health];
}

- (void)applyDamage:(GameAmmo *)aAmmo
{
    [super applyDamage:aAmmo];
    [hudLayer setHealth:health];
}

- (void)increaseFragsByWeapon:(GameWeaponType)aType
{
    [super increaseFragsByWeapon:aType];
    [hudLayer setFrags:frags];
    [[GameSoundPlayer getInstance] play:GameSoundFrag];
    [[GameStats getInstance] incInt:@"totalFrags"];
    
    NSString *key = [NSString stringWithFormat:@"frag with %@", GameWeaponLabels[aType]];
    [[GameStats getInstance] incInt:key];
    
    [layer incTotalFrags];
    
    if (layer.totalFrags == 1) {
        [[GameStats getInstance] incInt:@"firstBlood"];
    }
    
    if (layer.secondCounter <= 5) {
        [[GameStats getInstance] incInt:@"fastBlood5"];
    }
    if (layer.secondCounter <= 10) {
        [[GameStats getInstance] incInt:@"fastBlood10"];
    }
    
    fragsSinceDeath++;
    
    if (fragsSinceDeath >= 3) {
        [[GameStats getInstance] incInt:@"killingSpree3"];
    }
    if (fragsSinceDeath >= 10) {
        [[GameStats getInstance] incInt:@"killingSpree10"];
    }
    if (fragsSinceDeath >= 15) {
        [[GameStats getInstance] incInt:@"killingSpree15"];
    }
    if (fragsSinceDeath >= 20) {
        [[GameStats getInstance] incInt:@"killingSpree20"];
    }
    if (fragsSinceDeath >= 30) {
        [[GameStats getInstance] incInt:@"killingSpree30"];
    }
}

- (void)decreaseFrags
{
    [super decreaseFrags];
    [hudLayer setFrags:frags];
}

//- (void)sensorContact:(GameObject *)aObject begin:(BOOL)aBegin fixture:(b2Fixture *)aFixture
//{
//    size_t sensorType = (size_t) aFixture->GetUserData();
//    if (sensorType == 4) {
//        NSLog(@"AAA");
//    }
//}

- (void)reset
{
    [super reset];
    
    [hudLayer setHealth:health];
    [armory reset];
    [hudLayer setWeapon:armory.selectedWeapon];
    fragsSinceDeath = 0;
}

- (void)resetStats
{
    statMoveLeft = 0;
    statMoveRight = 0;
    statMoveUp = 0;
    statMoveDown = 0;
    statMoveTurret = 0;
    statFire = 0;
    statCollectGrenade = 0;
    statCollectFlame = 0;
    statCollectRocket = 0;
    statCollectMine = 0;
    statCollectRepair = 0;
}

- (void)consumeItem:(GameItem *)aItem
{    
    [super consumeItem:aItem];
    [[GameSoundPlayer getInstance] play:GameSoundItem];
    
    if ([self switchWeapon:(GameWeaponType)aItem.type]) {
        fire = NO;
    }
    
    [[GameStats getInstance] incInt:[NSString stringWithFormat:@"collect %@", GameItemNames[aItem.type]]];
    
    /* immer fuer achivements zaehlen (auch ohne collectStats) */
    if (aItem.type == statCollectRepair) {
        statCollectRepair++;
    }

    if (collectStats) {
        switch ((GameWeaponType)aItem.type) {
            case kWeaponGrenade: statCollectGrenade++; break;
            case kWeaponFlame: statCollectFlame++; break;
            case kWeaponRocket: statCollectRocket++; break;
            case kWeaponMine: statCollectMine++; break;
            default: break;
        }
    }
}

@end
