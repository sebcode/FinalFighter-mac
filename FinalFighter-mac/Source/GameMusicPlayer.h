
#import <Foundation/Foundation.h>

@interface GameMusicPlayer : NSObject
{
    NSMutableArray *tracks;
    NSUInteger nextIndex;
    BOOL isMenuMusicPlaying;
    BOOL switchingTrack;
}

+ (GameMusicPlayer *)getInstance;
+ (void)createInstance;
- (void)playNext;
- (void)playMenuMusic;
- (void)setVolume:(float)val;

@end
