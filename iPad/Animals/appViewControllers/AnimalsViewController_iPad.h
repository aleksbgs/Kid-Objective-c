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
#define ANIMAL_WIDTH 150
#define ANIMAL_HEIGHT 150
#define kScaleFactor 2.0f
#define TRANSITION_ANIMATION 1.0f
#define REMAIN_ANIMATION 0.5f
#define BOX_POSITION_LIMIT 280
#define JUMP 100.0f
#define kNoOfJumps 3

#define DIVIDE_FRAME_TIMER 1500.0f
#define FISH_MOVE_ANIMATION_DURATION 8.0f
#define RANDOM_MAX_DURATION 20
#define MAX_TIME_REST 5

#define FISH_WIDTH 80
#define FISH_HEIGHT 52

#define MAX_FISHES 15

#define SLIDE_ANIMATION_DURATION 1.0f

#define MAX_DRAGONS 5
#define DRAGON_WIDTH 100
#define DRAGON_HEIGHT 100
#define SHOW_REMOVE_FISH 4

#define DRAGON_ANIMATION_DURATION 7.0f
@interface AnimalsViewController_iPad : UIViewController<AVAudioPlayerDelegate, AnimateObjectViewDelegate> {
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
	BOOL flagChestClose;
	int chestCount,index;
	NSMutableDictionary *dicDragonTimer;
	NSMutableDictionary *dicAnimalTimer;
	NSMutableDictionary *dicCenterPoint;
	BOOL dragFlag;
	UIButton *btnAnimationRunning;
	//CGRect oldFrame;
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
