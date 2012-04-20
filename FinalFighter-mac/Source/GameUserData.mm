
#import "GameUserData.h"
#import "GameObject.h"

@implementation GameUserData
@synthesize object;
@synthesize type;
@synthesize callTick;

+ (id)userDataWithObject:(GameObject *)aObject
{
    GameUserData *userData = [[GameUserData alloc] init];
    userData.object = aObject;
    userData.callTick = YES;
    return userData;
}

+ (id)userDataWithObject:(GameObject *)aObject doTick:(BOOL)aDoTick
{
    GameUserData *userData = [[GameUserData alloc] init];
    userData.object = aObject;
    userData.callTick = aDoTick;
    return userData;
}

@end
