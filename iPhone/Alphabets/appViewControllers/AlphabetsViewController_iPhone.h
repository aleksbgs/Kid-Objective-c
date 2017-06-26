//
//  AlphabetsViewController_iPhone.h
//  PreSchool
//
//  Created by Acai on 08/12/10.
//  Copyright 2010 Aca Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "AnimateObjectView.h"
#import "SwipeView.h"
#import "AppDelegate_iPhone.h"
#import "BeachBall.h"

#define MAX_ALPHABET_COUNT 26

#define GRAPHIC_ANIMATION_DURATION 0.5f
#define CHAR_ANIMATION_DURATION 0.5f
#define CLOUD_ANIMATION_DURATION 5.0f
#define SUN_ANIMATION_DURATION 30.0f
#define kLetterScaleFactor 1.1511f
#define kGraphicScaleFactor 1.12f
#define kCloudScaleFactor 1.1511f

#define VELOCITY_BALL_X 2.0f
#define VELOCITY_BALL_Y 2.0f
#define RADIUS_BALL	5.0f
#define MIN_Y_BALL 80
#define MAX_Y_BALL 150

#define GIF_BIRD_ANIMATION_DURATION 0.4f
#define GIF_SPIDER_ANIMATION_DURATION 0.4f

#define SPIDER_MOVE_ANIMATION_DURATION 4.0f
#define BIRD_MOVE_ANIMATION_DURATION 4.0f
#define PAPER_PLANE_MOVE_ANIMATION_DURATION 4.0f
#define BUNNY_MOVE_ANIMATION_DURATION 4.0f
#define BALL_MOVE_ANIMATION_DURATION 6.5f

#define DIVIDE_FRAME_TIMER 250.0f

#define RANDOM_MAX_DURATION 20
#define MAX_TIME_REST 5
@interface AlphabetsViewController_iPhone : UIViewController<AVAudioPlayerDelegate, AnimateObjectViewDelegate> {
	IBOutlet UIImageView *imgSkyBackground;
	IBOutlet UIImageView *imgGrassBackground;
	IBOutlet SwipeView *swipeView;
	IBOutlet UIButton *btnCharCenter, *btnAlphabetTitle;
	IBOutlet UIButton *btnLeftGraphic, *btnRightGraphic;
	IBOutlet UIButton *btnCloud, *btnSun;
	IBOutlet UIImageView *imgSunRays;
	IBOutlet AnimateObjectView *viewBunny, *viewSpider, *viewBird, *viewPaperPlane;
	IBOutlet BeachBall *viewBall;
	UIButton *btnSelected;
	AppDelegate_iPhone *appDelegate;
	AVAudioPlayer *player, *graphicPlayer, *dragPlayer;
	NSMutableArray *arrObjects;
	int currentPosition;
	float spiderMoveDuration, birdMoveDuration, paperPlaneMoveDuration, bunnyMoveDuration, sunRoateDuration;
	NSTimer *timerSpider, *timerBird, *timerPaperPlane, *timerBunny, *timerBall;
	NSTimer *timerMoveSpider, *timerMoveBird, *timerMovePaperPlane, *timerMoveBunny, *timerMoveBall;
	NSTimer *timerRotateSun, *timerSunBackToNormal;
	int spiderStartXPosition, spiderEndXPosition;
	int paperPlaneStartXPosition, paperPlaneEndXPosition;
	int birdStartXPosition, birdEndXPosition;
	int bunnyStartXPosition, bunnyEndXPosition;
	int ballStartXPosition, ballEndXPosition;
	BOOL isMoving,bSwiped, isPaperPlaneClicked;
	NSMutableDictionary *dicLetters;
	CGRect defaultLeftGrahicFrame, defaultRightGrahicFrame;
	CGPoint velocity;
	BOOL bViewAppeared, isAnimationOnScreen;
	BOOL bOldVersion;
	UIView *darkLayerView;
}
-(void)setCategory:(Category *)category;
-(IBAction)back:(id)sender;
-(IBAction)cloudClicked:(id)sender;
-(IBAction)charClicked:(id)sender;
-(IBAction)graphicClicked:(id)sender;
-(IBAction)alphabetClicked:(id)sender;
-(IBAction)sunClicked:(id)sender;

- (IBAction)graphic:(UIButton *)btnGraphic didStartDrag:(UIEvent *)event;
- (IBAction)graphic:(UIButton *)btnGraphic didEndDrag:(UIEvent *)event;

-(void)playSound:(NSString *)soundFileName;
-(void)rotateSun;
//-(void)transformCloud;

-(void)scaleAnimation:(UIButton *)button;

#pragma mark GET IMAGES AS PER LANGUAGE
-(NSString *)getAlphabetTitleImageName;
-(NSString *)getAlphabetTitleSoundName;
-(NSString *)getGraphicsImageName;
-(NSString *)getCharImageName;
-(NSString *)getCloudSoundName;
-(NSString *)getCharSoundName;
-(NSString *)getGraphicsSoundName;
-(NSString *)getLanguageName;

@end
