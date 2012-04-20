
#import <Cocoa/Cocoa.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "GameContactListener.h"
#import "GameHudLayer.h"
#import "GameConstants.h"
#import "GameTutorialLayer.h"
#import "GameMenuPagePlay.h"

@class GameLevel;
@class GamePlayer;
@class GameTank;

@interface WorldLayer : CCLayer
{
	GLESDebugDraw *m_debugDraw;
    GameContactListener *contactListener;
    
    GameHudLayer *hudLayer;
    GameTutorialLayer *tutorialLayer;
    GameLevel *level;
    GamePlayer *player;
    b2World *world;
    GameChallenge *challenge;
    int secondCounter;
    int totalFrags;
    BOOL fragLimitReached;
    
    CGPoint mouseLoc;
    NSMutableArray *destroyQueue;
    NSMutableArray *players;
}

- (id)initWithHUD:(GameHudLayer *)aHudLayer challenge:(GameChallenge *)aChallange tank:(int)aTankIndex;
- (void)incTotalFrags;
- (void)checkFragLimit:(GameTank *)aTank;
- (void)spawnBots:(NSUInteger)aCount players:(NSMutableArray *)aPlayers excludeTankIndex:(NSUInteger)aExcludeTankIndex tier:(NSUInteger)aTier;

#ifndef PRODUCTION_BUILD
+ (CCScene *)scene;
+ (CCScene *)sceneWithLevel:(Class)aLevelClass tank:(int)aTankIndex;
#endif
+ (CCScene *)sceneWithChallenge:(GameChallenge *)aChallenge tank:(int)aTankIndex;

@property (readonly) NSMutableArray *destroyQueue;
@property (readonly) b2World *world;
@property (assign) GameLevel *level;
@property (readonly) GameHudLayer *hudLayer;
@property (assign) GameTutorialLayer *tutorialLayer;
@property (readonly) GamePlayer *player;
@property (readonly) int totalFrags;
@property (readonly) int secondCounter;
@property (assign) GameChallenge *challenge;

@end
