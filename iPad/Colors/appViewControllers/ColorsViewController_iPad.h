//
//  ColorsViewController_iPad.h
//  PreSchool
//
//  Created by Acai on 08/12/10.
//  Copyright 2010 Aca Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AnimateObjectView.h"
#import "AppDelegate_iPad.h"

#define LOAD_Y 1500
#define START_X 68
#define START_Y 925
#define BUTTON_WIDTH 70
#define BUTTON_HEIGHT 160
#define BIG_BUTTON_WIDTH 201
#define BIG_BUTTON_HEIGHT 158
#define COLUMN_SPACE 0
#define CHALK_ANIMATION_DURATION 2.0f

#define kScaleFactor 1.7f
#define kNoOfJumps 3

#define TRANSITION_ANIMATION 1.0f
#define REMAIN_ANIMATION 1.0f

#define LIMIT_COLORS 100
#define REMOVE_COLORS 25
	
#define DIVIDE_FRAME_TIMER 250.0f
#define RANDOM_MAX_DURATION 20

#define STAR_MOVE_ANIMATION_DURATION 4.0f
#define MAX_TIME_REST 5

#define STAR_START_Y 380
#define STAR_END_Y 400

#define STAR_CONTROL_Y 0
#define JUMP 200.0f

#define MAX_COMMETS 5

#define COMET_IMAGE_WIDTH 82
#define COMET_IMAGE_HEIGHT 63

#define COMMET_ANIMATION 1.0f
@interface ColorsViewController_iPad : UIViewController <AVAudioPlayerDelegate>{
	IBOutlet UIImageView *imgBackgroundView;
	IBOutlet UIButton *btnColorsTitle;
	IBOutlet AnimateObjectView *viewStar;
	IBOutlet UIButton *btnRainbow;
	NSMutableArray *arrObjects, *arrTimers,*arrViews,*arrColorsOnScreen,*arrCommetsOnScreen;
	NSTimer *timerStar;
	NSTimer *timerMoveStar;
	AppDelegate_iPad *appDelegate;
	AVAudioPlayer *player,*dragPlayer;
	NSMutableDictionary *dicPlayers;
	int starStartXPosition, starEndXPosition,starControlXPosition;
	int starStartYPosition, starEndYPosition,starControlYPosition;
	float starMoveDuration;
	BOOL isMoving;
	NSString *resourcePath;
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
-(void)enableButton:(UIButton *)btnColor;

-(void)setFrameOfColor:(UIButton *)btnBigColor;

-(void)moveStar;
@end
