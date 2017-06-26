//
//  MainWindow.h
//  PreSchool
//
//  Created by Acai on 09/12/10.
//  Copyright 2010 Aca Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainWindowDelegate <NSObject>
@optional 
/* audioPlayerDidFinishPlaying:successfully: is called when a sound has finished playing. This method is NOT called if the player is stopped due to an interruption. */
-(void)didClickOnView:(UIView *)v ofEvent:(UIEvent *)event;
@end


extern NSString * const MainWindowIdleNotification;
extern NSString * const MainWindowActiveNotification;

@interface MainWindow : UIWindow {
	NSTimer *idleTimer;
	NSTimeInterval idleTimeInterval;
	id<MainWindowDelegate>windowdelegate;
}

@property (assign) NSTimeInterval idleTimeInterval;

@property (nonatomic, retain) NSTimer *idleTimer;
@property (nonatomic, retain) id<MainWindowDelegate>windowdelegate;
@end
