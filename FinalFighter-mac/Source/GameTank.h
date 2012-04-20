
#import "GameObject.h"
#import "GameArmory.h"
#import "GameItem.h"
#import "GameAmmo.h"
#import "GameStartCoordsManager.h"

enum GameTankType {
    GameTankTypeBurning = 0,
    GameTankTypeCapcom = 1,
    GameTankTypeChromicBlue = 2,
    GameTankTypeChromicRed = 3,
    GameTankTypeDragster = 4,
    GameTankTypeEnforcerBlack = 5,
    GameTankTypeEnforcerBlue = 6,
    GameTankTypeEnforcerGreen = 7,
    GameTankTypeEnforcerGrey = 8,
    GameTankTypeEnforcerRed = 9,
    GameTankTypeEnforcerYellow = 10,
    GameTankTypePirateBlack = 11,
    GameTankTypePirateBlue = 12,
    GameTankTypePirateGreen1 = 13,
    GameTankTypePirateGreen2 = 14,
    GameTankTypePirateGrey = 15,
    GameTankTypePirateRed = 16,
    GameTankTypeEnforcerPunisher = 17,
    GameTankTypeRush = 18,
    numTanks = 19
};

static NSString *GameTankLabels[] = {
    @"Enforcer Burning",
    @"Enforcer Capcom",
    @"Enforcer Chromic Blue",
    @"Enforcer Chromic Red",
    @"Enforcer Dragster",
    @"Enforcer Black",
    @"Enforcer Blue",
    @"Enforcer Olive",
    @"Enforcer Grey",
    @"Enforcer Red",
    @"Enforcer Yellow",
    @"Pirate Black",
    @"Pirate Blue",
    @"Pirate Olive",
    @"Pirate Green",
    @"Pirate Grey",
    @"Pirate Red",
    @"Enforcer Punisher",
    @"Enforcer Rush"
};

@interface GameTank : GameObject
{
    CCSprite *turretSprite;
    CCSprite *tankShadowSprite;
    CCSprite *turretShadowSprite;
    GameArmory *armory;
    CCLabelBMFont *healthLabel;
    
    int tankIndex;
    int health;
    int frags;
    BOOL exploding;
    float fireDelay;
    BOOL deathCount;

    BOOL moveUp;
    BOOL moveDown;
    BOOL moveLeft;
    BOOL moveRight;
    BOOL fire;
    
    CCAnimation *explodeAnimation;
}

- (id)initWithLayer:(WorldLayer *)aLayer tank:(int)aTank;
- (BOOL)doFire;
- (void)nextWeapon;
- (void)prevWeapon;
- (void)reset;
- (void)resetWithStartCoords:(GameStartCoords *)c;
- (void)consumeItem:(GameItem *)aItem;
- (void)repair;
- (void)cheat;
- (void)applyDamage:(GameAmmo *)aAmmo;
- (void)sensorContact:(GameObject *)aObject begin:(BOOL)aBegin fixture:(b2Fixture *)aFixture;
- (void)moveLeftImpulse:(ccTime)dt;
- (void)moveRightImpulse:(ccTime)dt;
- (void)increaseFragsByWeapon:(GameWeaponType)aType;
- (void)decreaseFrags;
- (void)explodeDone:(CCSprite *)aSprite;

@property (readonly) GameArmory *armory;
@property (readwrite) BOOL moveUp;
@property (readwrite) BOOL moveDown;
@property (readwrite) BOOL moveLeft;
@property (readwrite) BOOL moveRight;
@property (readwrite) BOOL fire;
@property (readonly) BOOL deathCount;
@property (readwrite) int health;
@property (readonly) int tankIndex;
@property (readonly) int frags;
@property (readonly) BOOL exploding;

@end
