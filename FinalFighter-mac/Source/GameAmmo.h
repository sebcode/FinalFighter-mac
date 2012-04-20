
#import "GameObject.h"
#import "GameSoundPlayer.h"

@interface GameAmmo : GameObject
{
    GameWeaponType type;
    float age;
    float maxAge;
    float lethalAge;
    BOOL exploding;
    BOOL isLethal;
    GameObject *sender;
    int damagePoints;
    CCAnimation *explodeAnimation;
    CCAnimation *animation;
}

+ (GameAmmo *)ammoWithPosition:(CGPoint)aPos angle:(float)aAngle type:(GameWeaponType)aType sender:(GameObject *)aSender;

- (id)initWithPosition:(CGPoint)pos angle:(float)aAngle type:(GameWeaponType)aType sender:(GameObject *)aSender;
- (void)explode;
- (void)increaseSenderFrags;

@property (readonly) int damagePoints;
@property (readonly) GameObject *sender;
@property (readonly) GameWeaponType type;

@end
