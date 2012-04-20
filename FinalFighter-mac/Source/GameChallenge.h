
#import <Foundation/Foundation.h>

enum GameChallengeType {
    GameChallengeNone,
    GameChallengeTutorial,
    GameChallengeDeathmatch
};
typedef enum GameChallengeType GameChallengeType;

static NSString *GameChallengeTypeLabels[] = {
    @"",
    @"TUTORIAL",
    @"DEATHMATCH"
};

@interface GameChallenge : NSObject
{
    NSUInteger index;
    NSUInteger tier;
    NSUInteger fragLimit;
    NSUInteger timeLimit;
    NSUInteger numSpawnBots;
    GameChallengeType type;
    Class levelClass;
}

@property (readwrite) NSUInteger index;
@property (readwrite) NSUInteger tier;
@property (readwrite) NSUInteger fragLimit;
@property (readwrite) NSUInteger timeLimit;
@property (readwrite) NSUInteger numSpawnBots;
@property (readwrite) GameChallengeType type;
@property (readwrite) Class levelClass;

- (NSString *)id;
- (NSString *)label;
- (NSString *)menuLabel;
- (int)menuImageIndex;
- (void)markAsDone:(NSInteger)s;
- (BOOL)isDone;
- (NSString *)doneMessage;

@end
