
#import "CCMenuItem.h"

@interface GameMenuItemImage : CCMenuItemImage
{
    SEL onSelectSelector;
    SEL onUnselectSelector;
    id selectorTarget;
    NSString *tooltip;
}

@property (readwrite) SEL onSelectSelector;
@property (readwrite) SEL onUnselectSelector;
@property (assign) id selectorTarget;
@property (retain) NSString *tooltip;

@end
