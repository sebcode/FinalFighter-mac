
#import "GameStartCoords.h"

@implementation GameStartCoords
@synthesize x;
@synthesize y;
@synthesize rotate;

- (id)initWithCoords:(float)aX y:(float)aY rotate:(float)aRotate
{
    self = [super init];

    x = aX;
    y = aY;
    rotate = aRotate;
    
    return self;
}

@end
