
#import "cocos2d.h"
#import "GameMenu.h"

@class GameMenuItemImage;

enum GameMenuTabItem {
    GameMenuTabItemGame,
    GameMenuTabItemAchievements,
    GameMenuTabItemSettings,
    GameMenuTabItemAbout
};

@interface MenuLayer : CCLayer
{
    CCLabelBMFont *tooltipLabel;
    GameMenu *menu;
    
    GameMenuItemImage *selectedTabItem;    
    NSArray *menuTabPages;
}

+ (CCScene *)scene;

- (void)pushTooltip:(NSString *)aTooltip;
- (void)popTooltip;

- (void)onSelectItem:(id)aSender;
- (void)onUnselectItem:(id)aSender;

@end
