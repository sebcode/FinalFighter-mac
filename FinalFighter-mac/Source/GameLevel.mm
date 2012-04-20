
#import "GameLevel.h"
#import "GameItem.h"
#import "GameDecoration.h"
#import "GameConstants.h"
#import "GameUserData.h"

@implementation GameLevel
@synthesize startCoordsManager;

- (id)initWithLayer:(WorldLayer *)aLayer
{
	self = [super initWithLayer:aLayer];
    if (!self) {
        return nil;
    }
    
    category = catWall;
    
    NSString *filename = [self getFilename];
    
    startCoordsManager = [[[GameStartCoordsManager alloc] init] retain];
    
    decorations = [[NSMutableArray arrayWithCapacity:10] retain];
    items = [[NSMutableArray arrayWithCapacity:50] retain];

    sprite = [CCSprite spriteWithFile:filename];
    sprite.anchorPoint = ccp(0, 0);
    sprite.position = ccp(0, 0);
    [layer addChild: sprite];

#ifdef WIREFRAME
    sprite.visible = NO;
#endif
    
    b2BodyDef groundBodyDef;
    groundBodyDef.position.Set(0, 0);
    groundBodyDef.userData = [GameUserData userDataWithObject:self];
    
    b2Body* groundBody = world->CreateBody(&groundBodyDef);
    b2EdgeShape groundBox;
    
    CGSize contentSize = [self getSize];
    
    // bottom
    groundBox.Set(b2Vec2(0, 0), b2Vec2(contentSize.width / PTM_RATIO, 0));
    groundBody->CreateFixture(&groundBox, 0);
    // top
    groundBox.Set(b2Vec2(0, contentSize.height / PTM_RATIO), b2Vec2(contentSize.width / PTM_RATIO, contentSize.height / PTM_RATIO));
    groundBody->CreateFixture(&groundBox, 0);
    // left
    groundBox.Set(b2Vec2(0, contentSize.height / PTM_RATIO), b2Vec2(0, 0));
    groundBody->CreateFixture(&groundBox, 0);
    // right
    groundBox.Set(b2Vec2(contentSize.width / PTM_RATIO, contentSize.height / PTM_RATIO), b2Vec2(contentSize.width / PTM_RATIO, 0));
    groundBody->CreateFixture(&groundBox, 0);
    
    // level
    b2BodyDef levBodyDef;
    levBodyDef.position.Set(0, 0);
    levBodyDef.userData = [GameUserData userDataWithObject:self];
    levBody = world->CreateBody(&levBodyDef);
    
    [self createCollisionMap];
    
    [self createItems];

    return self;
}

- (void)dealloc
{
    [items release];
    items = nil;
    
    [decorations release];
    decorations = nil;
    
    [startCoordsManager release];
    startCoordsManager = nil;
    
    if (sprite) {
        [[CCTextureCache sharedTextureCache] removeTexture: sprite.texture];
    }
    
    [super dealloc];
}

- (CGSize)getSize
{
    return sprite.contentSize;
}

- (void)registerPlayerStartCoords:(CGPoint)coords rotate:(float)rotate
{
    GameStartCoords *c = [[[GameStartCoords alloc] initWithCoords:coords.x y:coords.y rotate:rotate] autorelease];
    [startCoordsManager add:c];
}

- (void)registerItemWithCoords:(CGPoint)coords type:(GameItemType)aType
{
    GameItem *item = [[GameItem alloc] initWithPosition:coords type:aType layer:layer];
    [items addObject:item];
    [item release];
}

- (void)registerDecorationWithCoords:(CGPoint)coords type:(GameDecorationType)aType
{
    GameDecoration *d = [[GameDecoration alloc] initWithPosition:coords type:aType layer:layer];
    [decorations addObject:d];
    [d release];
}

- (void)createCollisionMap
{
    /* abstract */
}

- (void)createItems
{
    /* abstract */
}

- (NSString *)getFilename;
{
    /* abstract */
    return @"";
}

+ (NSString *)getLabel;
{
    /* abstract */
    return @"";
}

+ (int)menuImageIndex;
{
    return LEVEL_FRAGTEMPLE_IMAGE_INDEX;
}

@end
