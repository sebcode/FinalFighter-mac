
#import "GameMenuItemImage.h"
#import "GameSoundPlayer.h"

@implementation GameMenuItemImage
@synthesize onSelectSelector;
@synthesize onUnselectSelector;
@synthesize selectorTarget;
@synthesize tooltip;

- (void)selected
{
	[super selected];

    if (onSelectSelector && selectorTarget) {
        [[GameSoundPlayer getInstance] play:@"menu_hover"];
        [selectorTarget performSelector:onSelectSelector withObject:self];
    }
}

- (void)unselected
{
	[super unselected];
    
    if (onUnselectSelector && selectorTarget) {
        [selectorTarget performSelector:onUnselectSelector withObject:self];
    }
}

@end
