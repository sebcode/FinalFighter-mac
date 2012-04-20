
#import "GameStartCoordsManager.h"
#import "GameStartCoords.h"

@implementation GameStartCoordsManager

- (id)init
{
    self = [super init];
    
    coordList = [[NSMutableArray alloc] initWithCapacity:30];
    
    return self;
}

- (void)add:(GameStartCoords *)aCoords
{
    [coordList addObject:aCoords];
}

- (void)shuffle
{
    NSUInteger count = [coordList count];
    for (NSUInteger i = 0; i < count; ++i) {
        unsigned long nElements = count - i;
        unsigned long n = (random() % nElements) + i;
        [coordList exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

- (GameStartCoords *)get
{
    /* list empty? return default coords */
    if (![coordList count]) {
        GameStartCoords *c = [[GameStartCoords alloc] initWithCoords:100.0f y:100.0f rotate:0];
        [c autorelease];
        return c;
    }
    
    /* shuffle on each loopover */
    if (nextIndex == 0) {
        [self shuffle];
    }
    
    GameStartCoords *c = [coordList objectAtIndex:nextIndex];
    
    nextIndex++;
    
    if (nextIndex >= [coordList count]) {
        nextIndex = 0;
    }
    
    return c;
}

@end
