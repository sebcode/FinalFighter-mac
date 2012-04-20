
#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>
#import <Foundation/Foundation.h>
#import "GameSoundPlayer.h"
#import "WorldLayer.h"
#import "GameHudLayer.h"
#import "GameLevel.h"
#import "GameObject.h"
#import "GameUserData.h"
#import "GameTank.h"
#import "GamePlayer.h"
#import "GameEnemy.h"
#import "GameLevelTutorial.h"
#import "GameLevelFragtemple.h"
#import "GameLevelHauntedHalls.h"
#import "GameLevelYerLethalMetal.h"
#import "GameLevelOverkillz.h"
#import "GameItem.h"
#import "GameConstants.h"
#import "MenuLayer.h"
#import "PauseLayer.h"
#import "GameTutorialLayer.h"
#import "GameFont.h"
#import "GameStats.h"
#import "GameChallenge.h"
#import "GameMusicPlayer.h"

@implementation WorldLayer
@synthesize level;
@synthesize destroyQueue;
@synthesize world;
@synthesize hudLayer;
@synthesize tutorialLayer;
@synthesize player;
@synthesize totalFrags;
@synthesize secondCounter;
@synthesize challenge;

#ifndef PRODUCTION_BUILD
+ (CCScene *)scene
{
    return [self sceneWithLevel:[GameLevelTutorial class] tank:0];
}
#endif

#ifndef PRODUCTION_BUILD
+ (CCScene *)sceneWithLevel:(Class)aLevelClass tank:(int)aTankIndex
{
    GameChallenge *c = [[[GameChallenge alloc] init] retain];
    c.fragLimit = 200;
    c.numSpawnBots = 3;
    c.levelClass = aLevelClass;
    return [self sceneWithChallenge:c tank:aTankIndex];
}
#endif

+ (CCScene *)sceneWithChallenge:(GameChallenge *)aChallenge tank:(int)aTankIndex
{
    CCScene *scene = [CCScene node];
    
    GameHudLayer *hud = [GameHudLayer node];
    [scene addChild:hud z:1000];
    
    GameTutorialLayer *tutLayer = nil;
    if (aChallenge.levelClass == [GameLevelTutorial class]) {
        tutLayer = [GameTutorialLayer node];
        [scene addChild:tutLayer z:1500];
    }
    
    WorldLayer *layer = [[[WorldLayer alloc] initWithHUD:hud challenge:aChallenge tank:aTankIndex] autorelease];
    layer.tag = 99;
    layer.tutorialLayer = tutLayer;
    [scene addChild: layer];

    if (tutLayer) {
        tutLayer.worldLayer = layer;
    }
    
    return scene;
}

- (id)initWithHUD:(GameHudLayer *)aHudLayer challenge:(GameChallenge *)aChallenge tank:(int)aTankIndex
{
	self = [super init];
    
    [[GameMusicPlayer getInstance] playNext];

    hudLayer = aHudLayer;

    destroyQueue = [[NSMutableArray arrayWithCapacity:100] retain];

    self.isMouseEnabled = YES;
    self.isKeyboardEnabled = YES;

    b2Vec2 gravity;
    gravity.Set(0.0f, 0.0f);
    world = new b2World(gravity);
    world->SetContinuousPhysics(true);

#ifdef WIREFRAME
    m_debugDraw = new GLESDebugDraw(PTM_RATIO);
    world->SetDebugDraw(m_debugDraw);
    uint32 flags = 0;
    flags += b2Draw::e_shapeBit;
    flags += b2Draw::e_jointBit;
    flags += b2Draw::e_aabbBit;
    flags += b2Draw::e_pairBit;
    flags += b2Draw::e_centerOfMassBit;
    m_debugDraw->SetFlags(flags);
#endif

    contactListener = new GameContactListener();
    world->SetContactListener(contactListener);
    
    players = [[NSMutableArray alloc] initWithCapacity:30];
    
    challenge = aChallenge;
    level = [[aChallenge.levelClass alloc] initWithLayer:self];

    [self spawnBots:challenge.numSpawnBots players:players excludeTankIndex:aTankIndex tier:challenge.tier];
    
    player = [[GamePlayer alloc] initWithLayer:self tank:aTankIndex];
    [player reset];
    [players addObject:player];
    
    [hudLayer setPlayersList:players];
    [hudLayer updatePlayersList];
    
    if (tutorialLayer) {
        player.collectStats = YES;
    }

    [self schedule: @selector(tick:)];
    [self schedule: @selector(secondTick:) interval:1.0f];

	return self;
}

- (void)spawnBots:(NSUInteger)aCount players:(NSMutableArray *)aPlayers excludeTankIndex:(NSUInteger)aExcludeTankIndex tier:(NSUInteger)aTier
{
    /* create tank index array */
    NSMutableArray *tankIndexList = [NSMutableArray arrayWithCapacity:numTanks - 1];
    for (NSUInteger i = 0; i < numTanks - 1; i++) {
        if (i != aExcludeTankIndex) {
            [tankIndexList addObject:[NSNumber numberWithInteger:i]];
        }
    }
    /* shuffle tank index array */
    NSUInteger count = [tankIndexList count];
    for (NSUInteger i = 0; i < count; ++i) {
        unsigned long nElements = count - i;
        unsigned long n = (random() % nElements) + i;
        [tankIndexList exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    
    /* spawn bots */
    for (NSUInteger i = 0; i < aCount; i++) {
        int botTankIndex = (int)[(NSNumber *)[tankIndexList objectAtIndex:i] integerValue];
        
        GameStartCoords *c = [level.startCoordsManager get];
        GameEnemy *e = [[GameEnemy alloc] initWithLayer:self tank:botTankIndex];
        
        switch (aTier) {
            case 1:
                [e setLevel:GameEnemyLevelEasy];
                break;
            case 2:
                [e setLevel:GameEnemyLevelMedium];
                break;
            default:
            case 3:
                [e setLevel:GameEnemyLevelHard];
                break;
        }
        
        [e resetWithStartCoords:c];
        [players addObject:e];
        [e release];
    }
}

- (void)dealloc
{
	delete world;
	world = nil;
	
    if (m_debugDraw) {
        delete m_debugDraw;
        m_debugDraw = nil;
    }
    
	[super dealloc];
}

- (void)draw
{
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	world->DrawDebugData();
	
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
}

- (void)secondTick:(ccTime)dt
{
    [hudLayer setTime:++secondCounter];
}

- (void)tick:(ccTime)dt
{
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	world->Step(dt, velocityIterations, positionIterations);
	
	for (b2Body* b = world->GetBodyList(); b; b = b->GetNext()) {
		if (b->GetUserData() == NULL) {
            continue;
        }
        
        GameUserData *userData = (GameUserData *)b->GetUserData();
        if (userData && userData.callTick) {
            GameObject *o = userData.object;
            [o tick:dt];
        }
	}
    
    std::vector<GameContact>::iterator pos;
    for (pos = contactListener->_contacts.begin(); pos != contactListener->_contacts.end(); ++pos) {
        GameContact contact = *pos;
        
        b2Body *bodyA = contact.bodyA;
        if (!bodyA) {
            continue;
        }
        b2Body *bodyB = contact.bodyB;
        if (!bodyB) {
            continue;
        }
        
        if (bodyA == bodyB) {
            continue;
        }
        
        if (bodyA->GetUserData() != NULL && bodyB->GetUserData() != NULL) {
            GameUserData *userData1 = (GameUserData *)bodyA->GetUserData();
            GameUserData *userData2 = (GameUserData *)bodyB->GetUserData();
            
            GameObject *o1 = userData1.object;
            GameObject *o2 = userData2.object;
            
            b2Filter filterA = contact.fixtureA->GetFilterData();
            b2Filter filterB = contact.fixtureB->GetFilterData();
            if (filterA.categoryBits == catTankSensor) {
                GameTank *tank = (GameTank *)userData1.object;
                [tank sensorContact:o2 begin:contact.begin fixture:contact.fixtureA];
                continue;
            }
            if (filterB.categoryBits == catTankSensor) {
                GameTank *tank = (GameTank *)userData2.object;
                [tank sensorContact:o1 begin:contact.begin fixture:contact.fixtureB];
                continue;
            }
            
            if (contact.begin) {
                [o1 contact:o2];
                [o2 contact:o1];
            }
        }
    }
    
    contactListener->_contacts.clear();

    for (GameObject *o in destroyQueue) {
        [o release];
    }
    
    [destroyQueue removeAllObjects];    
}

- (BOOL)ccKeyDown:(NSEvent *)event
{
    unsigned short keyCode = [event keyCode];
    
	if (keyCode == kVK_UpArrow || keyCode == kVK_ANSI_W) { player.moveUp = YES; } // Up
	if (keyCode == kVK_DownArrow || keyCode == kVK_ANSI_S) { player.moveDown = YES; } // Down
	if (keyCode == kVK_LeftArrow || keyCode == kVK_ANSI_A) { player.moveLeft = YES; } // Left
	if (keyCode == kVK_RightArrow || keyCode == kVK_ANSI_D) { player.moveRight = YES; } // Right
    
	return YES;
}

- (BOOL)ccKeyUp:(NSEvent *)event
{
    unsigned short keyCode = [event keyCode];
    
	if (keyCode == kVK_UpArrow || keyCode == kVK_ANSI_W) { player.moveUp = NO; } // Up
	if (keyCode == kVK_DownArrow || keyCode == kVK_ANSI_S) { player.moveDown = NO; } // Down
	if (keyCode == kVK_LeftArrow || keyCode == kVK_ANSI_A) { player.moveLeft = NO; } // Left
	if (keyCode == kVK_RightArrow || keyCode == kVK_ANSI_D) { player.moveRight = NO; } // Right

#ifdef LOG_KEYCODE
    NSLog(@"keyCode: %i", keyCode);
#endif

    if (keyCode == kVK_ANSI_1) { // 1: Machine Gun
        [player switchWeapon:kWeaponMachinegun];
    } else if (keyCode == kVK_ANSI_2) { // 2: Grenade
        [player switchWeapon:kWeaponGrenade];
    } else if (keyCode == kVK_ANSI_3) { // 3: Flame
        [player switchWeapon:kWeaponFlame];
    } else if (keyCode == kVK_ANSI_4) { // 4: Rocket
        [player switchWeapon:kWeaponRocket];
    } else if (keyCode == kVK_ANSI_5) { // 5: Mines
        [player switchWeapon:kWeaponMine];
    } else if (keyCode == kVK_ANSI_Q) { // Q: prev weapon
        [player prevWeapon];
    } else if (keyCode == kVK_ANSI_E) { // E: next weapon
        [player nextWeapon];
    } else if (keyCode == kVK_ANSI_M) { // M: play next song
        [[GameMusicPlayer getInstance] playNext];
    }

    else if (keyCode == kVK_Escape) { // ESC: Menu
        [self showMenu];
    }
    else if (keyCode == kVK_Space && fragLimitReached) { // SPACE: exit to menu if fraglimit is reached
        [[CCDirector sharedDirector] popScene];
    }
    else if (keyCode == kVK_Space && tutorialLayer) { // SPACE: continue in tutorial
        [tutorialLayer playerReturn];
    }

#ifdef ALLOW_CHEATS
    else if (keyCode == kVK_ANSI_V) { // V: reset player
        [player reset];
    }
    else if (keyCode == kVK_ANSI_B) { // B: spawn enemy at cursor pos
        NSLog(@"new enemy");
        GameStartCoords *c = [[GameStartCoords alloc] initWithCoords:self.position.x y:self.position.y rotate:0];
        GameEnemy *e = [[GameEnemy alloc] initWithLayer:self tank:-1];
        [e resetWithStartCoords:c];
        [players addObject:e];
        [hudLayer updatePlayersList];
        [e release];
        [c release];
    }
    else if (keyCode == kVK_ANSI_H) { // H: spawn enemy at random start point
        GameStartCoords *c = [level.startCoordsManager get];
        GameEnemy *e = [[GameEnemy alloc] initWithLayer:self tank:-1];
        [e resetWithStartCoords:c];        
        [players addObject:e];
        [hudLayer updatePlayersList];
        [e release];
    }
    else if (keyCode == kVK_ANSI_N) { // N: spawn pickup
        GameItemType t = (GameItemType) ((arc4random() % (numItems - 1)) + 1);
        [level registerItemWithCoords:ccp(mouseLoc.x - self.position.x, mouseLoc.y - self.position.y) type:t];
    }
    else if (keyCode == kVK_ANSI_P) { // P: more AMMO
        NSLog(@"AMMO!!!");
        [player.armory cheat];
        [hudLayer setWeapon:player.armory.selectedWeapon];
    }
    else if (keyCode == kVK_ANSI_O) { // O: repair cheat
        [player cheat];    
    }
    else if (keyCode == kVK_ANSI_X) { // X: add frags
        [player increaseFragsByWeapon:kWeaponMachinegun];
        if (tutorialLayer) {
            [tutorialLayer next];
        }
    }
    else if (keyCode == kVK_ANSI_F) { // F: freeze (fuer screenshots)
        if ([[CCDirector sharedDirector] isPaused]) {
            [[CCDirector sharedDirector] resume];
        } else {
            [[CCDirector sharedDirector] pause];
        }
    }
    else if (keyCode == kVK_ANSI_G) { // G: save screenshot
//        CCScene *scene = [[CCDirector sharedDirector] runningScene];
//        CCNode *startNode = [scene.children objectAtIndex:0];
//        CGSize winSize = [CCDirector sharedDirector].winSize;
//        CCRenderTexture* rtx = [CCRenderTexture renderTextureWithWidth:winSize.width height:winSize.height];
//        [rtx begin];
//        [startNode visit];
//        [rtx end];
//        
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES);
//        NSString *desktopDirectory = [paths objectAtIndex:0];
//        NSString *pngPath = [desktopDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"new%d.png", 1]];
//        [rtx saveToFile:pngPath format:kCCImageFormatPNG];
    }
#endif
    
	return YES;
}

- (void)showMenu
{
    [[CCDirector sharedDirector] pushScene:[PauseLayer scene]];
}

- (BOOL)ccMouseMoved:(NSEvent *)event
{
	mouseLoc = [(CCDirectorMac*)[CCDirector sharedDirector] convertEventToGL:event];
    [player moveTurret:mouseLoc];
    
    return NO;
}

- (BOOL)ccMouseDragged:(NSEvent *)event
{
	mouseLoc = [(CCDirectorMac*)[CCDirector sharedDirector] convertEventToGL:event];
    [player moveTurret:mouseLoc];
    
    return NO;
}

- (BOOL)ccMouseDown:(NSEvent *)event
{
	mouseLoc = [(CCDirectorMac*)[CCDirector sharedDirector] convertEventToGL:event];
    [player moveTurret:mouseLoc];
    player.fire = YES;
    
	return NO;
}

- (BOOL)ccMouseUp:(NSEvent *)event
{
    player.fire = NO;
    
    return NO;
}

- (BOOL)ccRightMouseUp:(NSEvent *)event
{
    [player nextWeapon];    
    
    return NO;
}

- (BOOL)ccScrollWheel:(NSEvent *)event
{
    if (event.deltaY > 0 || event.deltaX > 0) {
        [player nextWeapon];
    } else if (event.deltaY < 0 || event.deltaX > 0) {
        [player prevWeapon];        
    }
    
    return NO;
}

- (void)incTotalFrags
{
    totalFrags++;
}

- (void)checkFragLimit:(GameTank *)aTank
{
    if (fragLimitReached) {
        return;
    }

    if (challenge.fragLimit == 0) {
        return;
    }

    if (aTank.frags < challenge.fragLimit) {
        return;
    }
    
    for (GameTank *tank in players) {
        if ([tank isKindOfClass:[GameEnemy class]]) {
            GameEnemy *enemy = (GameEnemy *)tank;
            enemy.friendly = YES;
        }
        
        if ([tank isKindOfClass:[GamePlayer class]]) {
            GamePlayer *aPlayer = (GamePlayer *)tank;
            aPlayer.canFire = NO;
        }
    }
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;

    NSString *text1;
    NSString *text2;
    
    if ([aTank isKindOfClass:[GamePlayer class]]) {
        text1 = @"VICTORY";
        text2 = [NSString stringWithFormat:@"You have won the match with %ld frags\n\nPress SPACEBAR to exit", (unsigned long)challenge.fragLimit];
        
        [[GameStats getInstance] incInt:@"victoryCount"];        
        [challenge markAsDone:secondCounter];
        
        if (player.statCollectRepair == 0) {
            [[GameStats getInstance] incInt:@"finishWithoutRepair"];
            [[GameStats getInstance] incInt:[NSString stringWithFormat:@"finishWithoutRepairTier%ld", (unsigned long)challenge.tier]];
        }
        
        if (secondCounter <= (5 * 60)) {
            [[GameStats getInstance] incInt:@"finishFast5"];
            [[GameStats getInstance] incInt:[NSString stringWithFormat:@"finishFast5Tier%ld", (unsigned long)challenge.tier]];
        }
    } else {
        NSString *tankLabel = GameTankLabels[aTank.tankIndex];
        text1 = @"DEFEAT";
        text2 = [NSString stringWithFormat:@"%@ wins the match with %ld frags\n\nPress SPACEBAR to exit", tankLabel, (unsigned long)challenge.fragLimit];
        
        [[GameStats getInstance] incInt:@"defeatCount"];
    }

    CCLabelBMFont *l;
    l = [CCLabelBMFont labelWithString:text1 fntFile:GameFontBig];
    l.opacity = 200.0f;
    l.anchorPoint = ccp(0, 1.0f);
    l.anchorPoint = ccp(0.5f, 0.5f);
    l.position = ccp(screenSize.width / 2.0f, screenSize.height / 2.0f + 50.0f);
    [hudLayer addChild:l z:20];
    
    CCLabelBMFont *l2;
    l2 = [CCLabelBMFont labelWithString:text2 fntFile:GameFontDefault];
    l2.opacity = 200.0f;
    l2.anchorPoint = ccp(0, 1.0f);
    l2.anchorPoint = ccp(0.5f, 0.5f);
    l2.position = ccp(screenSize.width / 2.0f, screenSize.height / 2.0f - 50.0f);
    l2.alignment = kCCTextAlignmentCenter;
    [hudLayer addChild:l2 z:20];
    
    fragLimitReached = YES;
    
    [[GameStats getInstance] synchronize];
}

@end
