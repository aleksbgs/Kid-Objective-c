//
//  FruitsViewControllers_iphone.h
//  KIDPedia
//
//  Created by Aca on 03/05/11.
//  Copyright 2011 Aca Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate_iPhone.h"
#import "AnimateObjectView.h"

#define FRUIT_BTN_WIDTH 80
#define FRUIT_BTN_HEIGHT 80
#define FRUIT_ANIMATION_DURATION 1.5f
#define VIEW_MOVE_DURATION 15
#define HORIZ_FRUIT_DISTANCE 10

#define BOX_POSITION_LIMIT 125
#define kScaleFactor 2.4f
#define kNoOfJumps 3
#define JUMP 100.0f
#define REMAIN_ANIMATION 0.7f


@interface FruitsViewController_iPhone : UIViewController<AnimateObjectViewDelegate,MainWindowDelegate,AVAudioPlayerDelegate,UIScrollViewDelegate> {
	AppDelegate_iPhone *appDelegate;
	NSMutableArray *arrObjects,*arrFruitOnScreen,*arrFruietInBag;
	IBOutlet UIButton *btnImageTitle,*btnRoof,*btnBack;
	NSTimer *timerView;
		
	//Load all fruit images
	UIScrollView *scrollView;
	NSString *moveSide;
	NSMutableArray *arrTimers;
	AVAudioPlayer *player, *dragPlayer;
	NSMutableDictionary *dicPlayers;
	NSString *resourcePath;
	UIView *bagView;
	
	
	int touchCount,NoOfFruitsInBag,scrollSize,swipeCount;
	CGFloat currentXPostionOfView;
	CGFloat moveViewDuration;
	signed int endPoinOfView;
	BOOL isMoving;
	UIButton *btnBag;
	CGPoint btnPosition;
	int dragCount;
	
	UIImageView *bagFrontImage;
	UIImageView *bagBackImage;
	CGFloat fruitXposition,fruitYposition;
	NSMutableArray *arrVisibleFruit;
	BOOL checkScroll;
	NSMutableDictionary *dicFruitTimer,*dicCenterPoint,*dicMediaPlayer;
	BOOL dragFlag;
	UIButton *btnAnimationRunning;
	BOOL scrollAnimation;
	BOOL setScrollFlag;
}
-(void)setBagOnOriginalPosition;
-(void)setBagFrame;
-(void)LoadFruitWithSwipView;
-(void)setFrameOfBag;
-(void)doVolumeFade:(AVAudioPlayer *)avPlayer;
-(void)playEffectsAudioPlayer:(NSTimer *)timer;
-(void)playMainAudioPlayer:(NSTimer *)timer;
-(void)playDragPlayer:(AVAudioPlayer *)avPlayer;
-(void)playSoundEffect:(NSString *)soundFileName withRepeatCount:(int)repeatCount;
-(AVAudioPlayer *)playSoundDragEffect:(NSString *)soundFileName withRepeatCount:(int)repeatCount;
-(void)playSound:(NSString *)soundFileName;


-(void)PopOutAllFruit:(id)sender;
-(void)removeAllFruitsFromScreen;
-(void)removeAllAudioPlayers;
-(void)removeAllFruitsAndTimersOnScreen;
-(IBAction)ClickOnTitle:(id)sender;
-(NSString *)getFruitsTitleSoundName;
-(NSString *)getFruitsSoundName;
-(NSString *)getFruitsTitleGraphicName;
-(NSString *)getLanguageName;
-(void)popAllFruitInBag;
-(void)BagAnimated:(id)sender;
-(void)FruiteClicked:(id)sender;
-(void)removeAllTimesAndAnimation;
-(void)FruitAnimationOnLoadTime;
-(void)loadFruitImages;
-(void)setFrameOfView;
-(IBAction)Back:(id)sender;


@end
