
#import <Carbon/Carbon.h>
#import "PauseLayer.h"
#import "MenuLayer.h"
#import "GameMenuItemLabel.h"
#import "GameFont.h"
#import "GameMenu.h"
#import "GameStats.h"

@implementation PauseLayer

+ (CCScene *)scene
{
	CCScene *scene = [CCScene node];
    
    PauseLayer *layer = [PauseLayer node];
    [scene addChild:layer];
    
	return scene;
}

- (id)init
{
    self = [super init];
    
    self.isMouseEnabled = YES;
    self.isKeyboardEnabled = YES;    
    
    CCLabelBMFont *label;
    
    label = [CCLabelBMFont labelWithString:@"GAME PAUSED\n" fntFile:GameFontDefault];
    label.opacity = 100.0f;
    label.position = ccp(640.0f / 2.0f, 330.0f);
    [self addChild:label];

    label = [CCLabelBMFont labelWithString:@"CONTINUE" fntFile:GameFontDefault];
    label.color = ccc3(150.0f, 150.0f, 150.0f);
    GameMenuItemLabel *item1 = [GameMenuItemLabel itemWithLabel:label block:^(id sender) {
        [[CCDirector sharedDirector] popScene];
    }];
//    label = [CCLabelBMFont labelWithString:@"SETTINGS" fntFile:GameFontDefault];
//    label.color = ccc3(150.0f, 150.0f, 150.0f);
//    GameMenuItemLabel *item2 = [GameMenuItemLabel itemWithLabel:label block:^(id sender) {
//        [[CCDirector sharedDirector] pushScene:[MenuLayer scene:YES]];
//    }];
    label = [CCLabelBMFont labelWithString:@"QUIT TO MENU" fntFile:GameFontDefault];
    label.color = ccc3(150.0f, 150.0f, 150.0f);
    GameMenuItemLabel *item3 = [GameMenuItemLabel itemWithLabel:label block:^(id sender) {
        [[CCDirector sharedDirector] popScene];
        [[CCDirector sharedDirector] popScene];
    }];
    
//    GameMenu *menu = [GameMenu menuWithItems: item1, item2, item3, nil];
    GameMenu *menu = [GameMenu menuWithItems: item1, item3, nil];
    menu.position = ccp(640.0f / 2.0f, 480.0f / 2.0f);
    [self addChild:menu];
    [menu alignItemsVerticallyWithPadding:10.0f];
    
    return self;
}

- (BOOL)ccKeyUp:(NSEvent *)event
{
    if (event.keyCode == kVK_Escape) {
        [[CCDirector sharedDirector] popScene];
    }
    
    return YES;
}

- (void)onEnter
{
    [super onEnter];
    
    [[GameStats getInstance] synchronize];
}

@end
