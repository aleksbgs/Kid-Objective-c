//
//  NumbersViewController_iPhone.m
//  PreSchool
//
//  Created by Acai on 02/12/10.
//  Copyright 2010 Aca Technologies. All rights reserved.
//

#import "NumbersViewController_iPhone.h"
@implementation NumbersViewController_iPhone

-(void)removeAllAudioPlayers
{
	NSLog(@"removeAllAudioPlayers");
	for (int i=0; i<[dicPlayers count]; i++) {
		NSLog(@"removeAllAudioPlayers in for loop");
		AVAudioPlayer *avPlayer= [dicPlayers objectForKey:[[dicPlayers allKeys]objectAtIndex:i]];
		[avPlayer stop];
		[avPlayer release];
	}
	[dicPlayers removeAllObjects];
}
#pragma mark -
#pragma mark BEGIN COUNTDOWN
-(void)beginCountDown
{
	@try {
		NSString *strGraphicFileName = [NSString stringWithFormat:[self getBigNumberGraphicName],[NSString stringWithFormat:@"%d",countDownValue]];
		UIImage *image = [UIImage thumbnailImage:[NSString stringWithFormat:@"%@.png",strGraphicFileName]];
		[appDelegate setImage:image ofButton:btnCountDown];
		[CATransaction begin];
		[CATransaction setValue:[NSNumber numberWithFloat:COUNT_DOWN_ANIMATION_DURATION] forKey:kCATransactionAnimationDuration];
		
		CABasicAnimation *shrinkAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
		shrinkAnimation.delegate = self;
		shrinkAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
		shrinkAnimation.fromValue = [NSNumber numberWithFloat:1.0];
		shrinkAnimation.toValue = [NSNumber numberWithFloat:kCountDownScaleFactor];
		shrinkAnimation.fillMode = kCAFillModeForwards;
		shrinkAnimation.removedOnCompletion = YES;
		[[btnCountDown layer] addAnimation:shrinkAnimation forKey:@"countDownScaleAnimation"];
		
		CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
		fadeAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
		fadeAnimation.toValue = [NSNumber numberWithFloat:0.0f];
		fadeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
		fadeAnimation.fillMode = kCAFillModeForwards;
		fadeAnimation.removedOnCompletion = NO;
		[[btnCountDown layer] addAnimation:fadeAnimation forKey:@"fadeAnimation"];
		
		[CATransaction commit];
	}
	@catch (NSException * e) {
	}
	@finally {
	}
	
}
#pragma mark -
#pragma mark SET CATEGORY
-(void)setCategory:(Category *)category{
	if(!appDelegate)
	{
		appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
	}
	if (!arrObjects) {
		arrObjects = [[appDelegate getObjectsByCategoryID:category.ID] retain];
	}
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
			NSLog(@"Failed with reason: %@", [err localizedDescription]);
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
	NSLog(@"playMainAudioPlayer");
	NSString *soundFileName = [[timer userInfo] objectForKey:@"SoundName"];
	@try {
		NSString *soundPath = [[NSString alloc] initWithFormat:@"%@/%@", resourcePath,soundFileName];
		//NSLog(@"Path to play: %@", resourcePath);
		NSError* err=nil;
		
		AVAudioPlayer *avPlayer = [dicPlayers objectForKey:soundFileName];
		if (avPlayer==nil) {
			player = [[AVAudioPlayer alloc] initWithContentsOfURL:
					  [NSURL fileURLWithPath:soundPath] error:&err];
			
			if( err ){
				//bail!
				NSLog(@"Failed with reason: %@", [err localizedDescription]);
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
#pragma mark MAIN WINDOW DELEGATE EVENT
-(void)didClickOnView:(UIView *)v ofEvent:(UIEvent *)event
{
	NSLog(@"didClickOnView");
	
	
	if (bAnimationStarted &&
		(v==self.view || v==countdownView || 
		 v==confettiView || v== btnCountDown)) {
			[self performSelector:@selector(resetAllAnimations) withObject:nil afterDelay:0.2];
		}
}
#pragma mark -
#pragma mark ANIMATION STOPPED EVENT
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{	
	if (!countdownView.hidden) {
		if (bReverseCountDown) {
			if (countDownValue>COUNT_DOWN_MIN_VALUE) {
				countDownValue--;
				[self beginCountDown];
			}
			else {
				countdownView.hidden = TRUE;
				[[btnCountDown layer] removeAllAnimations];
				NSString *voiceOver= [NSString stringWithFormat:@"%@.mp3",[self getCheersVoiceOverName]];
				[self playSoundEffect:voiceOver withRepeatCount:0];
				[self playSoundEffect:@"cheer.mp3" withRepeatCount:0];
				[self confettiShow];
			}
		}
		else {
			if (countDownValue<COUNT_DOWN_MAX_VALUE) {
				countDownValue++;
				[self beginCountDown];
			}
			else {
				countdownView.hidden = TRUE;
				[[btnCountDown layer] removeAllAnimations];
				NSString *voiceOver= [NSString stringWithFormat:@"%@.mp3",[self getCheersVoiceOverName]];
				[self playSoundEffect:voiceOver withRepeatCount:0];
				[self playSoundEffect:@"cheer.mp3" withRepeatCount:0];
				[self confettiShow];
			}
		}
		
	}
}
#pragma mark -
#pragma mark AUDIO PLAYER DELEGATE EVENTS
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)avPlayer successfully:(BOOL)flag
{
	NSObject *object = [dicPlayers objectForKey:[avPlayer description]];
	if (object) {
		[dicPlayers removeObjectForKey:[avPlayer description]];
		[avPlayer release];
	}
}

#pragma mark -
#pragma mark GET NAMES ACCORDING TO LANGUAGE SELECTION
-(float)getLengthOfVoiceOver:(float)duration
{
	float length = duration;
	int value = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] intValue];
	switch (value) {
		case 0:
			length = duration;
			break;
		case 1:
			length = duration;
			break;
		case 2:
			length = duration+0.2f;
			break;
		case 3:
			length = duration;
			break;
		default:
			break;
	}
	return length;
}
-(NSString *)getNumbersTitleSoundName
{
	NSString *soundName = NSLocalizedString(@"appNumbersTitleSoundName",nil);
	@try {
		int value = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] intValue];
		switch (value) {
			case 0:
				soundName = NSLocalizedString(@"appNumbersTitleSoundName",nil);
				break;
			case 1:
				soundName = @"numbers";
				break;
			case 2:
				soundName = @"numbers_spanish";
				break;
			case 3:
				soundName = @"numbers_french";
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
-(NSString *)getCheersVoiceOverName
{
	NSString *soundName = NSLocalizedString(@"appCheerVoiceOver",nil);
	@try {
		int value = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] intValue];
		switch (value) {
			case 0:
				soundName = NSLocalizedString(@"appCheerVoiceOver",nil);
				break;
			case 1:
				soundName = @"yaay";
				break;
			case 2:
				soundName = @"bravo_spanish";
				break;
			case 3:
				soundName = @"bravo_french";
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
-(NSString *)getNumberSoundName
{
	NSString *soundName = NSLocalizedString(@"appNumberSoundName",nil);
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
-(NSString *)getBigNumberGraphicName
{
	NSString *graphicName = NSLocalizedString(@"appNumberBigGraphicName",nil);
	@try {
		int value = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] intValue];
		switch (value) {
			case 0:
				graphicName = NSLocalizedString(@"appNumberBigGraphicName",nil);
				break;
			case 1:
				graphicName = @"big_%@";
				break;
			case 2:
				graphicName = @"big_%@";
				break;
			case 3:
				graphicName = @"big_%@";
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
-(NSString *)getReverseCountDownSoundName
{
	NSString *soundName = NSLocalizedString(@"appReverseCountDownSoundName",nil);
	@try {
		int value = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] intValue];
		switch (value) {
			case 0:
				soundName = NSLocalizedString(@"appReverseCountDownSoundName",nil);
				break;
			case 1:
				soundName = @"countdown10to0";
				break;
			case 2:
				soundName = @"countdown10to0_spanish";
				break;
			case 3:
				soundName = @"countdown10to0_french";
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
-(NSString *)getCountDownSoundName
{
	NSString *soundName = NSLocalizedString(@"appCountDownSoundName",nil);
	@try {
		int value = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] intValue];
		switch (value) {
			case 0:
				soundName = NSLocalizedString(@"appCountDownSoundName",nil);
				break;
			case 1:
				soundName = @"counting0to10";
				break;
			case 2:
				soundName = @"counting0to10_spanish";
				break;
			case 3:
				soundName = @"counting0to10_french";
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
-(NSString *)getNumbersTitleGraphicName
{
	NSString *graphicName = NSLocalizedString(@"appNumbersTitleGraphicName",nil);
	@try {
		int value = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] intValue];
		switch (value) {
			case 0:
				graphicName = NSLocalizedString(@"appNumbersTitleGraphicName",nil);
				break;
			case 1:
				graphicName = @"numberstitle";
				break;
			case 2:
				graphicName = @"numberstitle_spanish";
				break;
			case 3:
				graphicName = @"numberstitle_french";
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
-(void)resetAllAnimations
{
	NSLog(@"resetAllAnimations");
	@try {
		[self removeAllAudioPlayers];
		noOfBalls = -1;
		bSameNumberClicked = FALSE;
		
				
		if (btnSelected.tag!=ZERO_INDEX) {
			CATransform3D scaleTransform = [(CALayer *)[btnSelected.layer presentationLayer] transform];
			[self scaleFrom:scaleTransform.m11 to:1.0f ofButton:btnSelected];
		}
		if (!confettiView.hidden) {
			if ([confettiView isStarted]) {
				[confettiView stop];
				[self didCompleteAnimation];
			}
			//[game removeScene];
		}
		else if(!countdownView.hidden){
			[self didCompleteAnimation];
		}
		countdownView.hidden = YES;
		for (int i=0; i<[arrBallViews count]; i++) {
			UIButton *btnGraphic = [arrBallViews objectAtIndex:i];
			[btnGraphic.layer removeAllAnimations];
		}
		[btnCountDown.layer removeAllAnimations];
		
		if (!btnGraphicSelected) {
			[self resetGraphics];
		}
		btnGraphicSelected = nil;
		bAnimationStarted = FALSE;
	}
	@catch (NSException * e) {
	}
	@finally {
	}
	[NSRunLoop cancelPreviousPerformRequestsWithTarget:self];
	[[NSRunLoop currentRunLoop] cancelPerformSelectorsWithTarget:self];

}
#pragma mark -
#pragma mark IB ACTIONS
-(void)setFlag{
	clickFlag = NO;
}

-(void)clickForCoundown:(id)sender{
	UIButton *btn = (UIButton*)sender;
		
	if (btn.tag==STAR_SIGN_INDEX && !clickFlag) {
		[self starClicked:sender];
	}
	else if(btn.tag==POUND_SIGN_INDEX && !clickFlag) {
		[self poundClicked:sender];
	}
	[self performSelector:@selector(setFlag) withObject:nil afterDelay:0.4];
	clickFlag = YES;
}

-(IBAction)starClicked:(id)sender
{	
	if (bAnimationStarted) {
		[self resetAllAnimations];
	}
	bAnimationStarted = TRUE;
	
	NSString *strSoundName = [NSString stringWithFormat:@"%@.mp3",[self getCountDownSoundName]];
	AVAudioPlayer *tempPlayer = [dicPlayers objectForKey:strSoundName];
	if (tempPlayer!=nil) {
		[tempPlayer stop];
		[tempPlayer release];
		tempPlayer = nil;
		[dicPlayers removeObjectForKey:strSoundName];
	}
	
	NSString *strSoundName1 = [NSString stringWithFormat:@"%@.mp3",[self getReverseCountDownSoundName]];
	AVAudioPlayer *tempPlayer1 = [dicPlayers objectForKey:strSoundName1];
	if (tempPlayer1!=nil) {
		[tempPlayer1 stop];
		[tempPlayer1 release];
		tempPlayer1 = nil;
		[dicPlayers removeObjectForKey:strSoundName1];
	}
	
	
	
	countDownValue = COUNT_DOWN_MIN_VALUE;
	countdownView.hidden = FALSE;
	bReverseCountDown = FALSE;
	
	fadeOutAnimation = GRAPHIC_FADE_ANIMATION_DURATION;
	for (int i=0; i<[arrViews count]; i++) {
		UIButton *btnImage = [arrViews objectAtIndex:i];
		[self fadeOut:btnImage];
	}
	[self fadeOutBlock];
	noOfBalls = COUNT_DOWN_MAX_VALUE;
	fadeInAnimation = 0.5f;
	[self dynamicallyLoadGraphicsForCountUp];
	[[btnCountDown layer] removeAllAnimations];
	[self beginCountDown];
	[self.view bringSubviewToFront:countdownView];
	NSLog(@"befor");
	[self playSound:strSoundName];
}
-(IBAction)poundClicked:(id)sender
{
	if (bAnimationStarted) {
		[self resetAllAnimations];
	}
	bAnimationStarted = TRUE;
	
	NSString *strSoundName = [NSString stringWithFormat:@"%@.mp3",[self getReverseCountDownSoundName]];
	AVAudioPlayer *tempPlayer = [dicPlayers objectForKey:strSoundName];
	if (tempPlayer!=nil) {
		[tempPlayer stop];
		[tempPlayer release];
		tempPlayer = nil;
		[dicPlayers removeObjectForKey:strSoundName];
	}
	
	NSString *strSoundName1 = [NSString stringWithFormat:@"%@.mp3",[self getCountDownSoundName]];
	AVAudioPlayer *tempPlayer1 = [dicPlayers objectForKey:strSoundName1];
	if (tempPlayer1!=nil) {
		[tempPlayer1 stop];
		[tempPlayer1 release];
		tempPlayer1 = nil;
		[dicPlayers removeObjectForKey:strSoundName1];
	}
	
	
	countDownValue = COUNT_DOWN_MAX_VALUE;
	countdownView.hidden = FALSE;
	bReverseCountDown = TRUE;
	
	fadeOutAnimation = GRAPHIC_FADE_ANIMATION_DURATION;
	for (int i=0; i<[arrViews count]; i++) {
		UIButton *btnImage = [arrViews objectAtIndex:i];
		[self fadeOut:btnImage];
	}
	[self fadeOutBlock];
	noOfBalls = COUNT_DOWN_MAX_VALUE;
	fadeOutAnimation = 0.5f;
	[self dynamicallyLoadGraphicsForCountDown];
	[[btnCountDown layer] removeAllAnimations];
	[self beginCountDown];
	[self.view bringSubviewToFront:countdownView];
	NSLog(@"before");
	[self playSound:strSoundName];
}
-(IBAction)numbersTitleClicked:(id)sender
{
	if (bAnimationStarted) {
		[self resetAllAnimations];
	}
	if ([arrBallViews count]>0) {
		[self resetGraphics];
	}
	NSString *strSoundName = [NSString stringWithFormat:@"%@.mp3",[self getNumbersTitleSoundName]];
	[self playSound:strSoundName];
}
-(IBAction)numberClicked:(id)sender
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
	if (bAnimationStarted) {
		[self resetAllAnimations];
	}
	bAnimationStarted = TRUE;
	
	btnSelected = sender;
	@try{
		[self playSoundEffect:@"tapnumbers.mp3" withRepeatCount:0];
		if (btnSelected.tag==ZERO_INDEX) {
			noOfBalls=0;
		}
		else {
			if (noOfBalls==btnSelected.tag+1) {
				bSameNumberClicked = TRUE;
			}
			noOfBalls=btnSelected.tag+1;
		}
		[self scaleFrom:1.0 to:kScaleFactor ofButton:btnSelected];
		
	}
	@catch (NSException *exp) {
		
	}
	@finally {
		Objects *object = [arrObjects objectAtIndex:btnSelected.tag];
		NSString *strNumberSoundFileName = [NSString stringWithFormat:[self getNumberSoundName],object.ImageName];
		[self playSound:[NSString stringWithFormat:@"%@.mp3",strNumberSoundFileName]];
		fadeInAnimation = GRAPHIC_FADE_ANIMATION_DURATION;
		fadeInAnimation = [self getLengthOfVoiceOver:fadeInAnimation];
		[self dynamicallyLoadGraphics];
	}
	[pool release];
}
-(IBAction)back:(id)sender
{
	[UIImage clearThumbnailCache];
	[self resetAllAnimations];
	if (dragPlayer && [dragPlayer isPlaying]) {
		[dragPlayer stop];
		[dragPlayer release];
		dragPlayer = nil;
	}
	[self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)graphicClicked:(id)sender
{                                                                                                                                                                                                                                 
	//if (bAnimationStarted) {
		[self resetAllAnimations];
	//}
	bAnimationStarted = TRUE;
	btnGraphicSelected = sender;
	//[self scaleGraphic:btnGraphicSelected];
	scaleAnimation = GRAPHIC_SCALE_ANIMATION_DURATION;
	scaleAnimation = [self getLengthOfVoiceOver:scaleAnimation];
	float delay = 0;
	if ([arrBallViews count]>1) {
		for (int i=0; i<[arrBallViews count]; i++) {
			UIButton *btnGraphic = [arrBallViews objectAtIndex:i];
			[self performSelector:@selector(scaleGraphic:) withObject:btnGraphic afterDelay:delay];
			delay+=scaleAnimation;
		}
	}
	
}

#pragma mark -
#pragma mark DRAG EVENTS
- (void)ball:(UIButton *)ball didStartDrag:(UIEvent *)event
{
	UITouch *touch = [[event allTouches] anyObject];
	if (touch.phase == UITouchPhaseMoved) {
		if (!isMoving) {
			dragPlayer = [self playSoundDragEffect:@"DragLetter.mp3" withRepeatCount:-1];
		}
		if (noOfBalls>=6) {
			int width = self.view.frame.size.width/5;
			if (width>GRAPHIC_MAX_WIDTH) {
				width = GRAPHIC_MAX_WIDTH;
			}
			width = width - GRAPHIC_HORIZONTAL_SPACE;
			int height = GRAPHIC_MAX_HEIGHT;
			if (width<GRAPHIC_MAX_HEIGHT) {
				height = width;
			}
			
			CGRect frame = ball.frame;
			frame.size.width=width;
			frame.size.height=height;
			ball.frame = frame;
		}
		
		isMoving = TRUE;
		CGPoint touchDownPoint = [touch locationInView:[ball.superview superview]];
		ball.center = touchDownPoint;
	}
}
- (void)ball:(UIButton *)ball didEndDrag:(UIEvent *)event
{
	if (isMoving) {
		isMoving = FALSE;
		[self doVolumeFade:dragPlayer];
	}
	else {
		[self graphicClicked:ball];
	}
}
#pragma mark -
#pragma mark SCALE
-(void)scaleGraphic:(UIButton *)btnGraphic
{
	if (btnGraphicSelected == btnGraphic) {
		//[self removeOverlay];
	}
	Objects *object = [arrObjects objectAtIndex:btnGraphic.tag];
	NSString *strNumberSoundFileName = [NSString stringWithFormat:[self getNumberSoundName],object.ImageName];
	[self playSound:[NSString stringWithFormat:@"%@.mp3",strNumberSoundFileName]];
	
	CABasicAnimation *shrinkAnimation;
	if (btnGraphic.tag==[arrBallViews count]-1) {
		UIButton *btnNumber = [arrViews objectAtIndex:btnGraphic.tag];
		
		[CATransaction begin];
		[CATransaction setValue:[NSNumber numberWithFloat:GRAPHIC_SCALE_ANIMATION_DURATION] forKey:kCATransactionAnimationDuration];
		
		shrinkAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
		shrinkAnimation.autoreverses = TRUE;
		shrinkAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
		shrinkAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
		shrinkAnimation.toValue = [NSNumber numberWithFloat:kScaleFactor];
		shrinkAnimation.fillMode = kCAFillModeForwards;
		shrinkAnimation.removedOnCompletion = YES;
		[[btnNumber layer] addAnimation:shrinkAnimation forKey:@"shrinkAnimation"];
	}
	
	shrinkAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	shrinkAnimation.autoreverses = TRUE;
	shrinkAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	shrinkAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
	shrinkAnimation.toValue = [NSNumber numberWithFloat:kScaleFactor];
	shrinkAnimation.fillMode = kCAFillModeForwards;
	shrinkAnimation.removedOnCompletion = YES;
	[[btnGraphic layer] addAnimation:shrinkAnimation forKey:@"shrinkAnimation"];
	
	[CATransaction commit];
}
-(void)scaleToNormal
{
	[self scaleFrom:kScaleFactor to:1.0f ofButton:btnSelected];
	bAnimationStarted = FALSE;
}
#pragma mark -
#pragma mark SCALE ANIMATION
-(void)scaleFrom:(float)fromValue to:(float)toValue ofButton:(UIButton *)btnNumber
{
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:NUMBER_SCALE_ANIMATION_DURATION] forKey:kCATransactionAnimationDuration];
	
	CABasicAnimation *shrinkAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	//shrinkAnimation.delegate = self;
	if (noOfBalls==0) {
		shrinkAnimation.autoreverses = TRUE;
	}
	shrinkAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	shrinkAnimation.fromValue = [NSNumber numberWithFloat:fromValue];
	shrinkAnimation.toValue = [NSNumber numberWithFloat:toValue];
	shrinkAnimation.fillMode = kCAFillModeForwards;
	shrinkAnimation.removedOnCompletion = NO;
	[[btnNumber layer] addAnimation:shrinkAnimation forKey:@"shrinkAnimation"];
	[CATransaction commit];
}
-(void)resetGraphics
{
	for (int i=0; i<[arrBallViews count]; i++) {
		UIButton *btnBall = [arrBallViews objectAtIndex:i];
		[btnBall removeFromSuperview];
	}
	[arrBallViews removeAllObjects];
}
#pragma mark -
#pragma mark LOAD IMAGES
-(void)dynamicallyLoadGraphicsForCountDown
{
	[self resetGraphics];
	
	int width = self.view.frame.size.width/noOfBalls;
	if (width>GRAPHIC_MAX_WIDTH) {
		width = GRAPHIC_MAX_WIDTH;
	}
	width = width - GRAPHIC_HORIZONTAL_SPACE;
	int height = GRAPHIC_MAX_HEIGHT;
	if (width<GRAPHIC_MAX_HEIGHT) {
		height = width;
	}
	float countDownDuration = COUNT_DOWN_ANIMATION_DURATION;
	BOOL bOldVersion = FALSE;
	NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
	if([systemVersion isEqualToString:@"3.1.2"] ||
	   [systemVersion isEqualToString:@"3.1.3"] )
	{
		bOldVersion = TRUE;
	}
	int startPointX = (self.view.frame.size.width - (noOfBalls*(width+GRAPHIC_HORIZONTAL_SPACE)))/2;
	int startPointY = self.view.frame.size.height - height-5;
	NSArray *arrImages = [NSLocalizedString(@"appGrpahicLibrary",nil) componentsSeparatedByString:@","];
	int index = arc4random() % [arrImages count];
	for (int i=0; i<noOfBalls; i++) {
		UIButton *btnBall = [UIButton buttonWithType:UIButtonTypeCustom];
		btnBall.frame = CGRectMake(startPointX, startPointY, width, height);
		btnBall.tag = i;
		[appDelegate setImage:[UIImage thumbnailImage:[arrImages objectAtIndex:index]] ofButton:btnBall];
		btnBall.imageView.contentMode = UIViewContentModeScaleAspectFit;
		[self.view addSubview:btnBall];
		[arrBallViews addObject:btnBall];
		startPointX = startPointX + width + GRAPHIC_HORIZONTAL_SPACE;
		
		if (bOldVersion) {
			[self performSelector:@selector(fadeOut:) withObject:btnBall afterDelay:(noOfBalls-i+1)*countDownDuration];
		}
		else {
			[self performSelector:@selector(fadeOut:) withObject:btnBall afterDelay:(noOfBalls-i-1)*countDownDuration];
		}
	}
}
-(void)dynamicallyLoadGraphicsForCountUp
{
	[self resetGraphics];
	
	int width = self.view.frame.size.width/noOfBalls;
	if (width>GRAPHIC_MAX_WIDTH) {
		width = GRAPHIC_MAX_WIDTH;
	}
	width = width - GRAPHIC_HORIZONTAL_SPACE;
	int height = GRAPHIC_MAX_HEIGHT;
	if (width<GRAPHIC_MAX_HEIGHT) {
		height = width;
	}
	float countDownDuration = COUNT_DOWN_ANIMATION_DURATION;
	BOOL bOldVersion = FALSE;
	NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
	if([systemVersion isEqualToString:@"3.1.2"] ||
	   [systemVersion isEqualToString:@"3.1.3"] )
	{
		bOldVersion = TRUE;
		//countDownDuration+=0.05f;
	}
	
	int startPointX = (self.view.frame.size.width - (noOfBalls*(width+GRAPHIC_HORIZONTAL_SPACE)))/2;
	int startPointY = self.view.frame.size.height - height - 5;
	NSArray *arrImages = [NSLocalizedString(@"appGrpahicLibrary",nil) componentsSeparatedByString:@","];
	int index = arc4random() % [arrImages count];
	int countOfBalls = noOfBalls;
	noOfBalls = 1;
	for (int i=0; i<countOfBalls; i++) {
		UIButton *btnBall = [UIButton buttonWithType:UIButtonTypeCustom];
		btnBall.frame = CGRectMake(startPointX, startPointY, width, height);
		btnBall.tag = i;
		[appDelegate setImage:[UIImage thumbnailImage:[arrImages objectAtIndex:index]] ofButton:btnBall];
		btnBall.imageView.contentMode = UIViewContentModeScaleAspectFit;
		btnBall.hidden = TRUE;
		[self.view addSubview:btnBall];
		[arrBallViews addObject:btnBall];
		startPointX = startPointX + width + GRAPHIC_HORIZONTAL_SPACE;
		if (bOldVersion) {
			[self performSelector:@selector(fadeIn:) withObject:btnBall afterDelay:((i+1.1)*countDownDuration)+1];
		}
		else {
			[self performSelector:@selector(fadeIn:) withObject:btnBall afterDelay:(i*countDownDuration)+1];
		}
	}
}
-(void)dynamicallyLoadGraphics
{
	if (!bSameNumberClicked) {
		[self resetGraphics];
	}
	
	int width = self.view.frame.size.width/noOfBalls;
	if (width>GRAPHIC_MAX_WIDTH) {
		width = GRAPHIC_MAX_WIDTH;
	}
	width = width - GRAPHIC_HORIZONTAL_SPACE;
	int height = GRAPHIC_MAX_HEIGHT;
	if (width<GRAPHIC_MAX_HEIGHT) {
		height = width;
	}
	int startPointX = (self.view.frame.size.width - (noOfBalls*(width+GRAPHIC_HORIZONTAL_SPACE)))/2;
	int startPointY = self.view.frame.size.height - height - 5;
	NSArray *arrImages = [NSLocalizedString(@"appGrpahicLibrary",nil) componentsSeparatedByString:@","];
	int index = arc4random() % [arrImages count];
	float delay=fadeInAnimation;

	NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
	if([systemVersion isEqualToString:@"3.1.2"] ||
	   [systemVersion isEqualToString:@"3.1.3"] )
	{
		delay+=0.6f;
	}
	
	for (int i=0; i<noOfBalls; i++) {
		UIButton *btnBall;
		if (bSameNumberClicked) {
			btnBall = [arrBallViews objectAtIndex:i];
		}
		else {
			btnBall = [UIButton buttonWithType:UIButtonTypeCustom];
			btnBall.frame = CGRectMake(startPointX, startPointY, width, height);
			btnBall.tag = i;
			[appDelegate setImage:[UIImage thumbnailImage:[arrImages objectAtIndex:index]] ofButton:btnBall];
			[btnBall addTarget:self action:@selector(ball:didStartDrag:) forControlEvents:UIControlEventTouchDragInside | UIControlEventTouchDragOutside];
			[btnBall addTarget:self action:@selector(ball:didEndDrag:) forControlEvents:UIControlEventTouchDragExit|UIControlEventTouchCancel|UIControlEventTouchUpOutside | UIControlEventTouchUpInside];
			btnBall.imageView.contentMode = UIViewContentModeScaleAspectFit;
			[self.view addSubview:btnBall];
			[arrBallViews addObject:btnBall];
			startPointX = startPointX + width + GRAPHIC_HORIZONTAL_SPACE;
		}
		
		btnBall.hidden = TRUE;
		[self performSelector:@selector(fadeIn:) withObject:btnBall afterDelay:delay];
		delay+=fadeInAnimation;
		
	}
	if (noOfBalls>0) {
		[self performSelector:@selector(scaleToNormal) withObject:nil afterDelay:delay];
	}	
	bSameNumberClicked = FALSE;
}
-(void)dynamicallyLoadImages
{
	for (int i=0; i<[arrViews count]; i++) {
		UIButton *btnImage = [arrViews objectAtIndex:i];
		[btnImage removeFromSuperview];
	}
	[arrViews removeAllObjects];
	
	int startX = START_X, startY=START_Y;
	for (int i=0; i<[arrObjects count]; i++) {
		Objects *object = [arrObjects objectAtIndex:i];
		CGRect frame =  CGRectMake(startX, startY, BUTTON_WIDTH, BUTTON_HEIGHT);
		UIButton *btnImage = [UIButton buttonWithType:UIButtonTypeCustom];
		NSString *strGraphicFileName = [NSString stringWithFormat:[self getBigNumberGraphicName],object.ImageName];
		UIImage *image = [UIImage thumbnailImage:[NSString stringWithFormat:@"%@.png",strGraphicFileName]];
		[appDelegate setImage:image ofButton:btnImage];
		if (i==STAR_SIGN_INDEX||i==POUND_SIGN_INDEX) {
			[btnImage addTarget:self action:@selector(clickForCoundown:) forControlEvents:UIControlEventTouchUpInside];
		}		
		else {
			[btnImage addTarget:self action:@selector(numberClicked:) forControlEvents:UIControlEventTouchUpInside];
		}
		btnImage.imageView.contentMode = UIViewContentModeScaleAspectFit;
		btnImage.frame =frame;
		btnImage.tag = i;
		[self.view addSubview:btnImage];
		startX = (startX + BUTTON_WIDTH + COLUMN_SPACE);
		if((startX+BUTTON_WIDTH)> self.view.frame.size.width)
		{
			startX = START_X;
			startY = startY + BUTTON_HEIGHT + ROW_SPACE;
		}
		[arrViews addObject:btnImage];
	}	
}

#pragma mark -
#pragma mark CONFETTI DELEGATE EVENT
-(void)didCompleteAnimation
{
	for (int i=0; i<[arrViews count]; i++) {
		UIButton *btnImage = [arrViews objectAtIndex:i];
		fadeInAnimation = GRAPHIC_FADE_ANIMATION_DURATION;
		fadeInAnimation = [self getLengthOfVoiceOver:fadeInAnimation];
		[self fadeIn:btnImage];
	}
	[self fadeInBlock];
	confettiView.hidden =  YES;
	bAnimationStarted = FALSE;
}
#pragma mark -
#pragma mark CONFETTI LIKE ANIMATION

-(void)confettiShow
{
	[self resetGraphics];
	confettiView.hidden = FALSE;
	[confettiView start];
}
#pragma mark -
#pragma mark FADE ANIMATION
-(void)fadeInBlock
{
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:fadeInAnimation] forKey:kCATransactionAnimationDuration];
	
	CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	fadeAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
	fadeAnimation.toValue = [NSNumber numberWithFloat:1.0f];
	fadeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	fadeAnimation.fillMode = kCAFillModeForwards;
	fadeAnimation.removedOnCompletion = NO;
	[[imgBlockView layer] addAnimation:fadeAnimation forKey:@"fadeAnimation"];
	
	fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	fadeAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
	fadeAnimation.toValue = [NSNumber numberWithFloat:1.0f];
	fadeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	fadeAnimation.fillMode = kCAFillModeForwards;
	fadeAnimation.removedOnCompletion = NO;
	[[btnNumbersTitle layer] addAnimation:fadeAnimation forKey:@"fadeAnimation"];
	
	[CATransaction commit];
}
-(void)fadeOutBlock
{
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:fadeOutAnimation] forKey:kCATransactionAnimationDuration];
	
	CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	fadeAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
	fadeAnimation.toValue = [NSNumber numberWithFloat:0.0f];
	fadeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	fadeAnimation.fillMode = kCAFillModeForwards;
	fadeAnimation.removedOnCompletion = NO;
	[[imgBlockView layer] addAnimation:fadeAnimation forKey:@"fadeAnimation"];
	
	fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	fadeAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
	fadeAnimation.toValue = [NSNumber numberWithFloat:0.0f];
	fadeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	fadeAnimation.fillMode = kCAFillModeForwards;
	fadeAnimation.removedOnCompletion = NO;
	[[btnNumbersTitle layer] addAnimation:fadeAnimation forKey:@"fadeAnimation"];
	
	[CATransaction commit];
}
-(void)fadeOut:(UIButton *)btnGraphic
{		
	if (!countdownView.hidden) {
		int width = self.view.frame.size.width/noOfBalls;
		if (width>GRAPHIC_MAX_WIDTH) {
			width = GRAPHIC_MAX_WIDTH;
		}
		width = width - GRAPHIC_HORIZONTAL_SPACE;
		int height = GRAPHIC_MAX_HEIGHT;
		if (width<GRAPHIC_MAX_HEIGHT) {
			height = width;
		}
		int startPointX = (self.view.frame.size.width - (noOfBalls*(width+GRAPHIC_HORIZONTAL_SPACE)))/2;
		int startPointY = self.view.frame.size.height - height-10;
		for (int i=0; i<noOfBalls; i++) {
			@try {
				UIButton *btnGraphic = [arrBallViews objectAtIndex:i];
				CGRect frame = btnGraphic.frame;
				frame.origin.x = startPointX;
				frame.origin.y = startPointY;
				frame.size.width = width;
				frame.size.height = height;
				btnGraphic.frame = frame;
				startPointX = startPointX + width + GRAPHIC_HORIZONTAL_SPACE;
			}
			@catch (NSException * e) {
			}
			
		}
		noOfBalls--;
	}
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:fadeOutAnimation] forKey:kCATransactionAnimationDuration];
	
	CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	fadeAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
	fadeAnimation.toValue = [NSNumber numberWithFloat:0.0f];
	fadeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	fadeAnimation.fillMode = kCAFillModeForwards;
	fadeAnimation.removedOnCompletion = NO;
	[[btnGraphic layer] addAnimation:fadeAnimation forKey:@"fadeAnimation"];
	
	[CATransaction commit];
}
-(void)fadeIn:(UIButton *)btnGraphic
{
	if (countdownView.hidden) {
		if ([arrBallViews count]>1) {
			Objects *object = [arrObjects objectAtIndex:btnGraphic.tag];
			NSString *strNumberSoundFileName = [NSString stringWithFormat:[self getNumberSoundName],object.ImageName];
			[self playSound:[NSString stringWithFormat:@"%@.mp3",strNumberSoundFileName]];
		}
	}
	else{
		int width = self.view.frame.size.width/noOfBalls;
		if (width>GRAPHIC_MAX_WIDTH) {
			width = GRAPHIC_MAX_WIDTH;
		}
		width = width - GRAPHIC_HORIZONTAL_SPACE;
		int height = GRAPHIC_MAX_HEIGHT;
		if (width<GRAPHIC_MAX_HEIGHT) {
			height = width;
		}
		int startPointX = (self.view.frame.size.width - (noOfBalls*(width+GRAPHIC_HORIZONTAL_SPACE)))/2;
		int startPointY = self.view.frame.size.height - height-10;
		for (int i=0; i<noOfBalls; i++) {
			@try {
				UIButton *btnGraphic = [arrBallViews objectAtIndex:i];
				CGRect frame = btnGraphic.frame;
				frame.origin.x = startPointX;
				frame.origin.y = startPointY;
				frame.size.width = width;
				frame.size.height = height;
				btnGraphic.frame = frame;
				startPointX = startPointX + width + GRAPHIC_HORIZONTAL_SPACE;
			}
			@catch (NSException * e) {
			}
		}
		noOfBalls++;
	}
	btnGraphic.hidden = FALSE;
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:fadeInAnimation] forKey:kCATransactionAnimationDuration];
	
	CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	fadeAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
	fadeAnimation.toValue = [NSNumber numberWithFloat:1.0f];
	fadeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	fadeAnimation.fillMode = kCAFillModeForwards;
	fadeAnimation.removedOnCompletion = NO;
	[[btnGraphic layer] addAnimation:fadeAnimation forKey:@"fadeAnimation"];
	[CATransaction commit];
}
#pragma mark -
#pragma mark VIEW ACTIONS
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
*/

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	resourcePath = [[[NSBundle mainBundle] resourcePath]retain];
	appDelegate.window.windowdelegate = self;
	arrViews = [[NSMutableArray alloc]init];
	arrBallViews = [[NSMutableArray alloc]init];
	dicPlayers = [[NSMutableDictionary alloc]init];
	
	 [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated
{
	@try {
		[appDelegate playSound:@"NumbersBackground.mp3"];
		NSString *strNumbersTitleName = [NSString stringWithFormat:@"%@.png",[self getNumbersTitleGraphicName]];
		[appDelegate setImage:[UIImage thumbnailImage:strNumbersTitleName] ofButton:btnNumbersTitle];
		NSString *strSoundName = [NSString stringWithFormat:@"%@.mp3",[self getNumbersTitleSoundName]];
		[self playSound:strSoundName];
		if([arrViews count]==0)
		{
			btnSelected = nil;
			[self dynamicallyLoadImages];
		}
	}
	@catch (NSException * e) {
	}
	@finally {
	}
	
}

-(void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	for (int i=0; i<[arrViews count]; i++) {
		UIView *v = [arrViews objectAtIndex:i];
		[v removeFromSuperview];
	}
	[arrViews removeAllObjects];
	[appDelegate.window.windowdelegate release];
}

 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
     return (interfaceOrientation == UIInterfaceOrientationPortrait ||
             interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
 }
 

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
	NSLog(@"Numbers did receive memory warnings…");
	[arrBallViews removeAllObjects];
	[UIImage clearThumbnailCache];
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[resourcePath release];
	[imgBackgroundView release];
	[confettiView release];
	[countdownView release];
	[btnCountDown release];
	[imgBlockView release];
	[btnNumbersTitle release];
	[arrObjects removeAllObjects];
	[arrObjects release];
	
	[dicPlayers removeAllObjects];
	[dicPlayers release];
	
	[arrViews removeAllObjects];
	[arrViews release];
	
	[arrBallViews removeAllObjects];
	[arrBallViews release];
	
    [super dealloc];
}

@end
