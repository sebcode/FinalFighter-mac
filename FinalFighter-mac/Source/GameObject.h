
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "WorldLayer.h"

enum {
    catNone = 0,
    catWall = 1,
    catTank = 2,
    catAmmo = 4,
    catItem = 8,
    catTankSensor = 16,
    catAll = 0xffff
};

@interface GameObject : NSObject
{
    WorldLayer *layer;
    b2World *world;  
    b2Body *body;
    b2Fixture *fixture;
    CCSprite *sprite;
    uint16 category;
    
    BOOL destroying;
}

@property (assign) WorldLayer *layer;
@property (assign) b2World *world;
@property (readonly) uint16 category;
@property (readonly) CCSprite *sprite;

- (id)initWithLayer:(WorldLayer *)aLayer;
- (void)destroy;
- (void)tick:(ccTime)dt;
- (void)contact:(GameObject *)object;

@end
