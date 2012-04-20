
#import "GameLevelHauntedHalls.h"

@implementation GameLevelHauntedHalls

- (NSString *) getFilename;
{
    return @"HauntedHalls.png";
}

- (void) createCollisionMap
{
#include "HauntedHalls.inc"
}

- (void) createItems
{
#include "HauntedHalls_Items.inc"
}

+ (NSString *)getLabel;
{
    return @"HAUNTED HALLS";
}

+ (int)menuImageIndex;
{
    return LEVEL_HAUNTEDHALLS_IMAGE_INDEX;
}

@end
