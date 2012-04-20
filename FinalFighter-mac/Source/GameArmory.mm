
#import "GameArmory.h"

@implementation GameArmory
@synthesize selectedWeapon;

- (id)init
{
    self = [super init];
    
    weapons = [[NSArray arrayWithObjects:
               [[[GameWeapon alloc] initWithType:kWeaponMachinegun] autorelease],
               [[[GameWeapon alloc] initWithType:kWeaponGrenade] autorelease],
               [[[GameWeapon alloc] initWithType:kWeaponFlame] autorelease],
               [[[GameWeapon alloc] initWithType:kWeaponRocket] autorelease],
               [[[GameWeapon alloc] initWithType:kWeaponMine] autorelease],
               nil] retain];
    
    [self reset];

    return self;
}

- (void)dealloc
{
    [weapons release];
    weapons = nil;
    
    [super dealloc];
}

- (void)reset
{
    for (GameWeapon *weapon in weapons) {
        [weapon reset];
    }
    
    selectedWeapon = [weapons objectAtIndex:0];
}

- (void)cheat
{
    for (GameWeapon *weapon in weapons) {
        [weapon cheat];
    }
}

- (GameWeapon *)getWeapon:(GameWeaponType)aType
{
    if (aType < 0 || aType >= numWeapons) {
        return nil;
    }
    
    return [weapons objectAtIndex:aType];
}

- (BOOL)selectWeapon:(GameWeapon *)aWeapon
{
    if (![aWeapon hasInfiniteAmmo] && !aWeapon.ammo) {
        return NO;
    }
    
    selectedWeapon = aWeapon;
    
    return YES;
}

- (BOOL)consumeItem:(GameItemType)aItemType
{
    GameWeapon *weapon = [self getWeapon:(GameWeaponType)aItemType];
    
    if (weapon == nil) {
        return NO;
    }
    
    return [weapon consumeItem];
}

- (BOOL)next
{
    int i = selectedWeapon.type;
    GameWeapon *w;
    
    do {
        i++;
        
        if (i > numWeapons) {
            i = 0;
        } else if (i < 0) {
            i = numWeapons;
        }
        
        w = [self getWeapon:(GameWeaponType)i];
    } while (![self selectWeapon:w]);
    
    return YES;
}

- (BOOL)prev
{
    int i = selectedWeapon.type;
    GameWeapon *w;
    
    do {
        i--;
        
        if (i > numWeapons) {
            i = 0;
        } else if (i < 0) {
            i = numWeapons;
        }
        
        w = [self getWeapon:(GameWeaponType)i];
    } while (![self selectWeapon:w]);
    
    return YES;
}

/* never choose mines, because they need extra intelligence */
- (GameWeapon *)getBestLoadedWeapon
{
    GameWeapon *w;
    
    w = [self getWeapon:kWeaponRocket];
    if (w.hasAmmo) {
        return w;
    }
    
    w = [self getWeapon:kWeaponFlame];
    if (w.hasAmmo) {
        return w;
    }
    
    w = [self getWeapon:kWeaponGrenade];
    if (w.hasAmmo) {
        return w;
    }
    
    w = [self getWeapon:kWeaponMachinegun];
    return w;
}

- (void)selectBestLoadedWeapon
{
    GameWeapon *w = [self getBestLoadedWeapon];
    [self selectWeapon:w];
}

@end
