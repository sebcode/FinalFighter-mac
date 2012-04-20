
#import "GameAchievement.h"
#import "GameStats.h"

@implementation GameAchievement
@synthesize label;
@synthesize trigger;
@synthesize triggerMin;

- (BOOL)isDone
{
    return [[GameStats getInstance] getInt:trigger] > triggerMin;
}

@end
