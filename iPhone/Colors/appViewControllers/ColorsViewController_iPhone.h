//
//  ColorsViewController_iPhone.h
//  PreSchool
//
//  Created by Acai on 08/12/10.
//  Copyright 2010 Aca Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AnimateObjectView.h"
#import "AppDelegate_iPhone.h"

#define LOAD_Y 700
#define START_X 7
#define START_Y 440
#define BUTTON_WIDTH 34
#define BUTTON_HEIGHT 80
#define BIG_BUTTON_WIDTH 100.8
#define BIG_BUTTON_HEIGHT 79.1
#define COLUMN_SPACE 0
#define CHALK_ANIMATION_DURATION 2.0f

#define kScaleFactor 1.7f
#define kNoOfJumps 3

#define TRANSITION_ANIMATION 1.0f
#define REMAIN_ANIMATION 1.0f

#define DIVIDE_FRAME_TIMER 250.0f
#define RANDOM_MAX_DURATION 20

#define STAR_MOVE_ANIMATION_DURATION 4.0f
#define MAX_TIME_REST 5

#define STAR_START_Y 170
#define STAR_END_Y 185

#define STAR_CONTROL_Y 0

#define JUMP 100.0f

#define MAX_COMMETS 5

#define COMET_IMAGE_WIDTH 82
#define COMET_IMAGE_HEIGHT 63

#define COMMET_ANIMATION 1.0f
@interface ColorsViewController_iPhone : UIViewController <AVAudioPlayerDelegate>{
	IBOutlet UIImageView *imgBackgroundView;
	IBOutlet UIButton *btnColorsTitle;
	IBOutlet AnimateObjectView *viewStar;
	IBOutlet UIButton *btnRainbow;
	NSMutableArray *arrObjects, *arrTimers,*arrViews,*arrColorsOnScreen, *arrCommetsOnScreen;
	NSTimer *timerStar;
	NSTimer *timerMoveStar;
	AppDelegate_iPhone *appDelegate;
	AVAudioPlayer *player,*dragPlayer;
	NSMutableDictionary *dicPlayers;
	NSString *resourcePath;
	int starStartXPosition, starEndXPosition,starControlXPosition;
	int starStartYPosition, starEndYPosition,starControlYPosition;
	float starMoveDuration;
	BOOL isMoving;
	int dragCount;
	NSMutableDictionary *dicColorTimer;
	NSMutableDictionary *dicCenterPoint;
	BOOL dragFlag;
	UIButton *btnAnimationRunning;
	
}
-(void)setCategory:(Category *)category;
-(void)removeAllColorsOnScreen;

-(IBAction)back:(id)sender;
-(IBAction)rainbow:(id)sender;
-(IBAction)colorClicked:(id)sender;
-(IBAction)colorsTitleClicked:(id)sender;

-(void)setFrameOfColor:(UIButton *)btnBigColor;

-(void)moveStar;
@end
