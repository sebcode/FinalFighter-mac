
#import "GameMenuPage.h"

@interface GameMenuPageAchieve : GameMenuPage
{
    CCLabelBMFont *title;
    CCLabelBMFont *label;
    CCMenu *menuPrev;
    CCMenu *menuNext;
    GameMenuItemImage *menuPrevItem;
    GameMenuItemImage *menuNextItem;
    NSUInteger page;
}

@end
