//
//  MainWindow.m
//  PreSchool
//
//  Created by Acai on 09/12/10.
//  Copyright 2010 Aca Technologies. All rights reserved.
//

#import "MainWindow.h"


NSString * const MainWindowIdleNotification   = @"KSDIdlingWindowIdleNotification";
NSString * const MainWindowActiveNotification = @"KSDIdlingWindowActiveNotification";

@interface MainWindow (PrivateMethods)
- (void)windowIdleNotification;
- (void)windowActiveNotification;


@end


@implementation MainWindow
@synthesize idleTimer, idleTimeInterval, windowdelegate;

- (id) initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.idleTimeInterval = 0;
		windowdelegate = nil;
	}
	return self;
}
#pragma mark activity timer

- (void)sendEvent:(UIEvent *)event {
	[super sendEvent:event];
	
	NSSet *allTouches = [event allTouches];
	
	UITouch *touch = [[event allTouches] anyObject];
	if (windowdelegate) {
		[windowdelegate didClickOnView:touch.view ofEvent:event];
	}
	
    if ([allTouches count] > 0) {
		// To reduce timer resets only reset the timer on a Began or Ended touch.
        UITouchPhase phase = ((UITouch *)[allTouches anyObject]).phase;
		if (phase == UITouchPhaseBegan || phase == UITouchPhaseEnded) {
			if (!idleTimer) {
				[self windowActiveNotification];
			} else {
				[idleTimer invalidate];
			}
			if (idleTimeInterval != 0) {
				self.idleTimer = [NSTimer scheduledTimerWithTimeInterval:idleTimeInterval 
																  target:self 
																selector:@selector(windowIdleNotification) 
																userInfo:nil repeats:NO];
			}
		}
	}
}


- (void)windowIdleNotification {
	NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
	[dnc postNotificationName:MainWindowIdleNotification 
					   object:self
					 userInfo:nil];
	self.idleTimer = nil;
}

- (void)windowActiveNotification {
	NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
	[dnc postNotificationName:MainWindowActiveNotification 
					   object:self
					 userInfo:nil];
}

- (void)dealloc {
	if (self.idleTimer) {
		[self.idleTimer invalidate];
		self.idleTimer = nil;
	}
    [super dealloc];
}


@end
