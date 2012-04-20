
#import "GameLevelYerLethalMetal.h"

@implementation GameLevelYerLethalMetal

- (NSString *) getFilename;
{
    return @"YerLethalMetal.png";
}

- (void) createCollisionMap
{
#include "YerLethalMetal.inc"
}

- (void) createItems
{
#include "YerLethalMetal_Items.inc"
}

+ (NSString *)getLabel;
{
    return @"YER LETHAL METAL";
}

+ (int)menuImageIndex;
{
    return LEVEL_YERLETHALMETAL_IMAGE_INDEX;
}

@end
