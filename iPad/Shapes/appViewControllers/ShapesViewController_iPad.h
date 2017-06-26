//
//  ShapesViewController_iPhone.h
//  PreSchool
//
//  Created by Acai on 27/01/11.
//  Copyright 2011 Aca Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate_iPad.h"
#import "Objects.h"
#define START_SHAPE_X 38
#define START_SHAPE_Y 774
#define BOX_POSITION_LIMIT 370

#define SHAPE_HORIZONTAL_SPACE 65
#define SHAPE_VERTICAL_SPACE 58

#define BUTTON_WIDTH 87
#define BUTTON_HEIGHT 78

#define BIG_BUTTON_WIDTH 174
#define BIG_BUTTON_HEIGHT 156

#define kScaleFactor 1.92f
#define kNoOfJumps 3

#define TRANSITION_ANIMATION 1.0f
#define REMAIN_ANIMATION 1.0f
#define GRAPHIC_MOVE_DURATION 1.0

#define JUMP 200.0f

@interface ShapesViewController_iPad : UIViewController<AVAudioPlayerDelegate> {
	IBOutlet UIButton *btnShapesTitle;
	IBOutlet UIImageView *imgBlockView;
	IBOutlet UIButton *btnTrangle,*btnStar;
	NSMutableArray *arrObjects;
	NSMutableArray *arrViews, *arrShapesOnScreen;
	NSMutableArray *arrTimers;
	NSMutableDictionary *dicPlayers;
	NSString *resourcePath;
	AppDelegate_iPad *appDelegate;
	AVAudioPlayer *player, *dragPlayer;
	BOOL isMoving;
	int dragCount;
	NSMutableDictionary *dicShapeTimer;
	NSMutableDictionary *dicCenterPoint;
	BOOL dragFlag;
	UIButton *btnAnimationRunning;
}
-(IBAction)clickOnTrangleGraphic:(id)sender;
-(IBAction)clickOnStarGraphic:(id)sender;
-(IBAction)shapesTitleClicked:(id)sender;
-(IBAction)back:(id)sender;

-(void)dynamicallyLoadImages;

-(void)playSound:(NSString *)soundFileName;
-(void)playSoundEffect:(NSString *)soundFileName withRepeatCount:(int)repeatCount;

-(NSString *)getShapesTitleSoundName;
-(NSString *)getShapeSoundName;
@end
