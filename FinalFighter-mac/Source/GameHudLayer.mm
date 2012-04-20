
#import "GameHudLayer.h"
#import "GameFont.h"
#import "GameTank.h"
#import "GamePlayer.h"

@implementation GameHudLayer

- (id)init
{
	self = [super init];
    if (!self) {
        return self;
    }

    screenSize = [CCDirector sharedDirector].winSize;
    
    weaponSprite = [CCSprite spriteWithSpriteFrameName:@"weapon_0.png"];
    weaponSprite.position = ccp(30, screenSize.height - 30);
    weaponSprite.opacity = 150;
    [self addChild:weaponSprite z:10];

    healthSprite = [CCSprite spriteWithSpriteFrameName:@"hud_health.png"];
    healthSprite.position = ccp(screenSize.width - 34, screenSize.height - 20);
    healthSprite.opacity = 150;
    [self addChild:healthSprite z:10];

    healthLabel = [CCLabelBMFont labelWithString:@"" fntFile:GameFontDefault];
    healthLabel.opacity = 150;
    [self addChild:healthLabel z:20];
    healthLabel.position = ccp(screenSize.width - 25, screenSize.height - 20);

    fragSprite = [CCSprite spriteWithSpriteFrameName:@"hud_fragskull.png"];
    fragSprite.position = ccp(screenSize.width - 34, screenSize.height - 60);
    fragSprite.opacity = 150;
    [self addChild:fragSprite z:10];

    fragLabel = [CCLabelBMFont labelWithString:@"0" fntFile:GameFontDefault];
    fragLabel.opacity = 150;
    [self addChild:fragLabel z:20];
    fragLabel.position = ccp(screenSize.width - 25, screenSize.height - 60);

    /* weapon label (machine gun) */
    ammoLabel = [CCLabelBMFont labelWithString:@"" fntFile:GameFontDefault];
    ammoLabel.opacity = 150;
    ammoLabel.anchorPoint = ccp(0, 0);
    [self addChild:ammoLabel z:20];
    ammoLabel.position = ccp(60, screenSize.height - 30);

    /* remaining ammo count */
    ammoLabel2 = [CCLabelBMFont labelWithString:@"" fntFile:GameFontDefault];
    ammoLabel2.opacity = 150;
    ammoLabel2.anchorPoint = ccp(0, 0);
    [self addChild:ammoLabel2 z:20];
    ammoLabel2.position = ccp(60, screenSize.height - 53);
    
    timeLabel = [CCLabelBMFont labelWithString:@"0:00" fntFile:GameFontSmall];
    timeLabel.opacity = 150;
    timeLabel.anchorPoint = ccp(0, 0);
    [self addChild:timeLabel z:20];
    timeLabel.position = ccp(screenSize.width - 40, 3);

    playersLabel = [CCLabelBMFont labelWithString:@"" fntFile:GameFontMini];
    playersLabel.opacity = 150;
    playersLabel.anchorPoint = ccp(0, 1.0f);
    [self addChild:playersLabel z:20];
    playersLabel.position = ccp(10.0f, screenSize.height - 80.0f);

    return self;
}

- (void)setWeapon:(GameWeapon *)aWeapon
{
    ammoLabel.string = aWeapon.label;
    
    [weaponSprite setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"weapon_%d.png", aWeapon.type]]];
    
    if (aWeapon.hasInfiniteAmmo) {
        ammoLabel2.string = @"";
    } else {
        ammoLabel2.string = [NSString stringWithFormat:@"%i", aWeapon.ammo];
    }
}

- (void)setHealth:(int)aHealth
{
    healthLabel.string = [NSString stringWithFormat:@"%i", aHealth];
}

- (void)setFrags:(int)aFrags
{
    fragLabel.string = [NSString stringWithFormat:@"%i", aFrags];
}

- (void)setTime:(int)aSeconds
{
    int m = round(aSeconds / 60);
    int s = aSeconds % 60;
    
    timeLabel.string = [NSString stringWithFormat:@"%i:%02i", m, s];
}

#pragma mark - Player List

- (void)setPlayersList:(NSArray *)aList
{
    playersList = aList;
}

- (void)updatePlayersList
{
    if (!playersList) {
        return;
    }
    
    if (playersList.count == 1) {
        return;
    }

    NSArray *sortedArray = [playersList sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        GameTank *aTank = (GameTank *)a;
        GameTank *bTank = (GameTank *)b;
        int aFrags = aTank.frags;
        int bFrags = bTank.frags;
        
        if (aFrags == bFrags) {
            return NSOrderedSame;
        } else if (aFrags < bFrags) {
            return NSOrderedDescending;
        }
        
        return NSOrderedAscending;
    }];

    NSMutableString *text = [NSMutableString stringWithString:@""];
    
    for (GameTank *p in sortedArray) {
        NSString *tankName;
        
        if ([p isKindOfClass:[GamePlayer class]]) {
            tankName = @"PLAYER";
        } else {
            tankName = GameTankLabels[p.tankIndex];
        }
        
        NSString *line = [NSString stringWithFormat:@"%d   %@\n", p.frags, tankName];
        [text appendString:line];
    }
    
    playersLabel.string = text;
}

@end
