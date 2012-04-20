
#import "cocos2d.h"

@class WorldLayer;
@class GameItem;
@class GameEnemy;

@interface GameTutorialLayer : CCLayer
{
    WorldLayer *worldLayer;
    CCLabelBMFont *label;
    CCLabelBMFont *plabel;
    CCLabelBMFont *olabel;
    
    GameItem *healthPack1;
    GameItem *healthPack2;
    GameItem *weaponItem;
    GameEnemy *enemy;
    
    int step;
    BOOL waitForReturn;
    BOOL wellDone;
    NSString *otext;
    NSString *text;
}

- (void)next;
- (void)update;
- (void)playerReturn;

@property (assign) WorldLayer *worldLayer;

@end
