
#import <Cocoa/Cocoa.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "GameWeapon.h"
#import "CCLayer.h"

@interface GameHudLayer : CCLayer
{
    CCSprite *weaponSprite;
    CCSprite *healthSprite;
    CCSprite *fragSprite;
    CCLabelBMFont *healthLabel;
    CCLabelBMFont *fragLabel;
    CCLabelBMFont *ammoLabel;
    CCLabelBMFont *ammoLabel2;
    CCLabelBMFont *timeLabel;
    CCLabelBMFont *playersLabel;
    NSArray *playersList;
    CGSize screenSize;
}

- (void)setWeapon:(GameWeapon *)aWeapon;
- (void)setHealth:(int)aHealth;
- (void)setFrags:(int)aFrags;
- (void)setTime:(int)aSeconds;
- (void)setPlayersList:(NSArray *)aList;
- (void)updatePlayersList;

@end
