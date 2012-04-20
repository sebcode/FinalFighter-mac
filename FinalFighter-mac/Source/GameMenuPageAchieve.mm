
#import "GameMenuPageAchieve.h"
#import "GameMenuItemImage.h"
#import "GameFont.h"
#import "GameAchievements.h"

@implementation GameMenuPageAchieve

- (id)init
{
    self = [super init];
    if (!self) {
        return self;
    }

    /* menu item: go left */
    
    GameMenu *menu;
    GameMenuItemImage *i;

    i = [self createItemWithImage:@"menu_arrow_left_inactive.png"
                         selected:@"menu_arrow_left.png"
                         selector:@selector(onClickPrev:)];
    i.tooltip = @"Previous";
    menuNextItem = i;
    
    menu = [GameMenu menuWithItems: i, nil];
    menu.position = ccp(18.0f, 220.0f);
    menu.anchorPoint = ccp(0, 0);
    [self addChild:menu];
    menuPrev = menu;
    
    /* menu item: go right */
    
    i = [self createItemWithImage:@"menu_arrow_left_inactive.png"
                         selected:@"menu_arrow_left.png"
                         selector:@selector(onClickNext:)];
    i.anchorPoint = ccp(0.5f, 0.5f);
    i.position = ccp(16.0f, 21.0f);
    i.rotation = 180.0f;
    i.tooltip = @"Next";
    menuPrevItem = i;
    
    menu = [GameMenu menuWithItems: i, nil];
    menu.position = ccp(258.0f, 220.0f);
    menu.anchorPoint = ccp(0, 0);
    [self addChild:menu];
    menuNext = menu;

    /* title */
    
    title = [CCLabelBMFont labelWithString:@"" fntFile:GameFontMenuDefault];
    title.position = ccp(155.0f, 240.0f);
    title.alignment = kCCTextAlignmentCenter;
    [self addChild:title z:100];

    /* text */

    label = [CCLabelBMFont labelWithString:@"" fntFile:GameFontMini];
    label.anchorPoint = ccp(0.5f, 1.0f);
    label.position = ccp(155.0f, 210.0f);
    label.alignment = kCCTextAlignmentCenter;
    label.opacity = 200.0f;
    [self addChild:label];

    [self update];

    return self;
}

- (void)update
{
    NSMutableString *text = [NSMutableString string];
    GameAchievements *am = [GameAchievements getInstance];

    NSUInteger numItems = 13;
    NSUInteger startIndex = page * numItems;
    NSUInteger totalPages = (am.count + numItems - 1) / numItems;

    for (NSUInteger i = startIndex; i < startIndex + numItems && i < am.count; i++) {
        GameAchievement *a = [am getByIndex:i];        
        [text appendFormat:@"%@\n", a.label];
    }
    
    label.string = text;
    label.color = ccc3(255.0f, 0, 0);

    /* colorize done */
    
    NSUInteger pos = 0;
    NSUInteger len = 0;
    
    for (NSUInteger i = startIndex; i < startIndex + numItems && i < am.count; i++) {
        GameAchievement *a = [am getByIndex:i];
        
        len = a.label.length + 1;
        
        if (a.isDone) {
            for (int j = 0; j < len; j++) {
                CCSprite *sprite = (CCSprite*)[label getChildByTag:pos + j];
                [sprite setColor:ccc3(0, 255.0f, 0)];
            }
        } else {
            for (int j = 0; j < len; j++) {
                CCSprite *sprite = (CCSprite*)[label getChildByTag:pos + j];
                [sprite setColor:ccc3(255.0f, 0, 0)];
            }
        }
        
        pos += len;
    }
    
    /* set title */
    
    title.string = [NSString stringWithFormat:@"ACHIEVEMENTS (%ld/%ld)\n%ld%% UNLOCKED", (unsigned long)page + 1, (unsigned long)totalPages, (unsigned long)am.percentDone];

    /* prev/next visibility */
    
    menuPrev.visible = page > 0;
    if (!menuPrev.visible) {
        [menuNextItem unselected];
    }
    
    menuNext.visible = page < totalPages - 1;
    if (!menuNext.visible) {
        [menuPrevItem unselected];
    }
}

- (void)onClickNext:(id)aSender
{
    page++;
    
    [self update];
}

- (void)onClickPrev:(id)aSender
{
    page--;
    
    [self update];
}

@end
