
#import <Foundation/Foundation.h>

@interface GameStats : NSObject
{
    NSUserDefaults *defaults;
}

+ (GameStats *)getInstance;

- (void)incInt:(NSString *)key;
- (void)setInt:(NSInteger)intValue forKey:(NSString *)key;
- (NSInteger)getInt:(NSString *)key;
- (void)synchronize;

@end
