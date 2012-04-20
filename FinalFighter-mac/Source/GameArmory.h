
#import "GameObject.h"
#import "GameWeapon.h"
#import "GameItem.h"

@interface GameArmory : NSObject
{
    NSArray *weapons;
    GameWeapon *selectedWeapon;
}

@property (readonly) GameWeapon *selectedWeapon;

- (GameWeapon *)getWeapon:(GameWeaponType)aType;
- (BOOL)consumeItem:(GameItemType)aItemType;
- (BOOL)selectWeapon:(GameWeapon *)aWeapon;
- (void)selectBestLoadedWeapon;
- (GameWeapon *)getBestLoadedWeapon;
- (BOOL)next;
- (BOOL)prev;
- (void)cheat;
- (void)reset;

@end
