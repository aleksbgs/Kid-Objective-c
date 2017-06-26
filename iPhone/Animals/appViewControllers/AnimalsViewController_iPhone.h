//
//  AnimalsViewController_iPhone.h
//  KIDPedia
//
//  Created by Acai on 07/03/11.
//  Copyright 2011 Aca Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate_iPhone.h"
#import "AnimateObjectView.h"
#define WATERMILL_ANIMATION_DURATION 0.4f
#define ANIMAL_WIDTH 70
#define ANIMAL_HEIGHT 70
#define kScaleFactor 2.0f
#define TRANSITION_ANIMATION 1.0f
#define REMAIN_ANIMATION 0.5f
#define BOX_POSITION_LIMIT 150
#define JUMP 100.0f
#define kNoOfJumps 3

#define DIVIDE_FRAME_TIMER 1500.0f
#define FISH_MOVE_ANIMATION_DURATION 6.0f
#define RANDOM_MAX_DURATION 20
#define MAX_TIME_REST 5

#define FISH_WIDTH 40
#define FISH_HEIGHT 26

#define MAX_FISHES 15

#define SLIDE_ANIMATION_DURATION 1.0f

#define MAX_DRAGONS 5
#define DRAGON_WIDTH 50
#define DRAGON_HEIGHT 50
#define	SHOW_REMOVE_FISH 2

#define DRAGON_ANIMATION_DURATION 5.0f
@interface AnimalsViewController_iPhone : UIViewController<AVAudioPlayerDelegate, AnimateObjectViewDelegate> {
	IBOutlet UIImageView *imgBackgroundView;
	IBOutlet UIImageView *imgTopBackgroundView;
	IBOutlet UIImageView *imgWatermillBackgroundView;
	IBOutlet UIImageView *imgSlideView;
	IBOutlet UIButton *btnWatermill;
	IBOutlet UIButton *btnChest;
	IBOutlet UIButton *btnAnimalsTitle;
	IBOutlet UIButton *btnBack;
	AppDelegate_iPhone *appDelegate;
	NSMutableArray *arrObjects;
	NSMutableDictionary *dicPlayers;
	AVAudioPlayer *player,*dragPlayer;
	NSMutableArray *arrAnimalsOnScreen;
	NSMutableArray *arrTimers;
	NSString *resourcePath;
	NSTimer *timerRotateWatermill;
	NSMutableDictionary *fishTimers;
	BOOL isMoving, isViewAppeared;
    NSMutableArray *arrDragonFliesOnScreen;
	//CGRect oldFrame;
	BOOL flagChestClose;
	int chestCount,index;
	NSMutableDictionary *dicDragonTimer;
	NSMutableDictionary *dicAnimalTimer;
	NSMutableDictionary *dicCenterPoint;
	BOOL dragFlag;
	UIButton *btnAnimationRunning;
}

-(IBAction)animalsTitleClicked:(id)sender;
-(IBAction)watermillClicked:(id)sender;
-(IBAction)chestClicked:(id)sender;
-(IBAction)back:(id)sender;

-(void)playSoundEffect:(NSString *)soundFileName withRepeatCount:(int)repeatCount;

-(void)setFrameOfFish:(NSTimer *)timerFish;
-(void)dynamicallyLoadImages;
-(void)animalClicked:(id)sender;
@end
