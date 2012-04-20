
#import "GameTank.h"

@interface GamePlayer : GameTank
{
    GameLevel *level;
    CGSize levelSize;
    GameHudLayer *hudLayer;

    BOOL collectStats;
    BOOL canFire;
    float statMoveLeft;
    float statMoveRight;
    float statMoveUp;
    float statMoveDown;
    float statMoveTurret;
    float statFire;
    NSUInteger statCollectGrenade;
    NSUInteger statCollectFlame;
    NSUInteger statCollectRocket;
    NSUInteger statCollectMine;
    NSUInteger statCollectRepair;
    NSUInteger fragsSinceDeath;
}

- (void)tick:(ccTime)dt;
- (BOOL)switchWeapon:(GameWeaponType)aWeaponType;
- (void)nextWeapon;
- (void)prevWeapon;
- (BOOL)doFire;
- (void)moveTurret:(CGPoint)loc;
- (void)resetStats;

@property (readwrite) BOOL collectStats;
@property (readwrite) BOOL canFire;
@property (readonly) float statMoveLeft;
@property (readonly) float statMoveRight;
@property (readonly) float statMoveUp;
@property (readonly) float statMoveDown;
@property (readonly) float statMoveTurret;
@property (readonly) float statFire;
@property (readonly) NSUInteger statCollectGrenade;
@property (readonly) NSUInteger statCollectFlame;
@property (readonly) NSUInteger statCollectRocket;
@property (readonly) NSUInteger statCollectMine;
@property (readonly) NSUInteger statCollectRepair;

@end
