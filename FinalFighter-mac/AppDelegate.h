
#import "cocos2d.h"

@interface FinalFighter_macAppDelegate : NSObject <NSApplicationDelegate>
{
	NSWindow *window_;
	CCGLView *glView_;    
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet CCGLView *glView;

- (IBAction)toggleFullScreen:(id)sender;

@end
