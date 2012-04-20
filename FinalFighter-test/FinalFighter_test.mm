
#import "FinalFighter_test.h"
#import "GameLevelFragtemple.h"
#import "WorldLayer.h"
#import "GameEnemy.h"

@implementation FinalFighter_test

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testExample
{
    NSMutableArray *players = [NSMutableArray arrayWithCapacity:10];
    WorldLayer *wl = [[WorldLayer alloc] init];
    [wl spawnBots:5 players:players excludeTankIndex:0 tier:0];
    NSMutableDictionary *usedIndices = [NSMutableDictionary dictionaryWithCapacity:20];
    STAssertTrue([players count] == 5, @"anzahl bots richtig?");

    for (int i = 0; i < [players count]; i++) {
        GameEnemy *e = (GameEnemy *)[players objectAtIndex:i];
        STAssertFalse(nil == [usedIndices objectForKey:[NSNumber numberWithInt:e.tankIndex]], @"existiert tank index schon?");
        STAssertTrue([e getLevel] == GameEnemyLevelEasy, @"level richtig?");
        [usedIndices setObject:[NSNumber numberWithBool:YES] forKey:[NSNumber numberWithInt:e.tankIndex]];
    }
    
}

@end
