
#import "GameChallenge.h"
#import "GameLevelFragtemple.h"
#import "GameStats.h"

@implementation GameChallenge
@synthesize index;
@synthesize tier;
@synthesize fragLimit;
@synthesize timeLimit;
@synthesize numSpawnBots;
@synthesize type;
@synthesize levelClass;

- (id)init
{
    self = [super init];

    levelClass = [GameLevelFragtemple class];    
    
    return self;
}

- (NSString *)label
{
    if (type == GameChallengeTutorial) {
        return [NSString stringWithFormat:@"%@", GameChallengeTypeLabels[type]];
    }
    
    NSMutableString *str = [NSMutableString stringWithFormat:@"%@ %@", GameChallengeTypeLabels[type], [levelClass getLabel]];
    
    if (tier) {
        [str appendString:[NSString stringWithFormat:@" - TIER %ld", (unsigned long)tier]];
    }
    
    return str;
}

- (NSString *)menuLabel
{
    if (type == GameChallengeTutorial) {
        return [NSString stringWithFormat:@"%@\n", GameChallengeTypeLabels[type]];
    }

    NSMutableString *str = [NSMutableString stringWithFormat:@"%@\n%@", GameChallengeTypeLabels[type], [levelClass getLabel]];

    if (tier) {
        [str appendString:[NSString stringWithFormat:@" - TIER %ld\n", (unsigned long)tier]];
    }
    
    [str appendString:[NSString stringWithFormat:@"FRAGLIMIT %ld - %ld %@", (unsigned long)fragLimit, (unsigned long)numSpawnBots, numSpawnBots > 1 ? @"BOTS" : @"BOT"]];
    
    return str;
}

- (NSString *)id
{
    return [NSString stringWithFormat:@"%@,%ld,%@", GameChallengeTypeLabels[type], (unsigned long)tier, [levelClass getLabel]];
}

- (int)menuImageIndex
{
    return [levelClass menuImageIndex];
}

- (void)markAsDone:(NSInteger)s
{
    GameStats *stats = [GameStats getInstance];
    [stats incInt:[NSString stringWithFormat:@"victoryChallenge_%@", self.id]];
    
    NSString *timeKey = [NSString stringWithFormat:@"victoryChallengeTime_%@", self.id];
    NSInteger os = [stats getInt:timeKey];
    
    if (os == 0 || os > s) {
        [stats setInt:s forKey:timeKey];
    }
}

- (BOOL)isDone
{
    return [[GameStats getInstance] getInt:[NSString stringWithFormat:@"victoryChallenge_%@", self.id]];
}

- (NSString *)doneMessage
{
    if ([self isDone]) {
        long seconds = (long)[[GameStats getInstance] getInt:[NSString stringWithFormat:@"victoryChallengeTime_%@", self.id]];
        
        if (!seconds) {
            return [NSString stringWithFormat:@"FINISHED"];        
        }
        
        int m = round(seconds / 60);
        int s = seconds % 60;
        return [NSString stringWithFormat:@"FINISHED in %i:%02i", m, s];
    }
    
    return @"";
}

@end
