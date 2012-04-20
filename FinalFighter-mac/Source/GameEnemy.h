
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"

#import "GameTank.h"

enum GameEnemyLevel {
    GameEnemyLevelEasy,
    GameEnemyLevelMedium,
    GameEnemyLevelHard
};

@interface GameEnemy : GameTank
{
    NSUInteger wallSensor;
    NSUInteger leftSensor;
    NSUInteger rightSensor;
    NSUInteger turretSensorWallContact;
    
    GameEnemyLevel level;
    NSUInteger inaccuracyAngle;
    float turretRotationSpeed;

    b2Fixture *turretSensorFixture;
    b2Body *turretSensorBody;

    float moveTurretTo;
    float actionDelay;
    float retargetDelay;
    float checkMineDelay;
    float inaccuracy;
    float inaccuracyDelay;
    
    BOOL inactive;
    BOOL friendly;
    
    NSMutableArray *tanksInRange;
    GameTank *targetTank;
}

- (void)tick:(ccTime)dt;
- (void)setLevel:(GameEnemyLevel)aLevel;
- (GameEnemyLevel)getLevel;

@property (assign) BOOL inactive;
@property (assign) BOOL friendly;

@end
