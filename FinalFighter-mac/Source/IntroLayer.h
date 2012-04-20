
#import "CCLayer.h"
#import "cocos2d.h"

enum GameIntroState {
    GameIntroStatePreIntro,
    GameIntroStateLoading,
    GameIntroStateLoaded,
    GameIntroStateIntro
};
typedef enum GameIntroState GameIntroState;

@interface IntroLayer : CCLayer
{
    GameIntroState state;
    CCSprite *sprite;
}

+ (CCScene *)scene;

@end
