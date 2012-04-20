
#import "AppDelegate.h"
#import "WorldLayer.h"
#import "IntroLayer.h"
#import "MenuLayer.h"
#import "GameDebug.h"
#import "GameStats.h"
#import "GameSoundPlayer.h"
#import "GameMusicPlayer.h"

@implementation FinalFighter_macAppDelegate
@synthesize window=window_, glView=glView_;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    srandom((unsigned int)time(NULL));

	CCDirectorMac *director = (CCDirectorMac *)[CCDirectorMac sharedDirector];
#ifdef DISPLAY_STATS
	[director setDisplayStats:YES];
#endif
	[director setView:glView_];
	[director setResizeMode:kCCDirectorResize_AutoScale];
	[window_ setAcceptsMouseMovedEvents:YES];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"menu.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"sprites.plist"];
    
    [GameMusicPlayer createInstance];
    [GameSoundPlayer createInstance];
    
    [self readUserDefaults];

    [[GameMusicPlayer getInstance] playMenuMusic];

#ifndef START_WINDOW_MODE
    [self toggleFullScreen:nil];
#endif
    
    GameStats *stats = [GameStats getInstance];
    [stats incInt:@"startups"];

	START_SCENE;
}

- (void)readUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *def = [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSNumber numberWithInt:100], @"SoundVolume",
                         [NSNumber numberWithInt:100], @"MusicVolume",
                         nil];
    
    [defaults registerDefaults:def];

    [[GameSoundPlayer getInstance] setVolume:[defaults floatForKey:@"SoundVolume"]];
    [[GameMusicPlayer getInstance] setVolume:[defaults floatForKey:@"MusicVolume"]];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
	return YES;
}

- (void)dealloc
{
    [[GameStats getInstance] synchronize];
    
	[[CCDirector sharedDirector] end];
	[window_ release];
	[super dealloc];
}

#pragma mark AppDelegate - IBActions

- (IBAction)toggleFullScreen:(id)sender
{
    CCGLView *view = [[CCDirector sharedDirector] view];
	if (![view isInFullScreenMode]) {
		[view enterFullScreenMode:[NSScreen mainScreen] withOptions: nil];
	} else {
		[view exitFullScreenModeWithOptions:nil];
		[view.window makeFirstResponder: view];
	}    
}

@end
