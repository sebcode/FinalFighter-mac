
#import <Foundation/Foundation.h>
#import "GameStartCoords.h"

@interface GameStartCoordsManager : NSObject
{
    NSMutableArray *coordList;
    int nextIndex;
}

- (void)add:(GameStartCoords *)aCoords;
- (GameStartCoords *)get;

@end
