
#import "GameMenuPage.h"
#import "GameMenu.h"
#import "GameChallenge.h"
#import "GameChallengeManager.h"

enum GamePlayTypeSelectMode {
    kSelectModeLevel,
    kSelectModeTank
};

@interface GameMenuPagePlay : GameMenuPage
{
    CCLabelBMFont *title;
    CCLabelBMFont *label;
    CCLabelBMFont *status;
    CCLabelBMFont *topLabel;
    GameChallenge *selectedChallenge;
    long tank;
    CCSprite *levelSprite;
    CCSprite *tankSprite;
    CCSprite *turretSprite;
    CCSprite *lockedSprite;
    CCMenu *menuPrev;
    CCMenu *menuNext;
    CCMenu *backMenu;
    GameMenuItemImage *menuPrevItem;
    GameMenuItemImage *menuNextItem;
    GamePlayTypeSelectMode selectMode;
    GameMenu *selectLevelMenu;
    long lastVictoryCount;
}

- (void)onSceneEnter;

@end
