
#import "GameConstants.h"
#import "GameSoundPlayer.h"
#import "SimpleAudioEngine.h"

@implementation GameSoundPlayer

static GameSoundPlayer *sharedGameSoundPlayer;

+ (GameSoundPlayer *)getInstance
{
    return sharedGameSoundPlayer;
}

+ (void)createInstance
{
    static BOOL initialized = NO;
    if (!initialized) {
        initialized = YES;
        sharedGameSoundPlayer = [[GameSoundPlayer alloc] init];
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        sounds = [[[NSMutableDictionary alloc] init] retain];
        [self preload];
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
    
    [sounds release];
    sounds = nil;
}

- (void)preload
{
    [sounds removeAllObjects];
    
    NSString *resourcesPath = [[NSBundle mainBundle] resourcePath];
    
    for (NSString *file in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:resourcesPath error:nil]) {
        if (![file hasSuffix: @".wav"]) {
            continue;
        }

        NSString *absFile = [resourcesPath stringByAppendingFormat:@"/%@", file];
        NSString *name = [file stringByDeletingPathExtension];
        
        [[SimpleAudioEngine sharedEngine] preloadEffect:absFile];
        [sounds setObject:absFile forKey:name];
    }
}

- (void)setVolume:(float)val
{
    [[SimpleAudioEngine sharedEngine] setEffectsVolume:val];
}

- (BOOL)play:(NSString *)name
{
#ifdef NO_SOUNDS
    return NO;
#endif

    NSString *absFile = [sounds valueForKey:name];

    if (!absFile) {
        NSLog(@"SoundEngine: Sound not found: %@", name);
        return false;
    }

    [[SimpleAudioEngine sharedEngine] playEffect:absFile];

    return YES;
}

@end
