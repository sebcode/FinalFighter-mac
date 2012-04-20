
#import <Foundation/Foundation.h>

@interface GameAchievement : NSObject
{
    NSString *label;
    NSString *trigger;
    NSUInteger triggerMin;
}

- (BOOL)isDone;

@property (retain) NSString *label;
@property (retain) NSString *trigger;
@property (readwrite) NSUInteger triggerMin;

@end
