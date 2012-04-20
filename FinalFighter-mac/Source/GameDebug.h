
#import "GameConstants.h"

#ifndef FinalFighter_GameDebug_h
#define FinalFighter_GameDebug_h

@class GameLevelTutorial;
@class GameLevelFragtemple;
@class GameLevelOverkillz;
@class GameLevelHauntedHalls;

#ifdef PRODUCTION_BUILD
    #define START_SCENE [director runWithScene:[IntroLayer scene]];
#else
    #define START_SCENE [director runWithScene:[IntroLayer scene]];
    //#define START_SCENE [director runWithScene:[MenuLayer scene]];
    //#define START_SCENE [director runWithScene:[WorldLayer sceneWithLevel:[GameLevelTutorial class] tank:1]];
    //#define START_SCENE [director runWithScene:[WorldLayer sceneWithLevel:[GameLevelFragtemple class] tank:1]];
    //#define START_SCENE [director runWithScene:[WorldLayer sceneWithLevel:[GameLevelOverkillz class] tank:1]];
    //#define START_SCENE [director runWithScene:[WorldLayer sceneWithLevel:[GameLevelHauntedHalls class] tank:1]];
#endif

#endif
