
#import <Foundation/Foundation.h>

@class GameObject;

@interface GameUserData : NSObject
{
    GameObject *object;
    int type;
    BOOL callTick;
}

@property (assign) GameObject *object;
@property (readwrite) int type;
@property (readwrite) BOOL callTick;

+ (id)userDataWithObject:(GameObject *)aObject;
+ (id)userDataWithObject:(GameObject *)aObject doTick:(BOOL)aDoTick;

@end
