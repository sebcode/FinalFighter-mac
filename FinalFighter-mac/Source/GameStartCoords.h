
#import <Foundation/Foundation.h>

@interface GameStartCoords : NSObject
{
    float x;
    float y;
    float rotate;
}

- (id)initWithCoords:(float)aX y:(float)aY rotate:(float)aRotate;

@property (readonly) float x;
@property (readonly) float y;
@property (readonly) float rotate;

@end
