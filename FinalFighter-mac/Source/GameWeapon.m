
#import "GameWeapon.h"

static int GameWeaponIncrement[] = {
    0, // kWeaponMachinegun
    3, // kWeaponGrenade
    30, // kWeaponFlame
    4, // kWeaponRocket
    4 // kWeaponMine
};

@implementation GameWeapon
@synthesize ammo;
@synthesize label;
@synthesize type;
@synthesize isRelentless;
@synthesize hasInfiniteAmmo;

- (id)initWithType:(GameWeaponType)aType
{
    self = [super init];
    if (!self) {
        return self;
    }

    type = aType;
    hasInfiniteAmmo = type == kWeaponMachinegun;
    isRelentless = type == kWeaponMachinegun || type == kWeaponFlame;
    
    return self;
}

- (void)reset
{
    ammo = 0;
}

- (void)cheat
{
    ammo = 99;
}

- (NSString *)label
{
    return GameWeaponLabels[type];
}

- (BOOL)hasAmmo
{
    return hasInfiniteAmmo || ammo > 0;
}

- (BOOL)consumeItem
{
    ammo += GameWeaponIncrement[type];
    
    if (ammo >= 99) {
        ammo = 99;
    }
    
    return YES;
}

- (BOOL)consumeBullet
{
    if ([self hasInfiniteAmmo]) {
        return YES;
    }
    
    if (ammo <= 0) {
        return NO;
    }
    
    ammo -= 1;
    
    return YES;
}

@end
