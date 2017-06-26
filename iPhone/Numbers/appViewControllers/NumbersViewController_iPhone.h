//
//  NumbersViewController_iPhone.h
//  PreSchool
//
//  Created by Acai on 02/12/10.
//  Copyright 2010 Aca Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import "ConfettiView.h"
#import "AppDelegate_iPhone.h"


#define BUTTON_WIDTH 64
#define BUTTON_HEIGHT 55
#define ROW_SPACE 19
#define COLUMN_SPACE 19

#define GRAPHIC_MAX_WIDTH 100
#define GRAPHIC_MAX_HEIGHT 80

#define GRAPHIC_HORIZONTAL_SPACE 5

#define NUMBER_ANIMATION_DURATION 0.6
#define GRAPHIC_FADE_ANIMATION_DURATION 0.6
#define GRAPHIC_SCALE_ANIMATION_DURATION 0.6
#define NUMBER_SCALE_ANIMATION_DURATION 0.6
#define COUNT_DOWN_ANIMATION_DURATION 1.0

#define kScaleFactor 1.5
#define kCountDownScaleFactor 3.0
#define START_X 45
#define START_Y 109

#define STAR_SIGN_INDEX 9
#define ZERO_INDEX 10
#define POUND_SIGN_INDEX 11

#define COUNT_DOWN_MAX_VALUE 10
#define COUNT_DOWN_MIN_VALUE 0
@interface NumbersViewController_iPhone : UIViewController<AVAudioPlayerDelegate,ConfettiViewDelegate, MainWindowDelegate> {
	//IBOutlet UIView *openGLView;
	IBOutlet UIImageView *imgBackgroundView;
	IBOutlet UIView *countdownView;
	IBOutlet UIButton *btnCountDown;
	IBOutlet ConfettiView *confettiView;
	IBOutlet UIImageView *imgBlockView;
	IBOutlet UIButton *btnNumbersTitle;
	UIButton *btnGraphicSelected;
	UIButton *btnSelected;
	NSMutableArray *arrObjects;
	NSMutableArray *arrViews;
	AppDelegate_iPhone *appDelegate;
	NSMutableArray *arrBallViews;
	NSMutableDictionary *dicPlayers;
	AVAudioPlayer *player,*dragPlayer;
	NSString *resourcePath;
	int noOfBalls;
	BOOL isMoving, bReverseCountDown;
	int countDownValue;
	float fadeInAnimation,fadeOutAnimation;
	float scaleAnimation;
	BOOL bSameNumberClicked;
	BOOL bAnimationStarted;
	BOOL clickFlag;
}
-(void)setCategory:(Category *)category;
-(IBAction)back:(id)sender;
-(IBAction)graphicClicked:(id)sender;
-(IBAction)numbersTitleClicked:(id)sender;

-(void)dynamicallyLoadGraphicsForCountDown;
-(void)dynamicallyLoadGraphicsForCountUp;
-(void)dynamicallyLoadImages;

-(NSString *)getBigNumberGraphicName;
-(NSString *)getCheersVoiceOverName;
-(void)dynamicallyLoadGraphics;
-(void)fadeInBlock;
-(void)fadeOutBlock;
-(void)fadeIn:(UIButton *)btnGraphic;
-(void)fadeOut:(UIButton *)btnGraphic;
-(void)confettiShow;
-(void)scaleFrom:(float)fromValue to:(float)toValue ofButton:(UIButton *)btnNumber;
-(void)scaleGraphic:(UIButton *)btnGraphic;
-(void)resetGraphics;
-(void)resetAllAnimations;
-(IBAction)starClicked:(id)sender;
-(IBAction)poundClicked:(id)sender;

@end
