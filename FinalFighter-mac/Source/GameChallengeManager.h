
#import <Foundation/Foundation.h>
#import "GameChallenge.h"

@interface GameChallengeManager : NSObject
{
    NSMutableArray *challenges;
}

+ (GameChallengeManager *)getInstance;

- (GameChallenge *)getById:(NSString *)aId;
- (GameChallenge *)getByIndex:(NSUInteger)aIndex;
- (NSUInteger)count;
- (BOOL)isLocked:(GameChallenge *)aChallenge;
- (GameChallenge *)bestChallenge;
- (BOOL)allDone;

@end
