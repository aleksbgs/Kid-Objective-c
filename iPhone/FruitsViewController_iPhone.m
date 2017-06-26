//
//  FruitsViewControllers_iphone.m
//  KIDPedia
//
//  Created by Aca on 03/05/11.
//  Copyright 2011 Aca Technologies. All rights reserved.
//

#import "FruitsViewController_iPhone.h"
#import "Objects.h"

@implementation FruitsViewController_iPhone



-(void)setCategory:(Category *)category{
	
	if(!appDelegate)
	{
		appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
	}
	if (!arrObjects) {
		arrObjects = [[NSMutableArray alloc] init];
		arrObjects = [[appDelegate getObjectsByCategoryID:category.ID] retain];
		NSLog(@"all objects are:- %@",[arrObjects description]);
		appDelegate.arrCurrentObjects = arrObjects;
	}
}

#pragma mark -
#pragma mark ALL IBAction
-(IBAction)Back:(id)sender{
	//[self removeAllTimesAndAnimation];
//	[self removeAllFruitsAndTimersOnScreen];
	//[self removeAllFruitsAndTimersOnScreen];
	//[self performSelectorInBackground:@selector(removeAllData) withObject:nil];
	[self performSelector:@selector(removeAllData) withObject:nil];
	[self.navigationController popViewControllerAnimated:YES];

	
	
}

-(IBAction)ClickOnTitle:(id)sender{
	NSString *strFruitsTitleSoundName = [NSString stringWithFormat:@"%@.mp3",[self getFruitsTitleSoundName]];
	[self playSound:strFruitsTitleSoundName];
	[self removeAllFruitsFromScreen];
	[self removeAllFruitsAndTimersOnScreen];
	[self setFrameOfBag];
	
	
}
-(void)clickOnBag:(id)sender{
	if ([arrFruietInBag count]>0) {
		NoOfFruitsInBag = 0;
		[self performSelector:@selector(popAllFruitInBag) withObject:nil afterDelay:0];
	}
	
}


#pragma mark -
#pragma mark REMOVE ALL GRAPHICS AND TIMER ON SCREEN
-(void)removeAudioPlayer:(AVAudioPlayer*)avPlayer{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	if (avPlayer) {
		[dicPlayers removeObjectForKey:[avPlayer description]];
		[avPlayer release];
		avPlayer=nil;
	}
	
	//NSObject *object = [dicPlayers objectForKey:[avPlayer description]];
	//	if (object) {
	//		[dicPlayers removeObjectForKey:[avPlayer description]];
	//		[avPlayer release];
	//		avPlayer=nil;
	//	}
	//	else {
	//[dicPlayers removeObjectForKey:[avPlayer description]];
	//if (avPlayer) {
	//			[avPlayer release];
	//			avPlayer=nil;
	//		}
	//	}
	
	[pool release];
}



-(void)removeAllData{
	NSAutoreleasePool *pool	= [[NSAutoreleasePool alloc] init];
	[self removeAllTimesAndAnimation];
	[self removeAllFruitsAndTimersOnScreen];
	[self removeAllFruitsFromScreen];
	[self removeAllAudioPlayers];
	[pool release];
}


-(void)removeButton:(id)sender{
	NSLog(@"delete button");
	
	
	UIButton *btn = (UIButton*)sender;
	//CGFloat size = 20;
	//fruitXposition = bagFrontImage.center.x;
	
	NSLog(@"fruit x position is:- %f and y position is:- %f",fruitXposition,fruitYposition);
	[arrFruietInBag addObject:btn];
	[btn removeFromSuperview];
	
}

-(void)removeFruit{
	
	UIButton *btnF = [arrFruitOnScreen objectAtIndex:0];
	[[btnF layer] removeAllAnimations];
	[arrFruitOnScreen removeObjectAtIndex:0];
	[btnF removeFromSuperview];

	
}

-(void)removeAllTimesAndAnimation{
	[[btnBag layer] removeAllAnimations];
	[[bagView layer] removeAllAnimations];
	[[scrollView layer] removeAllAnimations];
	if (timerView) {
		[timerView invalidate];
		timerView = nil;
	}
}


-(void)removeAllAudioPlayers
{
	[dicCenterPoint removeAllObjects];
	if ([dicFruitTimer count]>0) {
		for (int i=0; i<[dicFruitTimer count]; i++) {
			NSTimer *timer = [dicFruitTimer objectForKey:[[dicFruitTimer allKeys]objectAtIndex:i]];
			if (timer) {
				[timer invalidate];
				timer = nil;
			}
		}
		[dicFruitTimer removeAllObjects];
	}
	if ([dicPlayers count]>0) {
		for (int i=0; i<[dicPlayers count]; i++) {
			AVAudioPlayer *avPlayer= [[dicPlayers objectForKey:[[dicPlayers allKeys]objectAtIndex:i]]retain];
			if (avPlayer) {
				[avPlayer stop];
				[avPlayer release];
				avPlayer = nil;
			}
			
		}
		[dicPlayers removeAllObjects];
	}
	
}
-(void)removeAllFruitsAndTimersOnScreen
{
	[dicCenterPoint removeAllObjects];
	if ([dicFruitTimer count]>0) {
		for (int i=0; i<[dicFruitTimer count]; i++) {
			NSTimer *timer = [dicFruitTimer objectForKey:[[dicFruitTimer allKeys]objectAtIndex:i]];
			if (timer) {
				[timer invalidate];
				timer = nil;
			}
		}
		[dicFruitTimer removeAllObjects];
	}
	//[self removeAllAudioPlayers];
	for (int i=0; i<[arrTimers count]; i++) {
		NSTimer *timer = [arrTimers objectAtIndex:i];
		if ([timer isValid]) {
			[timer invalidate];
		}
	}
	[arrTimers removeAllObjects];
	//[self removeAllFruitsFromScreen];
	
}

-(void)removeAllFruitsFromScreen{
	
		
	for (int i=0; i<[arrFruietInBag count]; i++) {
		UIButton *btnFruite = [arrFruietInBag objectAtIndex:i];
		[[btnFruite layer] removeAllAnimations];
		[btnFruite removeFromSuperview];
	}
	
	
	for (int i=0; i<[arrFruitOnScreen count]; i++) {
		UIButton *btnFruit = [arrFruitOnScreen objectAtIndex:i];
		[[btnFruit layer] removeAllAnimations];
		[btnFruit removeFromSuperview];
	}
	[arrFruietInBag removeAllObjects];
	[arrFruitOnScreen removeAllObjects];
}



#pragma mark -
#pragma mark SET FRAME 

-(void)setBagFrame{
	NSLog(@"number of fruits is:- %i",NoOfFruitsInBag);
	CGFloat xPosition,yPosition;
	if (NoOfFruitsInBag==0) {
		CGFloat wTwentyPercent= btnBag.frame.size.width*20/100; 
		CGFloat hTwentyPercent = btnBag.frame.size.height*20/100; 
		CGFloat xTenPercent= btnBag.frame.size.width*10/100; 
		CGFloat yTenPercent = btnBag.frame.size.height*10/100;
		
		//NSLog(@"width is:- %f and new width is:- %f",btnBag.frame.size.width,wTwentyPercent);
		xPosition = xTenPercent;
		yPosition = yTenPercent;
		btnBag.frame = CGRectMake(btnBag.frame.origin.x-xTenPercent, btnBag.frame.origin.y-yTenPercent, btnBag.frame.size.width+wTwentyPercent, btnBag.frame.size.height+hTwentyPercent);
		//NSLog(@"bag view position is:- %f %f %f %f",btnBag.frame.origin.x,btnBag.frame.origin.y,btnBag.frame.size.width,btnBag.frame.size.height);
	}
	else {
		CGFloat wTenPercent= btnBag.frame.size.width*10/100; 
		CGFloat hTenPercent = btnBag.frame.size.height*10/100;
		CGFloat xFivePercent= btnBag.frame.size.width*5/100; 
		CGFloat yFivePercent = btnBag.frame.size.height*5/100;
		xPosition = xFivePercent;
		yPosition = yFivePercent;
		btnBag.frame = CGRectMake(btnBag.frame.origin.x-xFivePercent, btnBag.frame.origin.y-yFivePercent, btnBag.frame.size.width+wTenPercent, btnBag.frame.size.height+hTenPercent);
		
	}
	NSLog(@"bag view position is:- %f %f %f %f",btnBag.frame.origin.x,btnBag.frame.origin.y,btnBag.frame.size.width,btnBag.frame.size.height);
	
	bagView.frame = btnBag.frame;
	bagBackImage.frame = CGRectMake(0, 0, btnBag.frame.size.width, btnBag.frame.size.height);
	bagFrontImage.frame = CGRectMake(0, 0, btnBag.frame.size.width, btnBag.frame.size.height);
	
	for (int i=0; i<[arrVisibleFruit count]; i++) {
		UIImageView *imageView = [arrVisibleFruit objectAtIndex:i];
		imageView.frame = CGRectMake(imageView.frame.origin.x+xPosition/2, imageView.frame.origin.y+yPosition/2, imageView.frame.size.width, imageView.frame.size.height);
	}
	
}

-(void)setBagOnOriginalPosition{
	NSLog(@"set frame");
	[[bagView layer] removeAllAnimations];
	btnBag.frame = CGRectMake(btnBag.frame.origin.x, btnBag.frame.origin.y, 50, 70);
	bagView.frame = btnBag.frame;
	bagBackImage.frame = CGRectMake(0, 0, btnBag.frame.size.width, btnBag.frame.size.height);
	bagFrontImage.frame = CGRectMake(0, 0, btnBag.frame.size.width, btnBag.frame.size.height);
	
}
-(void)setFrameOfBag{
	NSLog(@"set frame");
	[[bagView layer] removeAllAnimations];
	btnBag.frame = CGRectMake(bagView.frame.origin.x, bagView.frame.origin.y, 50, 70);
	btnBag.center = CGPointMake(bagView.center.x, bagView.center.y);
	bagView.frame = btnBag.frame;
	bagView.center = btnBag.center;
	bagBackImage.frame = CGRectMake(0, 0, bagView.frame.size.width, bagView.frame.size.height);
	bagFrontImage.frame = CGRectMake(0, 0, bagView.frame.size.width, bagView.frame.size.height);
	
}
-(void)setFrameOfFruiet:(UIButton *)btnBigFruiet
{
	CGRect frame =[[[btnBigFruiet layer] presentationLayer] frame];
	btnBigFruiet.frame = frame;

}


-(void)setFrameOfFruietWithTimer:(NSTimer*)timer{
	NSLog(@"setFrameOfFruietWithTimer");
	UIButton *btnFruit = [[timer userInfo] valueForKey:@"fruit"];
	CGRect frame =[[[btnFruit layer]presentationLayer] frame];
	CGFloat xPositon = frame.origin.x+frame.size.width/2;
	CGFloat yPosition = frame.origin.y+frame.size.height/2;
	//NSLog(@"current position of button:- %f %f and width is:- %f %f and original size is:- %f %f",frame.origin.x, frame.origin.y,frame.size.width,frame.size.height,btnShape.frame.size.width,btnShape.frame.size.height);
	//btnShape.frame = CGRectMake(frame.origin.x, frame.origin.y, btnShape.frame.size.width, btnShape.frame.size.height);
	btnFruit.center = CGPointMake(xPositon, yPosition);
	
}

-(void)setFrameOfView{
	CGRect frame = [[scrollView.layer presentationLayer] frame];
	//NSLog(@"x positon off view is:- %f and width is :- %f",scrollView.frame.origin.x,scrollView.frame.size.width);
	
	scrollView.frame = frame;
	currentXPostionOfView = frame.origin.x;
	CGFloat endXpostion = (scrollView.frame.size.width-self.view.frame.size.width-8)*-1;
	
	if (currentXPostionOfView<endXpostion) {
		//moveSide = @"Left";
//		moveViewDuration = VIEW_MOVE_DURATION;
//		[[scrollView layer] removeAllAnimations];
//		[self FruitAnimationOnLoadTime];
//		endPoinOfView =scrollView.frame.size.width/2;
		//scrollView.hidden = TRUE;
		if (timerView) {
			[timerView invalidate];
			timerView = nil;
		}
		[[scrollView layer] removeAllAnimations];
		//scrollSwipeView.hidden = FALSE;
//		[scrollView removeFromSuperview];
//		checkScroll = YES;
//		scrollSwipeView.contentOffset = CGPointMake(scrollSize-320, 0);
		//[self LoadFruitWithSwipView];
		
	}
	CGFloat slowFirstPostion = endXpostion+320;
	CGFloat slowSecondPositon = endXpostion +50;
	if (currentXPostionOfView < slowFirstPostion && currentXPostionOfView > slowSecondPositon) {
		moveViewDuration = VIEW_MOVE_DURATION/2.7;
		if (timerView) {
			[timerView invalidate];
			timerView = nil;
		}
		[[scrollView layer] removeAllAnimations];
		[self FruitAnimationOnLoadTime];
	}
	
	
	//NSLog(@"end point of view is:-%i", endPoinOfView);
	
}
#pragma mark -
#pragma mark ScroolViewDelegate

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView1{
//	currentXPostionOfView = scrollView.contentOffset.x;
//	currentXPostionOfView = currentXPostionOfView*-1;
//	
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView1{
	currentXPostionOfView = scrollView.contentOffset.x;
	currentXPostionOfView = currentXPostionOfView*-1;
	NSLog(@"scrollview content of set is:- %f",scrollView1.contentOffset.x);
	if (scrollView1.contentOffset.x>5100) {
		setScrollFlag = YES;
		scrollView1.bounces = NO;
		[scrollView1 setContentSize:CGSizeMake(1850, 0)];
		//scrollView1.contentOffset = CGPointMake(scrollView1.contentOffset.x+50, 0);
		[scrollView1 setContentOffset:CGPointMake(scrollView.contentOffset.x+50, 0) animated:YES];
		//[scrollView1 setContentOffset:CGPointMake(3600, 0)];
		[scrollView1 setContentSize:CGSizeMake(scrollSize, 0)];
	}
	else if(scrollView1.contentOffset.x<=0&& setScrollFlag){
		scrollView1.bounces = NO;
		[scrollView1 setContentOffset:CGPointMake(3550, 0)];
		[scrollView1 setContentOffset:CGPointMake(scrollView.contentOffset.x-75, 0) animated:YES];
	}
	else {
		scrollView1.bounces = YES;
		//		[scrollView1 setContentSize:CGSizeMake(scrollSize, 0)];
	}
	
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView1{
	if(!scrollAnimation){
		if (timerView) {
			[timerView invalidate];
			timerView = nil;
		}
		[[scrollView layer] removeAllAnimations];
		
		scrollAnimation = TRUE;
		scrollView.frame = CGRectMake(0, 400, 320,FRUIT_BTN_WIDTH);
		scrollView.contentOffset = CGPointMake(currentXPostionOfView*-1, scrollView.contentOffset.y);
	}
}
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView1 willDecelerate:(BOOL)decelerate{
//	CGFloat x = scrollSize-6000;
//	NSLog(@"content of set is:- % f and origin is:- %f and x is:- %f",scrollView1.contentOffset.x,scrollView1.frame.origin.x,x);
//	//NSLog(@"x is:- %f and contentoffset is:- %f",scrollSwipeView.contentOffset.x,x);
//	
//	if (scrollView1.contentOffset.x>5000) {
//		scrollView1.bounces = NO;
//		[scrollView1 setContentSize:CGSizeMake(2000, 0)];
//		
//		//[scrollView1 setContentOffset:CGPointMake(-2000, 0) animated:NO];
//		//[scrollView1 setContentOffset:CGPointMake(3600, 0)];
//	}
//	else {
//		scrollView1.bounces = YES;
//		[scrollView1 setContentSize:CGSizeMake(scrollSize, 0)];
//	}
//}
#pragma mark -
#pragma mark FruitReletedAction 
-(void)LoadFruitWithSwipView{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSArray *arrFruitImages = [NSLocalizedString(@"appFruietImageName",nil) componentsSeparatedByString:@","];
	int x;
	if (swipeCount==0) {
		x=0;
	}
	else {
		x=scrollSize;
	}
	
	int y=0;
	swipeCount++;
	//scrollView.frame = CGRectMake(0, 400, 320,FRUIT_BTN_WIDTH);
	//scrollSwipeView.pagingEnabled = YES;
	
	for (int i=0; i<[arrFruitImages count]; i++) {
		UIButton *btnFruit = [UIButton buttonWithType:UIButtonTypeCustom];
		btnFruit.frame = CGRectMake(x, y, FRUIT_BTN_WIDTH, FRUIT_BTN_HEIGHT);
		[appDelegate setImage:[UIImage thumbnailImage:[arrFruitImages objectAtIndex:i]] ofButton:btnFruit];
		//btnFruit.imageView.contentMode = UIViewContentModeTop;
		[btnFruit addTarget:self action:@selector(clickOnSmallFruit:) forControlEvents:UIControlEventTouchUpInside];
		[btnFruit addTarget:self action:@selector(swipeFruiet:didStartDrag:) forControlEvents:UIControlEventTouchDragInside|UIControlEventTouchDragOutside];
		[btnFruit addTarget:self action:@selector(swipeFruiet:didEndDrag:) forControlEvents:UIControlEventTouchUpOutside|UIControlEventEditingDidEndOnExit|UIControlEventTouchUpInside];
		btnFruit.tag = i;
		x=x+FRUIT_BTN_WIDTH+HORIZ_FRUIT_DISTANCE;
		[scrollView addSubview:btnFruit];
	}
	scrollSize=x;
	scrollView.contentSize = CGSizeMake(x, y);
	
	[pool release];
}


-(void)loadFruitImages{

	swipeCount = 0;
	NSArray *arrFruitImages = [NSLocalizedString(@"appFruietImageName",nil) componentsSeparatedByString:@","];
	scrollView = [[UIScrollView alloc] init];
	scrollView.showsHorizontalScrollIndicator = FALSE;
	//scrollView.pagingEnabled = YES;
	endPoinOfView = (-self.view.frame.size.width)*2;
	moveViewDuration = VIEW_MOVE_DURATION;
	moveSide = [[NSString alloc] init];
	moveSide = @"Right";
	scrollSize=0;
	int y=0;
	
	for (int i=0; i<[arrFruitImages count]; i++) {
		UIButton *btnFruit = [UIButton buttonWithType:UIButtonTypeCustom];
		btnFruit.frame = CGRectMake(scrollSize, y, FRUIT_BTN_WIDTH, FRUIT_BTN_HEIGHT);
		//[btnFruit setImage:[UIImage thumbnailImage:[arrFruitImages objectAtIndex:i]] forState:UIControlStateNormal];
//		[btnFruit setImage:[UIImage thumbnailImage:[arrFruitImages objectAtIndex:i]] forState:UIControlStateDisabled];
//		[btnFruit setImage:[UIImage thumbnailImage:[arrFruitImages objectAtIndex:i]] forState:UIControlStateSelected];
//		[btnFruit setImage:[UIImage thumbnailImage:[arrFruitImages objectAtIndex:i]] forState:UIControlStateHighlighted];
		[appDelegate setImage:[UIImage thumbnailImage:[arrFruitImages objectAtIndex:i]] ofButton:btnFruit];
		//btnFruit.imageView.contentMode = UIViewContentModeTop;
		[btnFruit addTarget:self action:@selector(clickOnSmallFruit:) forControlEvents:UIControlEventTouchUpInside];
		[btnFruit addTarget:self action:@selector(swipeFruiet:didStartDrag:) forControlEvents:UIControlEventTouchDragInside|UIControlEventTouchDragOutside];
		[btnFruit addTarget:self action:@selector(swipeFruiet:didEndDrag:) forControlEvents:UIControlEventTouchUpOutside|UIControlEventEditingDidEndOnExit|UIControlEventTouchUpInside];
		btnFruit.tag = i;
		scrollSize=scrollSize+FRUIT_BTN_WIDTH+HORIZ_FRUIT_DISTANCE;
		[scrollView addSubview:btnFruit];
	}
	
	scrollView.frame = CGRectMake(0, 400, scrollSize, FRUIT_BTN_HEIGHT);
	scrollView.contentSize = CGSizeMake(scrollView.frame.size.width+2, scrollView.frame.size.height);
	scrollView.delegate = self;
	
	[self performSelector:@selector(FruitAnimationOnLoadTime) withObject:nil afterDelay:0];
	[self.view addSubview:scrollView];
	//[self.view addSubview:scrollSwipeView];
	//[self LoadFruitWithSwipView];
	
	
	btnBag = [UIButton buttonWithType:UIButtonTypeCustom];
	btnBag.frame = CGRectMake(265, 360, 50, 70);
	//[appDelegate setImage:[UIImage thumbnailImage:@"bag.png"] ofButton:btnBag];
	[btnBag addTarget:self action:@selector(clickOnBag:) forControlEvents:UIControlEventTouchUpInside];
	[btnBag addTarget:self action:@selector(bag:didStartDrag:) forControlEvents:UIControlEventTouchDragInside|UIControlEventTouchDragOutside];
	[btnBag addTarget:self action:@selector(bag:didEndDrag:) forControlEvents:UIControlEventTouchDragExit|UIControlEventTouchCancel|UIControlEventTouchUpOutside|UIControlEventTouchUpInside];
	
	[btnRoof addTarget:self action:@selector(roof:didStartDrag:) forControlEvents:UIControlEventTouchDragInside|UIControlEventTouchDragOutside];
	[btnRoof addTarget:self action:@selector(roof:didEndDrag:) forControlEvents:UIControlEventTouchUpOutside|UIControlEventEditingDidEndOnExit|UIControlEventTouchUpInside];
	[self.view addSubview:btnBag];
	bagView = [[UIView alloc] initWithFrame:btnBag.frame];
	bagFrontImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bagView.frame.size.width, bagView.frame.size.height)];
	bagBackImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bagView.frame.size.width, bagView.frame.size.height)];
	bagFrontImage.image = [UIImage thumbnailImage:@"bag-front.png"];
	bagBackImage.image = [UIImage thumbnailImage:@"bag-back.png"];
	bagFrontImage.contentMode = UIViewContentModeScaleToFill;
	bagBackImage.contentMode = UIViewContentModeScaleToFill;
	bagView.userInteractionEnabled = FALSE;
	
	[bagView addSubview:bagBackImage];
	[bagView addSubview:bagFrontImage];
	[self.view addSubview:bagView];
	[self.view bringSubviewToFront:btnRoof];
	[self.view bringSubviewToFront:btnImageTitle];
	[self.view bringSubviewToFront:btnBack];
	fruitXposition = 25;
	fruitYposition = -5;
	[self LoadFruitWithSwipView];
	[self LoadFruitWithSwipView];
	[self LoadFruitWithSwipView];
	
	
	
}



-(void)popAllFruitInBag{
	[self playSoundEffect:@"TapSun.mp3" withRepeatCount:0];
	for (int k=0; k<[arrVisibleFruit count]; k++) {
		UIImageView *tmpObj = [arrVisibleFruit objectAtIndex:k];
		[tmpObj removeFromSuperview];
	}
	[arrVisibleFruit removeAllObjects];
	[self performSelector:@selector(setFrameOfBag) withObject:nil afterDelay:FRUIT_ANIMATION_DURATION];
	for (int i=0; i<[arrFruietInBag count]; i++) {
		[self PopOutAllFruit:[arrFruietInBag objectAtIndex:i]];
	}
	[arrFruietInBag removeAllObjects];
}


-(void)showFruitInBag:(id)sender{
	UIButton *btn = (UIButton*)sender;
	if (NoOfFruitsInBag>5) {
		UIImage *image = btn.currentImage;
		if (image==nil) {
			image=btn.currentBackgroundImage;
		}
		CGFloat devide = 0;
		if (NoOfFruitsInBag==6) {
			devide=3;
		}
		else if(NoOfFruitsInBag==7){
			devide = 6;
		}
		else if(NoOfFruitsInBag==8){
			devide = 3.5;
		}
		else if(NoOfFruitsInBag==9){
			devide = 3.2;
		}
		else {
			devide = 2.5;
		}

		CGFloat width= btnBag.frame.size.width*10/100; 
		CGFloat height = btnBag.frame.size.height*10/100;
		width = btnBag.frame.size.width+width;
		CGFloat ratio = width;
		height = btnBag.frame.size.height+height;
		width = width*35/100;
		height = height*35/100;
		
		
		UIImageView *bagFruit = [[UIImageView alloc] initWithFrame:CGRectMake(ratio/devide, -5, width, height)];
		//bagFruit.bounds = bagView.bounds;
		bagFruit.image = image;
		//bagFruit.center = CGPointMake(bagFrontImage.center.x, bagFrontImage.center.y);
		fruitXposition = fruitXposition+7;
		
		[bagView addSubview:bagFruit];
		[arrVisibleFruit addObject:bagFruit];
		[bagView bringSubviewToFront:bagFrontImage];
		[self.view insertSubview:bagFrontImage belowSubview:btnRoof]; 
	}
	
}

-(void)enableButton:(UIButton *)btnFruiet
{
	//btnFruiet.enabled = TRUE;
}




#pragma mark -
#pragma mark PLAY SOUNDS
-(void)doVolumeFade:(AVAudioPlayer *)avPlayer
{  
	// Stop and get the sound ready for playing again
	[avPlayer stop];
	[avPlayer release];
	dragPlayer = nil;
	avPlayer = nil;
}

-(void)playEffectsAudioPlayer:(NSTimer *)timer{
	NSString *soundFileName = [[timer userInfo] objectForKey:@"SoundName"];
	int repeatCount = [[[timer userInfo] objectForKey:@"RepeatCount"]intValue];
	@try {
		NSString *soundPath = [[NSString alloc] initWithFormat:@"%@/%@", resourcePath,soundFileName];
		//NSLog(@"Path to play: %@", resourcePath);
		NSError* err;
		
		AVAudioPlayer *soundEffectsPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:
											 [NSURL fileURLWithPath:soundPath] error:&err];
		
		if( err ){
			//bail!
			NSLog(@"Failed with reason effect player: %@", [err localizedDescription]);
		}
		else{
			//set our delegate and begin playback 
			soundEffectsPlayer.delegate = self;
			soundEffectsPlayer.numberOfLoops = repeatCount;
			//[soundEffectsPlayer prepareToPlay];
			[soundEffectsPlayer play];
			[dicPlayers setObject:soundEffectsPlayer forKey:[soundEffectsPlayer description]];
		}
		[soundPath release];
	}
	@catch (NSException * e) {
	}
	@finally {
	}
}


-(void)playMainAudioPlayer:(NSTimer *)timer{
	NSString *soundFileName = [[timer userInfo] objectForKey:@"SoundName"];
	@try {
		NSString *soundPath = [[NSString alloc] initWithFormat:@"%@/%@", resourcePath,soundFileName];
		//NSLog(@"Path to play: %@", resourcePath);
		NSError* err=nil;
		
		AVAudioPlayer *avPlayer = [dicPlayers objectForKey:soundFileName];
		//avPlayer.delegate = self;
		if (avPlayer==nil) {
			player = [[AVAudioPlayer alloc] initWithContentsOfURL:
					  [NSURL fileURLWithPath:soundPath] error:&err];
			//player.delegate=self;
			
			if( err ){
				//bail!
				NSLog(@"Failed with reason main player: %@", [err localizedDescription]);
			}
			else{
				//set our delegate and begin playback
				player.numberOfLoops = 0;
				[player prepareToPlay];
				[player play];
			}
			[dicPlayers setObject:player forKey:soundFileName];
		}
		else {
			player = avPlayer;
			[avPlayer play];
		}
		[soundPath release];
	}
	@catch (NSException * e) {
	}
	@finally {
	}
}
-(void)playDragPlayer:(AVAudioPlayer *)avPlayer{
	[avPlayer play];
}
-(void)playSoundEffect:(NSString *)soundFileName withRepeatCount:(int)repeatCount
{
	NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.0f target:self selector:@selector(playEffectsAudioPlayer:) 
													userInfo:[NSDictionary dictionaryWithObjectsAndKeys:soundFileName,@"SoundName",[NSString stringWithFormat:@"%d",repeatCount],@"RepeatCount",nil]
													 repeats:NO];
	
	[[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
-(AVAudioPlayer *)playSoundDragEffect:(NSString *)soundFileName withRepeatCount:(int)repeatCount
{
	AVAudioPlayer *soundEffectsPlayer = nil;
	@try {
		NSString *soundPath = [[NSString alloc] initWithFormat:@"%@/%@", resourcePath,soundFileName];
		//NSLog(@"Path to play: %@", resourcePath);
		NSError* err;
		
		
		soundEffectsPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:
							  [NSURL fileURLWithPath:soundPath] error:&err];
		
		
		if( err ){
			//bail!
			NSLog(@"Failed with reason: %@", [err localizedDescription]);
		}
		else{
			//set our delegate and begin playback
			soundEffectsPlayer.numberOfLoops = repeatCount;
			[self performSelectorInBackground:@selector(playDragPlayer:) withObject:soundEffectsPlayer];
		}
		[soundPath release];
	}
	@catch (NSException * e) {
	}
	@finally {
		return soundEffectsPlayer;
	}
	
}
-(void)playSound:(NSString *)soundFileName
{
	NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.0f target:self selector:@selector(playMainAudioPlayer:) 
													userInfo:[NSDictionary dictionaryWithObjectsAndKeys:soundFileName,@"SoundName",nil]
													 repeats:NO];
	
	[[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
#pragma mark -
#pragma mark AUDIO PLAYER DELEGATE EVENTS
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)avPlayer successfully:(BOOL)flag
{
	
	//[self performSelectorInBackground:@selector(removeAudioPlayer:) withObject:avPlayer];
	[self performSelector:@selector(removeAudioPlayer:) withObject:avPlayer];
}

#pragma mark -
#pragma mark ANIMATION DELEGATE EVENT
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
		
	dragFlag = NO;
	NSArray *arrValues = [[anim valueForKey:@"AnimationGroup"] componentsSeparatedByString:@","];
	if (flag) {
		if ([arrValues count]>1) {
			NSString *strPosition = [arrValues objectAtIndex:0];
			int animSequence = [[arrValues objectAtIndex:1] intValue];
			int position = [strPosition intValue];
			UIButton *btnFruiet = [arrFruitOnScreen objectAtIndex:position];
			if ([dicFruitTimer count]>0) {
				NSTimer *timer = [dicFruitTimer valueForKey:[NSString stringWithFormat:@"%i",btnFruiet.tag]];
				if (timer) {
					[timer invalidate];
					timer=nil;
				}
				
			}
			
			btnFruiet.userInteractionEnabled = TRUE;
			NSTimer *timer = nil;
			switch (animSequence) {
				case 0:
					btnFruiet.center = self.view.center;
					//timer = [NSTimer scheduledTimerWithTimeInterval:REMAIN_ANIMATION target:self selector:@selector(putFruietOnScreen:) userInfo:[NSDictionary dictionaryWithObjectsAndKeys:btnFruiet, @"btnFruiet", [NSString stringWithFormat:@"%d",position],@"position",  nil] repeats:NO];
//					[[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
					[self performSelectorOnMainThread:@selector(putFruietOnScreen:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:btnFruiet, @"btnFruiet", [NSString stringWithFormat:@"%d",position],@"position",  nil] waitUntilDone:NO];
					//[arrTimers addObject:timer];
					[self enableButton:btnFruiet];
					break;
				case 1:
					
					[self setFrameOfFruiet:btnFruiet];
					[self enableButton:btnFruiet];
					[[btnFruiet layer] removeAllAnimations];
					break;
				case 2:
					//timer = [NSTimer scheduledTimerWithTimeInterval:REMAIN_ANIMATION target:self selector:@selector(putFruietAtOriginPosition:) userInfo:[NSDictionary dictionaryWithObjectsAndKeys:btnFruiet, @"btnFruiet", [NSString stringWithFormat:@"%d",position],@"position",  nil] repeats:NO];
//					[[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
					//[self performSelector:@selector(putFruietAtOriginPosition:) withObject:btnFruiet afterDelay:REMAIN_ANIMATION];
					[self performSelectorOnMainThread:@selector(putFruietAtOriginPosition:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:btnFruiet, @"btnFruiet", [NSString stringWithFormat:@"%d",position],@"position",  nil] waitUntilDone:NO];
					//[arrTimers addObject:timer];
					break;
				case 3:
					[self setFrameOfFruiet:btnFruiet];
					[self enableButton:btnFruiet];
					[[btnFruiet layer] removeAllAnimations];
					break;
				case 4:
					btnFruiet.center = self.view.center;
					timer = [NSTimer scheduledTimerWithTimeInterval:REMAIN_ANIMATION/2 target:self selector:@selector(putBagFruietOnScreen:) userInfo:[NSDictionary dictionaryWithObjectsAndKeys:btnFruiet, @"btnFruiet", [NSString stringWithFormat:@"%d",position],@"position",  nil] repeats:NO];
					[[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
					[arrTimers addObject:timer];
					break;
	
				default:
				break;
			}
		}
	}
	else {
		if ([arrValues count]>1) {
			NSString *strPosition = [arrValues objectAtIndex:0];
			int animSequence = [[arrValues objectAtIndex:1] intValue];
			int position = [strPosition intValue];
			NSLog(@"Failed Animation with position %d - %d",position, animSequence);
		}
	}
	if ([[anim valueForKey:@"roofAnimation"] isEqualToString:@"roof"]) {
		[[btnRoof layer] removeAllAnimations];
		btnRoof.frame = CGRectMake(0, -415, 320, 500);
		
	}
}

#pragma mark -
#pragma mark DRAG EVENTS
- (void)fruit:(UIButton *)fruit didStartDrag:(UIEvent *)event
{
	dragFlag = YES;
	//[[NSRunLoop mainRunLoop] cancelPerformSelectorsWithTarget:self];
	//[[NSRunLoop currentRunLoop] cancelPerformSelectorsWithTarget:self];
	if(fruit == btnAnimationRunning){
		NSLog(@"Match");
		NSString *position = [NSString stringWithFormat:@"%d",[arrFruitOnScreen indexOfObject:fruit]];
		//NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:fruit,@"",position,@"",nil];
		NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:fruit, @"btnFruiet", position,@"position",  nil];
		[NSRunLoop cancelPreviousPerformRequestsWithTarget:self selector:@selector(putFruietOnScreenInMainThread:) object:dict];
		[NSRunLoop cancelPreviousPerformRequestsWithTarget:self selector:@selector(putFruietAtOriginPositionInMainThread:) object:dict];
	}
	[[fruit layer] removeAllAnimations];
	if ([dicFruitTimer count]>0) {
		NSTimer *timer = [dicFruitTimer valueForKey:[NSString stringWithFormat:@"%i",fruit.tag]];
		if (timer) {
			[timer invalidate];
			timer=nil;
		}
		
	}
	[self.view bringSubviewToFront:fruit];
	[self.view insertSubview:fruit belowSubview:btnRoof]; 
	UITouch *touch = [[event allTouches] anyObject];
	if (touch.phase == UITouchPhaseMoved) {
		if (!isMoving) {
			dragPlayer = [self playSoundDragEffect:@"DragLetter.mp3" withRepeatCount:-1];
		}
		isMoving = TRUE;
		CGPoint touchDownPoint = [touch locationInView:fruit.superview];
		fruit.center = touchDownPoint;
	}
}
- (void)fruit:(UIButton *)fruit didEndDrag:(UIEvent *)event
{
	[[fruit layer] removeAllAnimations];
	if ([dicFruitTimer count]>0) {
		NSTimer *timer = [dicFruitTimer valueForKey:[NSString stringWithFormat:@"%i",fruit.tag]];
		if (timer) {
			[timer invalidate];
			timer=nil;
		}
		
	}
	//[self.view bringSubviewToFront:fruit];
	if (isMoving) {
		isMoving = FALSE;
		[self doVolumeFade:dragPlayer];

		
		UITouch *touch = [[event allTouches] anyObject];
		CGPoint touchDownPoint = [touch locationInView:fruit.superview];
		if (CGRectContainsPoint(btnBag.frame, touchDownPoint)) {
			[self.view bringSubviewToFront:bagView];
			[self.view bringSubviewToFront:btnBag];
			[self.view bringSubviewToFront:fruit];
			[self.view bringSubviewToFront:btnRoof];
			[self.view bringSubviewToFront:btnImageTitle];
			[self.view bringSubviewToFront:btnBack];
			[self BagAnimated:fruit];
		}
		
	}
	else {
		[self FruiteClicked:fruit];
	}
}

- (void)roof:(UIButton *)roof didStartDrag:(UIEvent *)event
{
	
	[self.view bringSubviewToFront:roof];
	[self.view bringSubviewToFront:btnImageTitle];
	[self.view bringSubviewToFront:btnBack];
	UITouch *touch = [[event allTouches] anyObject];
	if (touch.phase == UITouchPhaseMoved) {
		if (!isMoving) {
			//[self playSoundEffect:@"roofEffect.mp3" withRepeatCount:0];
			
			dragPlayer = [self playSoundDragEffect:@"roofEffect.mp3" withRepeatCount:-1];
		}
		isMoving = TRUE;
		CGPoint touchDownPoint = [touch locationInView:roof.superview];
		CGPoint center = btnRoof.center;
		center.y = touchDownPoint.y;
		CGFloat yAxis = center.y-420;
		if (yAxis<=0) {
			btnRoof.frame = CGRectMake(0, yAxis, 320, 500);
		}
	}
}
- (void)roof:(UIButton *)roof didEndDrag:(UIEvent *)event
{
	//[self.view bringSubviewToFront:fruit];
	if (isMoving) {
		isMoving = FALSE;
		[self doVolumeFade:dragPlayer];
//		
//		
//		UITouch *touch = [[event allTouches] anyObject];
//		CGPoint touchDownPoint = [touch locationInView:roof.superview];
				
	}
	
}


- (void)bag:(UIButton *)Bag didStartDrag:(UIEvent *)event
{
	[self.view bringSubviewToFront:bagView];
	[self.view bringSubviewToFront:Bag];
	[self.view bringSubviewToFront:btnRoof];
	[self.view bringSubviewToFront:btnImageTitle];
	[self.view bringSubviewToFront:btnBack];
	UITouch *touch = [[event allTouches] anyObject];
	if (touch.phase == UITouchPhaseMoved) {
		if (!isMoving) {
			dragPlayer = [self playSoundDragEffect:@"DragCloud.mp3" withRepeatCount:-1];
		}
		isMoving = TRUE;
		CGPoint bagPoint = [touch locationInView:Bag.superview];
		Bag.center = bagPoint;
		bagView.center = bagPoint;
		NSLog(@"bag view position is:- %f %f %f %f",btnBag.frame.origin.x,btnBag.frame.origin.y,btnBag.frame.size.width,btnBag.frame.size.height);
	}
}


- (void)bag:(UIButton *)Bag didEndDrag:(UIEvent *)event
{
	if (isMoving) {
		isMoving = FALSE;
		[self doVolumeFade:dragPlayer];
	}
	else {
		
	}
}

-(void)swipeFruiet:(UIButton*)fruiet didStartDrag:(UIEvent*)event{
	NSLog(@"did start darg");
	if (dragCount == 0) {
		UIImage *image = fruiet.currentImage;
		if (image==nil) {
			image=fruiet.currentBackgroundImage;
		}
		Objects *object = [arrObjects objectAtIndex:fruiet.tag];
		NSString *strSoundName = [NSString stringWithFormat:[self getFruitsSoundName],object.SoundFileName];
		NSLog(@"sound name is:- %@", strSoundName);
		[self playSound:[NSString stringWithFormat:@"%@.mp3",strSoundName]];
		UIButton *btnBigFruiet = [UIButton buttonWithType:UIButtonTypeCustom];
		//btnBigFruiet.enabled = FALSE;
		
		btnBigFruiet.frame = CGRectMake(fruiet.center.x, 400, 100, 100);
		[btnBigFruiet addTarget:self action:@selector(fruit:didStartDrag:) forControlEvents:UIControlEventTouchDragInside | UIControlEventTouchDragOutside];
		[btnBigFruiet addTarget:self action:@selector(fruit:didEndDrag:) forControlEvents:UIControlEventTouchDragExit|UIControlEventTouchCancel|UIControlEventTouchUpOutside | UIControlEventTouchUpInside];
		
		btnBigFruiet.tag = fruiet.tag;
		[appDelegate setImage:image ofButton:btnBigFruiet];
		
		[self.view addSubview:btnBigFruiet];
		[arrFruitOnScreen addObject:btnBigFruiet];
		[self.view bringSubviewToFront:btnRoof];
		[self.view bringSubviewToFront:btnImageTitle];
		[self.view bringSubviewToFront:btnBack];
	}
	else {
		UIButton *btn = [arrFruitOnScreen lastObject];
		UITouch *touch = [[event allTouches] anyObject];
		if (touch.phase == UITouchPhaseMoved) {
			if (!isMoving) {
				//dragPlayer = [self playSoundDragEffect:@"DragLetter.mp3" withRepeatCount:-1];
			}
			isMoving = TRUE;
			CGPoint touchDownPoint = [touch locationInView:btn.superview];
			btn.center = touchDownPoint;
			
		}
	}

	dragCount++;
	
}

-(void)swipeFruiet:(UIButton*)fruiet didEndDrag:(UIEvent*)event{
	NSLog(@"didEnd drag");
	dragCount = 0;
	if (isMoving) {
		isMoving = FALSE;
		//[self doVolumeFade:dragPlayer];
		UIButton *btn = [arrFruitOnScreen lastObject];
		UITouch *touch = [[event allTouches] anyObject];
		CGPoint touchDownPoint = [touch locationInView:btn.superview];
		if (CGRectContainsPoint(btnBag.frame, touchDownPoint)) {
			[self.view bringSubviewToFront:bagView];
			[self.view bringSubviewToFront:btnBag];
			[self.view bringSubviewToFront:btn];
			[self.view bringSubviewToFront:btnRoof];
			[self.view bringSubviewToFront:btnImageTitle];
			[self.view bringSubviewToFront:btnBack];
			[self BagAnimated:btn];
		}
	}
	dragCount = 0;
}


#pragma mark -
#pragma mark SetAnimation

-(void)putFruietAtOriginPositionInMainThread:(NSDictionary*)btnDictionary{
	//if (!dragFlag) {
		[self playSoundEffect:@"Fruits_Return_to_Original_State.mp3" withRepeatCount:0];
		//[self.view bringSubviewToFront:btnBag];
		//[self.view bringSubviewToFront:bagView];
		UIButton *btnFruiet = [btnDictionary objectForKey:@"btnFruiet"];
		int  position= [[btnDictionary objectForKey:@"position"]intValue];
		CGFloat xPosition = [[[dicCenterPoint objectForKey:[NSString stringWithFormat:@"%i",btnFruiet.tag]] objectAtIndex:0]floatValue];
		CGFloat yPosition = [[[dicCenterPoint objectForKey:[NSString stringWithFormat:@"%i",btnFruiet.tag]] objectAtIndex:1]floatValue];
		btnFruiet.center = self.view.center;
		//btnFruiet.enabled = FALSE;
		//[self playSoundEffect:@"shapes_collapse.mp3" withRepeatCount:0];
		
		if ([dicFruitTimer count]>0) {
			NSTimer *timer = [dicFruitTimer valueForKey:[NSString stringWithFormat:@"%i",btnFruiet.tag]];
			if (timer) {
				[timer invalidate];
				timer=nil;
				[dicFruitTimer removeObjectForKey:[NSString stringWithFormat:@"%i",btnFruiet.tag]];
			}
		}
		NSTimer *fruitTimer = [NSTimer timerWithTimeInterval:0.00002 target:self selector:@selector(setFrameOfFruietWithTimer:) userInfo:[NSDictionary dictionaryWithObject:btnFruiet forKey:@"fruit"] repeats:YES];
		[[NSRunLoop mainRunLoop]addTimer:fruitTimer forMode:NSRunLoopCommonModes];
		[dicFruitTimer setObject:fruitTimer forKey:[NSString stringWithFormat:@"%i",btnFruiet.tag]];
		
		
		[CATransaction begin];
		[CATransaction setValue:[NSNumber numberWithFloat:FRUIT_ANIMATION_DURATION/2] forKey:kCATransactionAnimationDuration];
		
		CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
		CGMutablePathRef positionPath = CGPathCreateMutable();
		CGPathMoveToPoint(positionPath, NULL, [btnFruiet layer].position.x , [btnFruiet layer].position.y);
		CGPathAddLineToPoint(positionPath, NULL, xPosition,  yPosition);
		positionAnimation.path = positionPath;
		
		//CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
		//	rotateAnimation.delegate = self;
		//	//rotateAnimation.autoreverses = YES;
		//	rotateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
		//	rotateAnimation.fromValue = [NSNumber numberWithFloat:2.0];
		//	rotateAnimation.toValue = [NSNumber numberWithFloat:1.0];
		//	rotateAnimation.fillMode = kCAFillModeForwards;
		//	rotateAnimation.removedOnCompletion = NO;
		
		CABasicAnimation *shrinkAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
		shrinkAnimation.fromValue = [NSNumber numberWithFloat:kScaleFactor];
		shrinkAnimation.toValue = [NSNumber numberWithFloat:1.0f];
		
		CAAnimationGroup *theGroup = [CAAnimationGroup animation];
		theGroup.delegate = self;
		theGroup.removedOnCompletion = NO;
		theGroup.fillMode = kCAFillModeForwards;
		theGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
		theGroup.animations = [NSArray arrayWithObjects:positionAnimation,  shrinkAnimation,nil];
		NSString *strPosition = [NSString stringWithFormat:@"%d,3", position];
		[theGroup setValue:strPosition forKey:@"AnimationGroup"];
		[[btnFruiet layer] addAnimation:theGroup forKey:@"AnimationGroup"];
	//btnAnimationRunning = btnFruiet;
		[CATransaction commit];
		CGPathRelease(positionPath);
		//[arrTimers removeObject:timer];
	//}
		
	
	
}
-(void)putFruietOnScreenInMainThread:(NSDictionary*)btnDictionary{
		
	//if (!dragFlag) {
		[self playSoundEffect:@"Fruits_Return_to_Original_State.mp3" withRepeatCount:0];
		
		UIButton *btnBigFruiet = [btnDictionary objectForKey:@"btnFruiet"];
		int position = [[btnDictionary objectForKey:@"position"]intValue];
		//[self playSoundEffect:@"shapes_collapse.mp3" withRepeatCount:0];
		
		float randomX = arc4random()%(int)self.view.center.x;
		float randomY = arc4random()%(int)self.view.center.y;
		
		float directionRandomX = arc4random()% (int)self.view.center.x;
		float directionRandomY = arc4random()% (int)self.view.center.y;
		
		float valueX = 1*(randomX/kNoOfJumps);
		if (randomX<directionRandomX) {
			valueX = -1*(randomX/kNoOfJumps);
		}
		float valueY = 1*(randomY/kNoOfJumps);
		if (randomY<directionRandomY) {
			valueY = -1*(randomY/kNoOfJumps);
		}
		
		// make it jump a couple of times
		CGMutablePathRef thePath = CGPathCreateMutable();
		CGPathMoveToPoint(thePath, NULL, self.view.center.x, self.view.center.y- (BOX_POSITION_LIMIT/3));
		CGPoint point1,point2;
		for (int i=0; i<kNoOfJumps; i++) {
			point1 = CGPointMake(self.view.center.x+(valueX*i), self.view.center.y+(valueY*i));
			point2 = CGPointMake(self.view.center.x+(valueX*(i+1)), self.view.center.y+(valueY*(i+1)));
			if (point1.y>=(self.view.frame.size.height-BOX_POSITION_LIMIT)) {
				break;
			}
			CGPathAddCurveToPoint(thePath,
								  NULL,
								  point1.x,point1.y-JUMP,
								  point2.x,point1.y-JUMP,
								  point2.x,point1.y);
		}
		
		if ([dicFruitTimer count]>0) {
			NSTimer *timer = [dicFruitTimer valueForKey:[NSString stringWithFormat:@"%i",btnBigFruiet.tag]];
			if (timer) {
				[timer invalidate];
				timer=nil;
				[dicFruitTimer removeObjectForKey:[NSString stringWithFormat:@"%i",btnBigFruiet.tag]];
			}
		}
		
		NSTimer *fruitTimer = [NSTimer timerWithTimeInterval:0.00002 target:self selector:@selector(setFrameOfFruietWithTimer:) userInfo:[NSDictionary dictionaryWithObject:btnBigFruiet forKey:@"fruit"] repeats:YES];
		[[NSRunLoop mainRunLoop]addTimer:fruitTimer forMode:NSRunLoopCommonModes];
		[dicFruitTimer setObject:fruitTimer forKey:[NSString stringWithFormat:@"%i",btnBigFruiet.tag]];
		
		[CATransaction begin];
		[CATransaction setValue:[NSNumber numberWithFloat:FRUIT_ANIMATION_DURATION/2] forKey:kCATransactionAnimationDuration];
		
		CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
		positionAnimation.path = thePath;
		positionAnimation.calculationMode = kCAAnimationPaced;
		
		// scale it down
		CABasicAnimation *shrinkAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
		shrinkAnimation.fromValue = [NSNumber numberWithFloat:kScaleFactor];
		shrinkAnimation.toValue = [NSNumber numberWithFloat:1.0];
		
		CAAnimationGroup *theGroup = [CAAnimationGroup animation];
		theGroup.delegate = self;
		theGroup.removedOnCompletion = NO;
		theGroup.fillMode = kCAFillModeForwards;
		theGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
		theGroup.animations = [NSArray arrayWithObjects:positionAnimation, shrinkAnimation,nil];
		NSString *strPosition = [NSString stringWithFormat:@"%d,1",position];
		[theGroup setValue:strPosition forKey:@"AnimationGroup"];
		[[btnBigFruiet layer] addAnimation:theGroup forKey:@"AnimationGroup"];
	//btnAnimationRunning = btnBigFruiet;
		[CATransaction commit];
		
		CGPathRelease(thePath);
		
		//	[arrTimers removeObject:timer];	
		if ([arrFruitOnScreen count]>10) {
			//timerRemoveFruit = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeFruit) userInfo:nil repeats:NO];
			//		[[NSRunLoop mainRunLoop] addTimer:timerRemoveFruit forMode:NSRunLoopCommonModes];
			//[NSThread detachNewThreadSelector:@selector(removeFruit) toTarget:self withObject:nil];
			//[self performSelectorOnMainThread:@selector(removeFruit) withObject:nil waitUntilDone:YES];
			//[self performSelectorInBackground:@selector(removeFruit) withObject:nil];
			//[self performSelector:@selector(removeFruit) withObject:nil afterDelay:FRUIT_ANIMATION_DURATION*2];
			
			//NSThread* thread= [[NSThread alloc] initWithTarget:self selector:@selector(removeFruit) object:nil];
			//		[thread start];
		}
		
	//}
		
	
	
		
}

-(void)putFruietAtOriginPosition:(NSDictionary *)btnDictionary
{
	if (!dragFlag) {
		//UIButton *btnFruiet = [[timer userInfo]objectForKey:@"btnFruiet"];
		//[self performSelectorOnMainThread:@selector(putFruietAtOriginPositionInMainThread:) withObject:btnFruiet waitUntilDone:NO];
		[self performSelector:@selector(putFruietAtOriginPositionInMainThread:) withObject:btnDictionary afterDelay:REMAIN_ANIMATION];
		
	}
	
}
-(void)putFruietOnScreen:(NSDictionary *)btnDictionary
{
	if (!dragFlag) {
		[self performSelector:@selector(putFruietOnScreenInMainThread:) withObject:btnDictionary afterDelay:REMAIN_ANIMATION];
				
	}
	//[self.view bringSubviewToFront:btnBag];
	//[self.view bringSubviewToFront:bagView];
}

-(void)putBagFruietOnScreen:(NSTimer *)timer
{
	UIButton *btnBigFruiet = [[timer userInfo] objectForKey:@"btnFruiet"];
	int position = [[[timer userInfo] objectForKey:@"position"]intValue];
	//[self playSoundEffect:@"shapes_collapse.mp3" withRepeatCount:0];
	
	float randomX = arc4random()%(int)self.view.center.x;
	float randomY = arc4random()%(int)self.view.center.y;
	
	float directionRandomX = arc4random()% (int)self.view.center.x;
	float directionRandomY = arc4random()% (int)self.view.center.y;
	
	float valueX = 1*(randomX/kNoOfJumps);
	if (randomX<directionRandomX) {
		valueX = -1*(randomX/kNoOfJumps);
	}
	float valueY = 1*(randomY/kNoOfJumps);
	if (randomY<directionRandomY) {
		valueY = -1*(randomY/kNoOfJumps);
	}
	
	// make it jump a couple of times
	CGMutablePathRef thePath = CGPathCreateMutable();
	CGPathMoveToPoint(thePath, NULL, self.view.center.x, self.view.center.y- (BOX_POSITION_LIMIT/3));
	CGPathAddLineToPoint(thePath, NULL, self.view.center.x+(valueX*(1.5+1)), self.view.center.y+(valueY*1));
	//CGPoint point1,point2;
	
	//for (int i=0; i<kNoOfJumps; i++) {
//		point1 = CGPointMake(self.view.center.x+(valueX*i), self.view.center.y+(valueY*i));
//		point2 = CGPointMake(self.view.center.x+(valueX*(i+1)), self.view.center.y+(valueY*(i+1)));
//		if (point1.y>=(self.view.frame.size.height-BOX_POSITION_LIMIT)) {
//			break;
//		}
//		CGPathAddCurveToPoint(thePath,
//							  NULL,
//							  point1.x,point1.y-JUMP,
//							  point2.x,point1.y-JUMP,
//							  point2.x,point1.y);
//	}
	
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:FRUIT_ANIMATION_DURATION/2] forKey:kCATransactionAnimationDuration];
	
	CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	positionAnimation.path = thePath;
	positionAnimation.calculationMode = kCAAnimationPaced;
	
	// scale it down
    CABasicAnimation *shrinkAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	shrinkAnimation.fromValue = [NSNumber numberWithFloat:kScaleFactor/1.3];
	shrinkAnimation.toValue = [NSNumber numberWithFloat:1.0];
	
	CAAnimationGroup *theGroup = [CAAnimationGroup animation];
	theGroup.delegate = self;
	theGroup.removedOnCompletion = NO;
	theGroup.fillMode = kCAFillModeForwards;
	theGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	theGroup.animations = [NSArray arrayWithObjects:positionAnimation, shrinkAnimation,nil];
	NSString *strPosition = [NSString stringWithFormat:@"%d,1",position];
	[theGroup setValue:strPosition forKey:@"AnimationGroup"];
	[[btnBigFruiet layer] addAnimation:theGroup forKey:@"AnimationGroup"];
    
	[CATransaction commit];
	
	CGPathRelease(thePath);
	
	[arrTimers removeObject:timer];	
	//if ([arrFruitOnScreen count]>5) {
	//		timerRemoveFruit = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeFruit) userInfo:nil repeats:NO];
	//		[[NSRunLoop mainRunLoop] addTimer:timerRemoveFruit forMode:NSRunLoopCommonModes];
	//		
	//		//[self performSelectorInBackground:@selector(removeFruit) withObject:nil];
	//		//[self performSelector:@selector(removeFruit) withObject:nil afterDelay:FRUIT_ANIMATION_DURATION*2];
	//	}
}



-(void)PopOutAllFruit:(id)sender{
	NSLog(@"pop Out fruite");
	//[self.view bringSubviewToFront:bagView];
	fruitXposition = 25;
	fruitYposition = -5;

	
	UIButton *btn = (UIButton*)sender;
	
	UIImage *image = btn.currentImage;
	if (image==nil) {
		image=btn.currentBackgroundImage;
	}
	UIButton *btnBigFruiet = [UIButton buttonWithType:UIButtonTypeCustom];
	//btnBigFruiet.enabled = FALSE;
	
	btnBigFruiet.frame = CGRectMake(btn.center.x, 400, 100, 100);
	[btnBigFruiet addTarget:self action:@selector(fruit:didStartDrag:) forControlEvents:UIControlEventTouchDragInside | UIControlEventTouchDragOutside];
	[btnBigFruiet addTarget:self action:@selector(fruit:didEndDrag:) forControlEvents:UIControlEventTouchDragExit|UIControlEventTouchCancel|UIControlEventTouchUpOutside | UIControlEventTouchUpInside];
	
	btnBigFruiet.tag = btn.tag;
	[appDelegate setImage:image ofButton:btnBigFruiet];
	
	[self.view addSubview:btnBigFruiet];
	[arrFruitOnScreen addObject:btnBigFruiet];
	
	
	
	//[self.view bringSubviewToFront:btnSelected];
	//NSLog(@"X position of button is:- %f and actual x postion is:- %f", [btnBigFruiet layer].position.x,(currentXPostionOfView-[btnBigFruiet layer].position.x));
	CGFloat startingPointX = btnBag.center.x;
	CGFloat endPointY = btnBag.center.y-btnBag.frame.size.height/3;
	
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:FRUIT_ANIMATION_DURATION/2] forKey:kCATransactionAnimationDuration];
	
	CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	CGMutablePathRef positionPath = CGPathCreateMutable();
	CGPathMoveToPoint(positionPath, NULL, startingPointX , endPointY );
	CGPathAddLineToPoint(positionPath, NULL,self.view.center.x , self.view.center.y - (BOX_POSITION_LIMIT/3));
	positionAnimation.path = positionPath;
	
	CABasicAnimation *shrinkAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	shrinkAnimation.fromValue = [NSNumber numberWithFloat:0.2f];
	shrinkAnimation.toValue = [NSNumber numberWithFloat:kScaleFactor/1.3];
	
		
		
	CAAnimationGroup *theGroup = [CAAnimationGroup animation];
	theGroup.delegate = self;
	theGroup.removedOnCompletion = NO;
	theGroup.fillMode = kCAFillModeForwards;
	theGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	theGroup.animations = [NSArray arrayWithObjects:positionAnimation, shrinkAnimation,nil];
	int position = [arrFruitOnScreen indexOfObject:btnBigFruiet];
	NSString *strPosition = [NSString stringWithFormat:@"%d,4",position];
	[theGroup setValue:strPosition forKey:@"AnimationGroup"];
	[[btnBigFruiet layer] addAnimation:theGroup forKey:@"AnimationGroup"];
	
	[CATransaction commit];
	
	CGPathRelease(positionPath);
	
	CGFloat shrinkValue =50/bagView.frame.size.width;
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:FRUIT_ANIMATION_DURATION] forKey:kCATransactionAnimationDuration];
	
	CABasicAnimation *shrinkAnimation1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	shrinkAnimation1.fromValue = [NSNumber numberWithFloat:1];
	shrinkAnimation1.toValue = [NSNumber numberWithFloat:shrinkValue];
	shrinkAnimation1.removedOnCompletion = NO;
	shrinkAnimation1.fillMode = kCAFillModeForwards;
	shrinkAnimation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	[[bagView layer] addAnimation:shrinkAnimation1 forKey:@"BagAnimation"];
	[CATransaction commit];
	
	
	
}

-(void)showFruitInMainThread:(id)sender{
	//NSAutoreleasePool *pool	= [[NSAutoreleasePool alloc] init];
	UIButton *btn = (UIButton*)sender;
	UIImage *image = btn.currentImage;
	if (image==nil) {
		image=btn.currentBackgroundImage;
	}
	Objects *object = [arrObjects objectAtIndex:btn.tag];
	NSString *strSoundName = [NSString stringWithFormat:[self getFruitsSoundName],object.SoundFileName];
	NSLog(@"sound name is:- %@", strSoundName);
	[self playSound:[NSString stringWithFormat:@"%@.mp3",strSoundName]];
	
	[self playSoundDragEffect:@"Fruits_Expand.mp3" withRepeatCount:0];
	UIButton *btnBigFruiet = [UIButton buttonWithType:UIButtonTypeCustom];
	//btnBigFruiet.enabled = FALSE;
	//btnBigFruiet.enabled = TRUE;
	
	btnBigFruiet.frame = CGRectMake(btn.center.x, 400, 100, 100);
	[btnBigFruiet addTarget:self action:@selector(fruit:didStartDrag:) forControlEvents:UIControlEventTouchDragInside | UIControlEventTouchDragOutside];
	[btnBigFruiet addTarget:self action:@selector(fruit:didEndDrag:) forControlEvents:UIControlEventTouchDragExit|UIControlEventTouchCancel|UIControlEventTouchUpOutside | UIControlEventTouchUpInside];
	
	btnBigFruiet.tag = btn.tag;
	[appDelegate setImage:image ofButton:btnBigFruiet];
	
	[self.view addSubview:btnBigFruiet];
	[arrFruitOnScreen addObject:btnBigFruiet];
	[self.view bringSubviewToFront:btnRoof];
	[self.view bringSubviewToFront:btnImageTitle];
	[self.view bringSubviewToFront:btnBack];
	
	//if ([arrFruitOnScreen count]>10) {
		
		
		//NSThread *thread = [[NSThread alloc] init];
		//[self performSelector:@selector(removeFruit) withObject:nil];
		//[self performSelector:@selector(removeFruit) withObject:nil afterDelay:FRUIT_ANIMATION_DURATION/2];
		//[thread start];
		//[self performSelector:@selector(removeFruit) onThread:thread withObject:nil waitUntilDone:NO];
	//}
	
	
	CGFloat startingPointX = [btnBigFruiet layer].position.x-(currentXPostionOfView*-1)-FRUIT_BTN_WIDTH/2;
	CGFloat endPointY = [btnBigFruiet layer].position.y;
	if ([dicFruitTimer count]>0) {
		NSTimer *timer = [dicFruitTimer valueForKey:[NSString stringWithFormat:@"%i",btnBigFruiet.tag]];
		if (timer) {
			[timer invalidate];
			timer=nil;
			[dicFruitTimer removeObjectForKey:[NSString stringWithFormat:@"%i",btnBigFruiet.tag]];
		}
	}
	
	NSTimer *fruitTimer = [NSTimer timerWithTimeInterval:0.00002 target:self selector:@selector(setFrameOfFruietWithTimer:) userInfo:[NSDictionary dictionaryWithObject:btnBigFruiet forKey:@"fruit"] repeats:YES];
	[[NSRunLoop mainRunLoop]addTimer:fruitTimer forMode:NSRunLoopCommonModes];
	[dicFruitTimer setObject:fruitTimer forKey:[NSString stringWithFormat:@"%i",btnBigFruiet.tag]];
	
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:FRUIT_ANIMATION_DURATION] forKey:kCATransactionAnimationDuration];
	
	CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	CGMutablePathRef positionPath = CGPathCreateMutable();
	CGPathMoveToPoint(positionPath, NULL, startingPointX , endPointY );
	CGPathAddLineToPoint(positionPath, NULL,self.view.center.x , self.view.center.y - (BOX_POSITION_LIMIT/3));
	positionAnimation.path = positionPath;
	
	CABasicAnimation *shrinkAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	shrinkAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
	shrinkAnimation.toValue = [NSNumber numberWithFloat:kScaleFactor];
	
	CAAnimationGroup *theGroup = [CAAnimationGroup animation];
	theGroup.delegate = self;
	theGroup.removedOnCompletion = NO;
	theGroup.fillMode = kCAFillModeForwards;
	theGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	theGroup.animations = [NSArray arrayWithObjects:positionAnimation, shrinkAnimation,nil];
	int position = [arrFruitOnScreen indexOfObject:btnBigFruiet];
	NSString *strPosition = [NSString stringWithFormat:@"%d,0",position];
	[theGroup setValue:strPosition forKey:@"AnimationGroup"];
	[[btnBigFruiet layer] addAnimation:theGroup forKey:@"AnimationGroup"];
	btnAnimationRunning = btnBigFruiet;
	[CATransaction commit];
	CGPathRelease(positionPath);
	//[pool release];
}

-(void)clickOnSmallFruit:(id)sender {
	NSLog(@"click event");
	if (dragCount==0) {
		//NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		//[self performSelector:@selector(showFruitInNewThread:) withObject:sender];
		
		[self performSelectorOnMainThread:@selector(showFruitInMainThread:) withObject:sender waitUntilDone:NO];
		
		
		//[pool release];
	}
	
		dragCount = 0;
	
}


-(void)BagAnimated:(id)sender{
	
	NoOfFruitsInBag++;
	CGFloat shrinkTo;
	if (NoOfFruitsInBag<10) {
		shrinkTo = 1.1;
	}
	else {
		shrinkTo=1.2;
	}
	

	UIButton *btn = (UIButton*)sender;
	Objects *object = [arrObjects objectAtIndex:btn.tag];
	NSString *strSoundName = [NSString stringWithFormat:[self getFruitsSoundName],object.SoundFileName];
	NSLog(@"sound name is:- %@", strSoundName);
	[self playSound:[NSString stringWithFormat:@"%@.mp3",strSoundName]];
	[self playSoundEffect:@"TapCloud.mp3" withRepeatCount:0];
	
	@try {
		[CATransaction begin];
		[CATransaction setValue:[NSNumber numberWithFloat:FRUIT_ANIMATION_DURATION/2] forKey:kCATransactionAnimationDuration];
		
		CABasicAnimation *shrinkAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
		shrinkAnimation.delegate = self;
		shrinkAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
		shrinkAnimation.fromValue = [NSNumber numberWithFloat:1.0];
		shrinkAnimation.toValue = [NSNumber numberWithFloat:shrinkTo];
		shrinkAnimation.removedOnCompletion = NO;
		[[bagView layer] addAnimation:shrinkAnimation forKey:@"scaleBagAnimation"];
		
		CABasicAnimation *shrinkAnimation1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
		shrinkAnimation1.delegate = self;
		shrinkAnimation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
		shrinkAnimation1.fromValue = [NSNumber numberWithFloat:1.0];
		shrinkAnimation1.toValue = [NSNumber numberWithFloat:0];
		shrinkAnimation1.removedOnCompletion = NO;
		[[btn layer] addAnimation:shrinkAnimation1 forKey:@"scaleFruitAnimation"];
		
		CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
		//positionAnimation.autoreverses = YES;
		CGMutablePathRef positonPath= CGPathCreateMutable();
		CGPathMoveToPoint(positonPath, NULL, [btn layer].position.x, [btn layer].position.y);
		CGPathAddLineToPoint(positonPath, NULL, btnBag.center.x,btnBag.center.y-btnBag.frame.size.height/2 );
		positionAnimation.path = positonPath;
		positionAnimation.fillMode = kCAFillModeForwards;
		positionAnimation.removedOnCompletion  = NO;
		[[btn layer] addAnimation:positionAnimation forKey:@"positionAnimation"];
		
		[CATransaction commit];
		[self performSelector:@selector(setBagFrame) withObject:nil afterDelay:FRUIT_ANIMATION_DURATION/2];
		
		if (NoOfFruitsInBag==10) {
		//	btnBag.frame = CGRectMake(btnBag.frame.origin.x, btnBag.frame.origin.y, 50, 70);
			[self performSelector:@selector(popAllFruitInBag) withObject:nil afterDelay:FRUIT_ANIMATION_DURATION/2];
			//[self popAllFruitInBag];
			NoOfFruitsInBag = 0;
		}
		[self performSelector:@selector(showFruitInBag:) withObject:btn afterDelay:FRUIT_ANIMATION_DURATION/2];
		[self performSelector:@selector(removeButton:) withObject:btn afterDelay:FRUIT_ANIMATION_DURATION/3];
		//[btn removeFromSuperview];
	}
	@catch (NSException * e) {
		
	}
	@finally {
		
	}
	
}




-(void)FruiteClicked:(id)sender{
	UIButton *btn = (UIButton*)sender;
	//btn.enabled = FALSE;
	
	NSLog(@"btn tag is:- %i",btn.tag);
	[self.view bringSubviewToFront:btn];
	[self.view bringSubviewToFront:btnRoof];
	[self.view bringSubviewToFront:btnImageTitle];
	[self.view bringSubviewToFront:btnBack];
	Objects *object = [arrObjects objectAtIndex:btn.tag];
	NSString *strSoundName = [NSString stringWithFormat:[self getFruitsSoundName],object.SoundFileName];
	NSLog(@"sound name is:- %@", strSoundName);
	[self playSound:[NSString stringWithFormat:@"%@.mp3",strSoundName]];
	[self playSoundEffect:@"Fruits_Expand.mp3" withRepeatCount:0];
	if ([dicFruitTimer count]>0) {
		NSTimer *timer = [dicFruitTimer valueForKey:[NSString stringWithFormat:@"%i",btn.tag]];
		if (timer) {
			[timer invalidate];
			timer=nil;
			[dicFruitTimer removeObjectForKey:[NSString stringWithFormat:@"%i",btn.tag]];
		}
	}
	
	NSTimer *fruitTimer = [NSTimer timerWithTimeInterval:0.00002 target:self selector:@selector(setFrameOfFruietWithTimer:) userInfo:[NSDictionary dictionaryWithObject:btn forKey:@"fruit"] repeats:YES];
	[[NSRunLoop mainRunLoop]addTimer:fruitTimer forMode:NSRunLoopCommonModes];
	[dicFruitTimer setObject:fruitTimer forKey:[NSString stringWithFormat:@"%i",btn.tag]];
	NSMutableArray *arrPoint = [[NSMutableArray alloc] init];
	[arrPoint addObject:[NSString stringWithFormat:@"%f",btn.center.x]];
	[arrPoint addObject:[NSString stringWithFormat:@"%f",btn.center.y]];
	[dicCenterPoint setObject:arrPoint forKey:[NSString stringWithFormat:@"%i",btn.tag]];
	[arrPoint release];
	
	@try {
					
			[CATransaction begin];
			[CATransaction setValue:[NSNumber numberWithFloat:FRUIT_ANIMATION_DURATION/2] forKey:kCATransactionAnimationDuration];
			CGFloat x=self.view.center.x;
			CGFloat y =self.view.center.y;
			btnPosition = btn.center;
			CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
			//positionAnimation.autoreverses = YES;
			CGMutablePathRef positonPath= CGPathCreateMutable();
			CGPathMoveToPoint(positonPath, NULL, [btn layer].position.x, [btn layer].position.y);
			CGPathAddLineToPoint(positonPath, NULL, x, y);
			positionAnimation.path = positonPath;
			positionAnimation.fillMode = kCAFillModeForwards;
			//positionAnimation.removedOnCompletion  = NO;
			
			//[[btn layer] addAnimation:positionAnimation forKey:@"positionAnimation"];
			
			//CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
//			rotateAnimation.delegate = self;
//			//rotateAnimation.autoreverses = YES;
//			rotateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//			rotateAnimation.fromValue = [NSNumber numberWithFloat:1.0];
//			rotateAnimation.toValue = [NSNumber numberWithFloat:2.0];
//			rotateAnimation.fillMode = kCAFillModeForwards;
			//rotateAnimation.removedOnCompletion = NO;
			//[[btn layer]addAnimation:shrinkAnimation forKey:@"shrinkAnimation"];
			
			CABasicAnimation *shrinkAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
			shrinkAnimation.delegate = self;
			//shrinkAnimation.autoreverses = YES;
			shrinkAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
			shrinkAnimation.fromValue = [NSNumber numberWithFloat:1.0];
			shrinkAnimation.toValue = [NSNumber numberWithFloat:kScaleFactor];
			shrinkAnimation.fillMode = kCAFillModeForwards;
			//shrinkAnimation.removedOnCompletion = NO;
			//[[btn layer]addAnimation:shrinkAnimation1 forKey:@"shrinkAnimation1"];
		
			CAAnimationGroup *theGroup = [CAAnimationGroup animation];
			theGroup.delegate = self;
			theGroup.removedOnCompletion =NO;
			theGroup.fillMode = kCAFillModeForwards;
			//theGroup.autoreverses = YES;
			theGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
			theGroup.animations = [NSArray arrayWithObjects:positionAnimation,shrinkAnimation,nil];
			NSString *strPosition = [NSString stringWithFormat:@"%d,2", [arrFruitOnScreen indexOfObject:btn]];
			[theGroup setValue:strPosition forKey:@"AnimationGroup"];
			[[btn layer] addAnimation:theGroup forKey:@"AnimationGroup"];
			btnAnimationRunning = btn;
		[CATransaction commit];
		}
		@catch (NSException * e) {
			
		}
		@finally {
			
		}
	
}



-(void)FruitAnimationOnLoadTime{
	
	if (timerView) {
		[timerView invalidate];
		timerView = nil;
	}
	
	timerView = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(setFrameOfView) userInfo:nil repeats:YES];
	[[NSRunLoop mainRunLoop] addTimer:timerView forMode:NSRunLoopCommonModes];
	@try {
		[CATransaction begin];
		[CATransaction setValue:[NSNumber numberWithFloat:moveViewDuration] forKey:kCATransactionAnimationDuration];
		CGFloat x=endPoinOfView;
		NSLog(@"width is:- %f",x);
		CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
		positionAnimation.autoreverses = NO;
		CGMutablePathRef positonPath= CGPathCreateMutable();
		CGPathMoveToPoint(positonPath, NULL, [scrollView layer].position.x, [scrollView layer].position.y);
		CGPathAddLineToPoint(positonPath, NULL, x, [scrollView layer].position.y);
		positionAnimation.path = positonPath;
		
		positionAnimation.fillMode = kCAFillModeForwards;
		positionAnimation.removedOnCompletion  = NO;
		[[scrollView layer] addAnimation:positionAnimation forKey:@"positionAnimation"];
		[CATransaction commit];
		
	}
	@catch (NSException * e) {
		
	}
	@finally {
		
	}
	
}

#pragma mark -
#pragma mark GET NAMES ACCORDING TO LANGUAGE SELECTION

-(NSString *)getFruitsTitleSoundName
{
	NSString *soundName = NSLocalizedString(@"appFruitsTitleSoundName",nil);
	@try {
		int value = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] intValue];
		switch (value) {
			case 0:
				soundName = NSLocalizedString(@"appFruitsTitleSoundName",nil);
				break;
			case 1:
				soundName = @"Fruits";
				break;
			case 2:
				soundName = @"Fruits_spanish";
				break;
			case 3:
				soundName = @"Fruits_french";
				break;
			default:
				break;
		}
	}
	@catch (NSException * e) {
	}
	@finally {
		return soundName;
	}
}
-(NSString *)getFruitsSoundName
{
	NSString *soundName = NSLocalizedString(@"appAnimalSoundName",nil);
	@try {
		int value = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] intValue];
		switch (value) {
			case 0:
				soundName = NSLocalizedString(@"appNumberSoundName",nil);
				break;
			case 1:
				soundName = @"%@";
				break;
			case 2:
				soundName = @"%@_spanish";
				break;
			case 3:
				soundName = @"%@_french";
				break;
			default:
				break;
		}
	}
	@catch (NSException * e) {
	}
	@finally {
		return soundName;
	}
}



-(NSString *)getFruitsTitleGraphicName
{
	NSString *graphicName = NSLocalizedString(@"appFruitsTitleGraphicName",nil);
	@try {
		int value = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] intValue];
		switch (value) {
			case 0:
				graphicName = NSLocalizedString(@"appFruitsTitleGraphicName",nil);
				break;
			case 1:
				graphicName = @"fruitstitle";
				break;
			case 2:
				graphicName = @"fruitstitle_spanish";
				break;
			case 3:
				graphicName = @"fruitstitle_french";
				break;
			default:
				break;
		}
	}
	@catch (NSException * e) {
	}
	@finally {
		return graphicName;
	}
}
-(NSString *)getLanguageName
{
	NSString *languageName = NSLocalizedString(@"appSelectedLanguage",nil);
	@try {
		int value = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] intValue];
		switch (value) {
			case 0:
				languageName = NSLocalizedString(@"appSelectedLanguage",nil);
				break;
			case 1:
				languageName = @"English";
				break;
			case 2:
				languageName = @"Spanish";
				break;
			case 3:
				languageName = @"French";
				break;
			default:
				break;
		}
	}
	@catch (NSException * e) {
	}
	@finally {
		return languageName;
	}
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.




#pragma mark -
#pragma mark VIEW ACTIONS

- (void)viewDidLoad {
    [super viewDidLoad];
	resourcePath = [[[NSBundle mainBundle]resourcePath] retain];
	//timerView = [[NSTimer alloc] init];
//	dragPlayer = [[AVAudioPlayer alloc] init];
	arrFruietInBag = [[NSMutableArray alloc] init];
	arrVisibleFruit = [[NSMutableArray alloc] init];
	arrFruitOnScreen = [[NSMutableArray alloc] init];
	arrTimers = [[NSMutableArray alloc] init];
	dicPlayers = [[NSMutableDictionary alloc] init];
	dicFruitTimer = [[NSMutableDictionary alloc] init];
	dicCenterPoint = [[NSMutableDictionary alloc] init];
	dicMediaPlayer = [[NSMutableDictionary alloc] init];
	appDelegate =(AppDelegate_iPhone *) [[UIApplication sharedApplication]delegate];
	//appDelegate.window.windowdelegate = self;
	
}
- (void)viewWillAppear:(BOOL)animated{
	[appDelegate setImage:[UIImage thumbnailImage:@"fruits-roof-iphone.png"] ofButton:btnRoof];
	NSString *currentLang = [self getLanguageName];
	if (![currentLang isEqualToString:@"English"]) {
		btnImageTitle.frame = CGRectMake(btnImageTitle.frame.origin.x+40, btnImageTitle.frame.origin.y, btnImageTitle.frame.size.width, btnImageTitle.frame.size.height);
	}
	NSString *strFruitsTitleSoundName = [NSString stringWithFormat:@"%@.mp3",[self getFruitsTitleSoundName]];
	[self playSound:strFruitsTitleSoundName];
	[appDelegate playSound:@"FruitsBackground.mp3"];
	NSString *strFruitsTitleName = [NSString stringWithFormat:@"%@.png",[self getFruitsTitleGraphicName]];
	[appDelegate setImage:[UIImage thumbnailImage:strFruitsTitleName] ofButton:btnImageTitle];
	
	[self performSelector:@selector(loadFruitImages) withObject:nil afterDelay:0];
	[self performSelector:@selector(roofAnimated)];
}
-(void)roofAnimated{
	
	
	[self playSoundEffect:@"roofEffect.mp3" withRepeatCount:0];
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:2.0] forKey:kCATransactionAnimationDuration];
	
	CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	//positionAnimation.autoreverses = YES;
	CGMutablePathRef positonPath= CGPathCreateMutable();
	CGPathMoveToPoint(positonPath, NULL, [btnRoof layer].position.x, 260);
	CGPathAddLineToPoint(positonPath, NULL, [btnRoof layer].position.x, -165);
	positionAnimation.path = positonPath;
	positionAnimation.fillMode = kCAFillModeForwards;
	positionAnimation.delegate = self;
	positionAnimation.removedOnCompletion = YES;
	//positionAnimation.timingFunctions = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	[positionAnimation setValue:@"roof" forKey:@"roofAnimation"];
	[[btnRoof layer] addAnimation:positionAnimation forKey:@"roofAnimation"];
	
	[CATransaction commit];
	
}
- (void)viewWillDisappear:(BOOL)animated{
	[self removeAllTimesAndAnimation];
	[self removeAllFruitsAndTimersOnScreen];
	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
	NSLog(@"---------------------------Memory Warnning------------------------");
	[self removeAllFruitsAndTimersOnScreen];
	[UIImage clearThumbnailCache];
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	[dicCenterPoint release];
	[dicFruitTimer release];
	[arrObjects removeAllObjects];
	[arrObjects release];
	[moveSide release];
	[scrollView release];
	[arrFruitOnScreen removeAllObjects];
	[arrFruitOnScreen release];
	[arrFruietInBag removeAllObjects];
	[arrFruietInBag release];
	//[timerView release];
	[arrTimers removeAllObjects];
	[arrTimers release];
	//[player release];
	//[dragPlayer release];
	[dicPlayers release];
	
	
}


@end
