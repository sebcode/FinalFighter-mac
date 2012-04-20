
#import "GameMenuPageSettings.h"
#import "GameFont.h"
#import "GameMenuItemLabel.h"
#import "GameMenu.h"
#import "GameSoundPlayer.h"
#import "GameConstants.h"
#import "GameMusicPlayer.h"

@implementation GameMenuPageSettings

- (id)init
{
    self = [super init];
    if (!self) {
        return self;
    }

    CCSprite *sprite;
    sprite = [CCSprite spriteWithSpriteFrameName:@"menu_settings.png"];
    sprite.anchorPoint = ccp(0, 0);
    [self addChild:sprite];

    CCLabelBMFont *font;
    GameMenu *menu;
    
    font = [CCLabelBMFont labelWithString:@"[ - ]" fntFile:GameFontDefault];
    font.alignment = kCCTextAlignmentCenter;
    font.color = ccc3(150.0f, 150.0f, 150.0f);    
    GameMenuItemLabel *i1 = [GameMenuItemLabel itemWithLabel:font block:^(id sender) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        long volume = [defaults integerForKey:@"SoundVolume"];
        volume -= 10;
        
        if (volume <= 0) {
            volume = 0;
        }
        
        [defaults setInteger:volume forKey:@"SoundVolume"];
        [self update];
    }];
    i1.position = ccp(50.0f, 155.0f);

    font = [CCLabelBMFont labelWithString:@"[ + ]" fntFile:GameFontDefault];
    font.alignment = kCCTextAlignmentCenter;
    font.color = ccc3(150.0f, 150.0f, 150.0f);    
    GameMenuItemLabel *i2 = [GameMenuItemLabel itemWithLabel:font block:^(id sender) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        long volume = [defaults integerForKey:@"SoundVolume"];
        volume += 10;
        
        if (volume >= 100) {
            volume = 100;
        }
        
        [defaults setInteger:volume forKey:@"SoundVolume"];
        [self update];
    }];
    i2.position = ccp(250.0f, 155.0f);

    font = [CCLabelBMFont labelWithString:@"[ - ]" fntFile:GameFontDefault];
    font.alignment = kCCTextAlignmentCenter;
    font.color = ccc3(150.0f, 150.0f, 150.0f);    
    GameMenuItemLabel *i3 = [GameMenuItemLabel itemWithLabel:font block:^(id sender) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        long volume = [defaults integerForKey:@"MusicVolume"];
        volume -= 10;
        
        if (volume <= 0) {
            volume = 0;
        }
        
        [defaults setInteger:volume forKey:@"MusicVolume"];
        [self update];
    }];
    i3.position = ccp(50.0f, 85.0f);
    
    font = [CCLabelBMFont labelWithString:@"[ + ]" fntFile:GameFontDefault];
    font.alignment = kCCTextAlignmentCenter;
    font.color = ccc3(150.0f, 150.0f, 150.0f);    
    GameMenuItemLabel *i4 = [GameMenuItemLabel itemWithLabel:font block:^(id sender) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        long volume = [defaults integerForKey:@"MusicVolume"];
        volume += 10;
        
        if (volume >= 100) {
            volume = 100;
        }
        
        [defaults setInteger:volume forKey:@"MusicVolume"];
        [self update];
    }];
    i4.position = ccp(250.0f, 85.0f);
    
    menu = [GameMenu menuWithItems:i1, i2, i3, i4, nil];
    menu.position = ccp(0.0f, 0.0f);
    [self addChild:menu];

    font = [CCLabelBMFont labelWithString:@"100%" fntFile:GameFontMenuSmall];
    font.alignment = kCCTextAlignmentCenter;
    font.position = ccp(155.0f, 155.0f);
    [self addChild:font];
    soundVolLabel = font;

    font = [CCLabelBMFont labelWithString:@"100%" fntFile:GameFontMenuSmall];
    font.alignment = kCCTextAlignmentCenter;
    font.position = ccp(155.0f, 85.0f);
    [self addChild:font];
    musicVolLabel = font;

    [self update];

    return self;
}

- (void)update
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    long soundVolume = [defaults integerForKey:@"SoundVolume"];
    if (soundVolume == 0) {
        soundVolLabel.string = @"Off";
    } else {
        soundVolLabel.string = [NSString stringWithFormat:@"%li%%", soundVolume];
    }
    
    [[GameSoundPlayer getInstance] setVolume:(soundVolume / 100.0f)];
    
    long musicVolume = [defaults integerForKey:@"MusicVolume"];
    if (musicVolume == 0) {
        musicVolLabel.string = @"Off";
    } else {
        musicVolLabel.string = [NSString stringWithFormat:@"%li%%", musicVolume];
    }
    
    [[GameMusicPlayer getInstance] setVolume:(musicVolume / 100.0f)];
}

@end
