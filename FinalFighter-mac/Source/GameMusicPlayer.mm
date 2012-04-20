
#import "GameMusicPlayer.h"
#import "SimpleAudioEngine.h"
#import "GameConstants.h"
#import "CDAudioManager.h"

@implementation GameMusicPlayer

NSString *GameMusicMenuSong = @"blade_of_fire";

static GameMusicPlayer *sharedMusicPlayer;

+ (GameMusicPlayer *)getInstance
{
    return sharedMusicPlayer;
}

+ (void)createInstance
{
    static BOOL initialized = NO;
    
    if (!initialized) {
        initialized = YES;
        sharedMusicPlayer = [[GameMusicPlayer alloc] init];
    }
}

- (id)init
{
    self = [super init];
    if (!self) {
        return self;
    }

    [CDAudioManager initAsynchronously:kAMM_FxPlusMusicIfNoOtherAudio];
    tracks = [[[NSMutableArray alloc] init] retain];
    [self preload];
    
    [[CDAudioManager sharedManager] setBackgroundMusicCompletionListener:self selector:@selector(backgroundMusicFinished)];
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
    
    [tracks release];
    tracks = nil;
}

- (void)setVolume:(float)val
{
    [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:val];
}

- (void)preload
{
    [tracks removeAllObjects];
    
    NSString *resourcesPath = [[NSBundle mainBundle] resourcePath];
    
    for (NSString *file in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:resourcesPath error:nil]) {
        if (![file hasSuffix: @".mp3"]) {
            continue;
        }

        if ([file hasPrefix:@"test_"]) { // DEBUG
            continue;
        }
        
        NSString *name = [file stringByDeletingPathExtension];
        if ([name isEqualToString:GameMusicMenuSong]) {
            continue;
        }
        
        NSString *absFile = [resourcesPath stringByAppendingFormat:@"/%@", file];
        [tracks addObject:absFile];
    }
    
    [self shuffle];
}

- (void)shuffle
{
    NSUInteger count = [tracks count];
    for (NSUInteger i = 0; i < count; ++i) {
        NSUInteger nElements = count - i;
        NSUInteger n = (random() % nElements) + i;
        [tracks exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

- (void)playMenuMusic
{
#ifdef NO_MUSIC
    return;
#endif

    if (isMenuMusicPlaying) {
        return;
    }
    
    isMenuMusicPlaying = YES;
    switchingTrack = YES;
    
    CDAudioManager *am = [CDAudioManager sharedManager];
    [am stopBackgroundMusic];
    [am rewindBackgroundMusic];
    [am playBackgroundMusic:[NSString stringWithFormat:@"%@.mp3", GameMusicMenuSong] loop:NO];
    
    switchingTrack = NO;
}

- (void)backgroundMusicFinished
{
    if (switchingTrack) {
        return;
    }

    if (isMenuMusicPlaying) {
        return;
    }
    
    [self playNext];
}

- (void)playNext
{
#ifdef NO_MUSIC
    return;
#endif

    NSString *absFile = [tracks objectAtIndex:nextIndex];

    switchingTrack = YES;
    
    CDAudioManager *am = [CDAudioManager sharedManager];
    [am stopBackgroundMusic];
    [am rewindBackgroundMusic];
    [am playBackgroundMusic:absFile loop:NO];
    //NSLog(@"%ld %@", nextIndex, absFile);
    
    if (++nextIndex >= [tracks count]) {
        nextIndex = 0;
    }
    
    isMenuMusicPlaying = NO;
    switchingTrack = NO;
}

@end
