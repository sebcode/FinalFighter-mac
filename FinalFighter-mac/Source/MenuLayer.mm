
#import <Carbon/Carbon.h>
#import "MenuLayer.h"
#import "WorldLayer.h"
#import "GameMenu.h"
#import "GameMenuItemImage.h"
#import "GameMenuPagePlay.h"
#import "GameMenuPageAchieve.h"
#import "GameMenuPageSettings.h"
#import "GameMenuPageAbout.h"
#import "GameFont.h"
#import "GameMusicPlayer.h"
#import "GameStats.h"

@implementation MenuLayer

+ (CCScene *)scene
{
	CCScene *scene = [CCScene node];
    
	MenuLayer *layer = [[[MenuLayer alloc] init] autorelease];
	[scene addChild: layer];
    
	return scene;
}

- (void)onEnter
{
    [super onEnter];
    
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    
    [[GameStats getInstance] synchronize];
    
    [[GameMusicPlayer getInstance] playMenuMusic];
    
    if (menuTabPages.count) {
        GameMenuPagePlay *p = [menuTabPages objectAtIndex:0];
        [p onSceneEnter];
    }
}

- (id)init
{
	self = [super init];
    if (!self) {
        return self;
    }

    CCSprite *sprite;
    sprite = [CCSprite spriteWithFile:@"menu.png"];
    sprite.anchorPoint = ccp(0, 0);
    sprite.position = ccp(0, 0);
    [self addChild: sprite];

    tooltipLabel = [CCLabelBMFont labelWithString:@"" fntFile:GameFontDefault];
    [self addChild:tooltipLabel];
    tooltipLabel.position = ccp(218.0f, 374.0f);
    tooltipLabel.anchorPoint = ccp(0, 0);
    [self popTooltip];

    GameMenuItemImage *i;
    CCSprite *normalSprite;
    CCSprite *selSprite;

    /* start-knopf (unten rechts) */
    
    normalSprite = [CCSprite spriteWithSpriteFrameName:@"menu_start.png"];
    selSprite = [CCSprite spriteWithSpriteFrameName:@"menu_start.png"];
    i = [self createItemWithSprite:normalSprite selected:selSprite selector:@selector(onClickStart)];
    i.tooltip = @"Start";
    menu = [GameMenu menuWithItems: i, nil];
    menu.position = ccp(428.0f, 22.0f);
    [self addChild:menu];

    /* exit-knopf (unten links) */
    normalSprite = [CCSprite spriteWithSpriteFrameName:@"menu_icon_exit.png"];
    selSprite = [CCSprite spriteWithSpriteFrameName:@"menu_icon_exit.png"];
    i = [self createItemWithSprite:normalSprite selected:selSprite selector:@selector(onClickExit)];
    i.tooltip = @"Quit FinalFighter";
    menu = [GameMenu menuWithItems: i, nil];
    menu.position = ccp(10.0f, 10.0f);
    [self addChild:menu];

    /* vier menu icons */
    
    normalSprite = [CCSprite spriteWithSpriteFrameName:@"menu_icon_0.png"];
    selSprite = [CCSprite spriteWithSpriteFrameName:@"menu_icon_0.png"];
    GameMenuItemImage *i1 = [self createItemWithSprite:normalSprite selected:selSprite selector:@selector(onClickTabItem:)];
    i1.tooltip = @"Play Challenges";
    i1.tag = GameMenuTabItemGame;
    [self onClickTabItem:i1];

    normalSprite = [CCSprite spriteWithSpriteFrameName:@"menu_icon_1.png"];
    selSprite = [CCSprite spriteWithSpriteFrameName:@"menu_icon_1.png"];
    GameMenuItemImage *i2 = [self createItemWithSprite:normalSprite selected:selSprite selector:@selector(onClickTabItem:)];
    i2.tooltip = @"Achievements";
    i2.tag = GameMenuTabItemAchievements;

    normalSprite = [CCSprite spriteWithSpriteFrameName:@"menu_icon_2.png"];
    selSprite = [CCSprite spriteWithSpriteFrameName:@"menu_icon_2.png"];
    GameMenuItemImage *i3 = [self createItemWithSprite:normalSprite selected:selSprite selector:@selector(onClickTabItem:)];
    i3.tooltip = @"Settings";
    i3.tag = GameMenuTabItemSettings;

    normalSprite = [CCSprite spriteWithSpriteFrameName:@"menu_icon_3.png"];
    selSprite = [CCSprite spriteWithSpriteFrameName:@"menu_icon_3.png"];
    GameMenuItemImage *i4 = [self createItemWithSprite:normalSprite selected:selSprite selector:@selector(onClickTabItem:)];
    i4.tooltip = @"Information";
    i4.tag = GameMenuTabItemAbout;

    menu = [GameMenu menuWithItems: i1, i2, i3, i4, nil];
    menu.position = ccp(40.0f, 173.0f);
    menu.scale = 0.8;
    menu.anchorPoint = ccp(0, 0);
    [self addChild:menu];
    [menu alignItemsVerticallyWithPadding:20.0f];

    menuTabPages = [[NSArray arrayWithObjects:
                     [GameMenuPagePlay node],
                     [GameMenuPageAchieve node],
                     [GameMenuPageSettings node],
                     [GameMenuPageAbout node],
                     nil] retain];
    [self onClickTabItem:i1];
    
    GameMenuPage *page;
    for (page in menuTabPages) {
        page.visible = NO;
        page.position = ccp(-1000.0f, -1000.0f);
        page.delegate = self;
        [self addChild:page];
    }

    page = [menuTabPages objectAtIndex:0];
    page.position = ccp(105.0f, 60.0f);
    page.visible = YES;

    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (GameMenuItemImage *)createItemWithImage:(NSString *)aImage selected:(NSString *)aImageSelected selector:(SEL)aSelector
{
    GameMenuItemImage *i;
    i = [GameMenuItemImage itemWithNormalImage:aImage selectedImage:aImageSelected target:self selector:aSelector];
    i.anchorPoint = ccp(0, 0);
    i.position = ccp(0, 0);
    i.onSelectSelector = @selector(onSelectItem:);
    i.onUnselectSelector = @selector(onUnselectItem:);
    i.selectorTarget = self;
    i.opacity = 150.0f;
    
    return i;    
}

- (GameMenuItemImage *)createItemWithImage:(NSString *)aImage selector:(SEL)aSelector
{
    return [self createItemWithImage:aImage selected:aImage selector:aSelector];
}

- (GameMenuItemImage *)createItemWithSprite:(CCSprite *)aSprite selected:(CCSprite *)aSpriteSelected selector:(SEL)aSelector
{
    GameMenuItemImage *i;
    i = [GameMenuItemImage itemWithNormalSprite:aSprite selectedSprite:aSpriteSelected target:self selector:aSelector];
    i.anchorPoint = ccp(0, 0);
    i.position = ccp(0, 0);
    i.onSelectSelector = @selector(onSelectItem:);
    i.onUnselectSelector = @selector(onUnselectItem:);
    i.selectorTarget = self;
    i.opacity = 150.0f;
    
    return i;
}

- (void)onClickTabItem:(id)aSender
{
    GameMenuItemImage *item = (GameMenuItemImage *)aSender;

    if (selectedTabItem == item) {
        return;
    }
    
    selectedTabItem.color = ccc3(255, 255, 255);
    selectedTabItem.opacity = 150.0f;
    
    item.color = ccc3(69, 240, 48);
    item.opacity = 255.0f;
    selectedTabItem = item;

    GameMenuPage *page;

    for (page in menuTabPages) {
        page.delegate = self;
        page.visible = NO;
        page.position = ccp(-1000.0f, -1000.0f);
    }
    
    page = [menuTabPages objectAtIndex:item.tag];
    page.visible = YES;
    page.position = ccp(105.0f, 60.0f);
    [page update];
}

- (void)onSelectItem:(id)aSender
{
    GameMenuItemImage *item = (GameMenuItemImage *)aSender;
    item.opacity = 255.0f;
    
    if (item.tooltip) {
        [self pushTooltip:item.tooltip];
    }
}

- (void)onUnselectItem:(id)aSender
{
    GameMenuItemImage *item = (GameMenuItemImage *)aSender;

    if (selectedTabItem != aSender) {
        item.opacity = 150.0f;
    }
    
    [self popTooltip];
}

- (void)onClickStart
{
    if (selectedTabItem.tag != GameMenuTabItemGame) {
        id i = [menu getChildByTag:GameMenuTabItemGame];
        [self onClickTabItem:i];
        return;
    }

    GameMenuPage *page = [menuTabPages objectAtIndex:selectedTabItem.tag];
    [page start];
}

- (void)onClickExit
{
    [[NSApplication sharedApplication] terminate:self];
}

- (void)pushTooltip:(NSString *)aTooltip
{
    tooltipLabel.string = aTooltip;
    tooltipLabel.opacity = 255.0f;
}

- (void)popTooltip
{
    tooltipLabel.string = @"FinalFighter";
    tooltipLabel.opacity = 150.0f;
}

@end
