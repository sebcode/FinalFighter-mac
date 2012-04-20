
#import <Carbon/Carbon.h>
#import "IntroLayer.h"
#import "WorldLayer.h"
#import "GameSoundPlayer.h"
#import "IntroLayer.h"
#import "MenuLayer.h"

@implementation IntroLayer

+ (CCScene *)scene
{
	CCScene *scene = [CCScene node];
    
	IntroLayer *layer = [[[IntroLayer alloc] init] autorelease];
	[scene addChild: layer];
    
	return scene;
}

- (id)init
{
    self = [super init];
    
    self.isMouseEnabled = YES;
    self.isKeyboardEnabled = YES;    
    
    state = GameIntroStateLoading;
    
    sprite = [CCSprite spriteWithFile:@"preintro.png"];
    sprite.anchorPoint = ccp(0, 0);
    sprite.position = ccp(0, 0);
    [self addChild: sprite];
    
    [self schedule: @selector(tick:)];
    
    return self;
}

- (void)dealloc
{
    [super dealloc];

    if (sprite) {
        [sprite removeFromParentAndCleanup:YES];
        sprite = nil;
    }
}

- (void)tick:(ccTime)dt
{
    if (state == GameIntroStateLoading) {
        [self preload];
        state = GameIntroStateLoaded;
    }
}

- (void)continue
{
    switch (state) {
        case GameIntroStateLoading:
            return;
            
        case GameIntroStateLoaded:
            [sprite removeFromParentAndCleanup:YES];
            sprite = [CCSprite spriteWithFile:@"intro.png"];
            sprite.anchorPoint = ccp(0, 0);
            sprite.position = ccp(0, 0);
            [self addChild: sprite];
            state = GameIntroStateIntro;
            return;
        
        default:
            [[CCDirector sharedDirector] runWithScene:[MenuLayer scene]];
            return;
    }
}

- (BOOL)ccMouseUp:(NSEvent *)event
{
    [self continue];
    
    return YES;
}

- (BOOL)ccKeyUp:(NSEvent *)event
{
    if (event.keyCode == kVK_Escape || event.keyCode == kVK_Space) {
        [self continue];
    }

    return YES;
}

- (void)preload
{
    [[GameSoundPlayer getInstance] preload];
}

@end
