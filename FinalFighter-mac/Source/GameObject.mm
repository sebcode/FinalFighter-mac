
#import "GameObject.h"
#import "GameUserData.h"

@implementation GameObject
@synthesize world;
@synthesize layer;
@synthesize category;
@synthesize sprite;

- (id)initWithLayer:(WorldLayer *)aLayer
{
    self = [super init];
    if (!self) {
        return self;
    }
    
    layer = aLayer;
    world = aLayer.world;
    
    return self;
}

- (void)dealloc
{
    if (sprite) {
        [sprite removeFromParentAndCleanup:YES];
        sprite = nil;
    }
    
    if (body) {
        GameUserData *userData = (GameUserData *)body->GetUserData();
        if (userData) {
            [userData release];
            body->SetUserData(NULL);
        }
    
        world->DestroyBody(body);
        body = nil;
    }
    
    [super dealloc];
}

- (void)destroy
{
    if (!layer || destroying) {
        return;
    }
    
    [layer.destroyQueue addObject:self];
    destroying = YES;
}

- (void)tick:(ccTime)dt
{
    /* abstract */
}

- (void)contact:(GameObject *)object
{
    /* abstract */
}

@end
