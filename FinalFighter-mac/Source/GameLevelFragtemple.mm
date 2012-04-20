
#import "GameLevelFragtemple.h"
#import "GameItem.h"

@implementation GameLevelFragtemple

- (NSString *)getFilename;
{
    return @"Fragtemple.png";
}

- (void) createCollisionMap
{
#include "Fragtemple.inc"    
}

- (void) createItems
{
#include "Fragtemple_Items.inc"
}

+ (NSString *)getLabel;
{
    return @"FRAGTEMPLE";
}

@end
