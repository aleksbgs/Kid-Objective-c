//
//  ColorsViewController_iPhone.m
//  PreSchool
//
//  Created by Acai on 08/12/10.
//  Copyright 2010 Aca Technologies. All rights reserved.
//

#import "ColorsViewController_iPhone.h"


@implementation ColorsViewController_iPhone
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
#pragma mark MOVE STAR
-(void)setFrameOfStar
{
	CGRect frame = [[viewStar.layer presentationLayer] frame];
	viewStar.center = CGPointMake(frame.origin.x +(viewStar.frame.size.width/2), frame.origin.y + (viewStar.frame.size.height/2));
	if (viewStar.tag==1) {
		if (viewStar.center.x<self.view.frame.size.width) {
			//NSLog(@"bunny frame");
		}
		else {
			viewStar.hidden = TRUE;
			[timerStar invalidate];
			timerStar = nil;
		}
	}
	else {
		if (frame.origin.x>=-viewStar.frame.size.width) {
			//NSLog(@"bunny frame");
		}
		else {
			viewStar.hidden = TRUE;
			[timerStar invalidate];
			timerStar = nil;
		}
	}
	
	
}
-(void)moveStar
{
	//viewStar.center = CGPointMake(starStartXPosition, starStartYPosition);
	NSArray *arrStars = [NSLocalizedString(@"appStarImages",nil) componentsSeparatedByString:@","];
	int position = arc4random() % [arrStars count];
	viewStar.image = [UIImage thumbnailImage:[arrStars objectAtIndex:position]];
	viewStar.hidden = FALSE;
	
	timerStar = [NSTimer scheduledTimerWithTimeInterval:starMoveDuration/DIVIDE_FRAME_TIMER target:self selector:@selector(setFrameOfStar) userInfo:nil repeats:YES];
	[[NSRunLoop mainRunLoop] addTimer:timerStar forMode:NSRunLoopCommonModes];
	
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:starMoveDuration] forKey:kCATransactionAnimationDuration];
	
	CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	rotateAnimation.rotationMode = kCAAnimationRotateAuto;
	
	CGPoint ctlPoint = CGPointMake(starControlXPosition, starControlYPosition);
	CGMutablePathRef movePath = CGPathCreateMutable();
	CGPathMoveToPoint(movePath, nil, starStartXPosition, starStartYPosition);
	CGPathAddQuadCurveToPoint(movePath, nil, ctlPoint.x, ctlPoint.y, starEndXPosition, starEndYPosition);
	
	rotateAnimation.path = movePath;
	rotateAnimation.calculationMode= kCAAnimationPaced;
	[rotateAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
	
	[viewStar.layer addAnimation:rotateAnimation forKey:@"moveStarAnimation"];
	
	[CATransaction commit];
	CGPathRelease(movePath);
	
	if (viewStar.tag==0) {
		starStartXPosition = self.view.frame.size.width+viewStar.frame.size.width;
		starStartYPosition = STAR_END_Y;
		starEndXPosition = -viewStar.frame.size.width;
		starEndYPosition = STAR_START_Y;
		
		starControlXPosition = (starStartXPosition+starEndXPosition)/2;
		starControlYPosition = STAR_CONTROL_Y;
	}
	else {
		starStartXPosition = -viewStar.frame.size.width;
		starStartYPosition = STAR_START_Y;
		starEndXPosition = self.view.frame.size.width+viewStar.frame.size.width;
		starEndYPosition = STAR_END_Y;
		
		starControlXPosition = (starEndXPosition+starStartXPosition)/2;
		starControlYPosition = STAR_CONTROL_Y;
	}
	float randomAnimation = starMoveDuration + MAX_TIME_REST + (arc4random() % RANDOM_MAX_DURATION);
	timerMoveStar = [NSTimer scheduledTimerWithTimeInterval:randomAnimation target:self selector:@selector(moveStar) userInfo:nil repeats:NO];
	[[NSRunLoop mainRunLoop] addTimer:timerMoveStar forMode:NSRunLoopCommonModes];
}

#pragma mark -
#pragma mark ANIMATE OBJECT VIEW DELEGATE EVENT

- (void)didClickFirstTime:(id)animView
{
	[self playSoundEffect:@"slide_sound_effect.mp3" withRepeatCount:0];
	if(animView==viewStar)
	{
		if (timerStar) {
			[timerStar invalidate];
			timerStar = nil;
		}
		if (timerMoveStar) {
			[timerMoveStar invalidate];
			timerMoveStar = nil;
		}
		
		[[viewStar layer] removeAllAnimations];
		if (starMoveDuration>=1.0f) {
			starMoveDuration = STAR_MOVE_ANIMATION_DURATION/2.0f;
		}
		[self moveStar];
	}
}
- (void)didClickSecondTime:(id)animView
{
	[self playSoundEffect:@"slide_sound_effect.mp3" withRepeatCount:0];

	if(animView==viewStar)
	{
		if (timerStar) {
			[timerStar invalidate];
			timerStar = nil;
		}
		if (timerMoveStar) {
			[timerMoveStar invalidate];
			timerMoveStar = nil;
		}
		[[viewStar layer] removeAllAnimations];
		starMoveDuration = STAR_MOVE_ANIMATION_DURATION;
		if (viewStar.tag==1) {
			starStartXPosition = self.view.frame.size.width+viewStar.frame.size.width;
			starStartYPosition = STAR_END_Y;
			starEndXPosition = -viewStar.frame.size.width;
			starEndYPosition = STAR_START_Y;
			
			starControlXPosition = (starStartXPosition+starEndXPosition)/2;
			starControlYPosition = STAR_CONTROL_Y;
			viewStar.tag=0;
		}
		else {
			starStartXPosition = -viewStar.frame.size.width;
			starStartYPosition = STAR_START_Y;
			starEndXPosition = self.view.frame.size.width+viewStar.frame.size.width;
			starEndYPosition = STAR_END_Y;
			
			starControlXPosition = (starEndXPosition+starStartXPosition)/2;
			starControlYPosition = STAR_CONTROL_Y;
			viewStar.tag=1;
		}
		
		[self moveStar];
	}
	
}
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
			if(animSequence<4)
			{
				UIButton *btnColor = [arrColorsOnScreen objectAtIndex:position];
				if ([dicColorTimer count]>0) {
					NSTimer *timer = [dicColorTimer valueForKey:[NSString stringWithFormat:@"%i",btnColor.tag]];
					if (timer) {
						[timer invalidate];
						timer=nil;
						[dicColorTimer removeObjectForKey:[NSString stringWithFormat:@"%i",btnColor.tag]];
					}
				}
				
				//NSTimer *timer = nil;
				switch (animSequence) {
					case 0:
						btnColor.center = self.view.center;
						//timer = [NSTimer scheduledTimerWithTimeInterval:REMAIN_ANIMATION target:self selector:@selector(putColorOnScreen:) userInfo:[NSDictionary dictionaryWithObjectsAndKeys:btnColor, @"btnColor", [NSString stringWithFormat:@"%d",position],@"position",  nil] repeats:NO];
//						[[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
//						[arrTimers addObject:timer];
						[self performSelectorOnMainThread:@selector(putColorOnScreen:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:btnColor, @"btnColor", [NSString stringWithFormat:@"%d",position],@"position",  nil] waitUntilDone:NO];
						
						break;
					case 1:
						[self setFrameOfColor:btnColor];
						//[self enableButton:btnColor];
						[[btnColor layer] removeAllAnimations];
						break;
					case 2:
						//timer = [NSTimer scheduledTimerWithTimeInterval:REMAIN_ANIMATION target:self selector:@selector(putColorAtOriginPosition:) userInfo:[NSDictionary dictionaryWithObjectsAndKeys:btnColor, @"btnColor", [NSString stringWithFormat:@"%d",position],@"position",  nil] repeats:NO];
//						[[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
//						[arrTimers addObject:timer];
						
						[self performSelectorOnMainThread:@selector(putColorAtOriginPosition:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:btnColor, @"btnColor", [NSString stringWithFormat:@"%d",position],@"position",  nil] waitUntilDone:NO];
						break;
					case 3:
						[self setFrameOfColor:btnColor];
						//[self enableButton:btnColor];
						[[btnColor layer] removeAllAnimations];
						break;
					default:
						break;
				}
			}
			else {
				UIImageView *imageView = [arrCommetsOnScreen objectAtIndex:position];
				[imageView removeFromSuperview];
				[[imageView layer] removeAllAnimations];
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
}
#pragma mark -
#pragma mark ANIMATIONS

-(void)setFrameOfColorWithTimer:(NSTimer *)Timer
{
	NSLog(@"setShapeFrame");
	UIButton *btnColor = [[Timer userInfo] valueForKey:@"colour"];
	CGRect frame =[[[btnColor layer]presentationLayer] frame];
	CGFloat xPositon = frame.origin.x+frame.size.width/2;
	CGFloat yPosition = frame.origin.y+frame.size.height/2;
	//NSLog(@"current position of button:- %f %f and width is:- %f %f and original size is:- %f %f",frame.origin.x, frame.origin.y,frame.size.width,frame.size.height,btnShape.frame.size.width,btnShape.frame.size.height);
	//btnShape.frame = CGRectMake(frame.origin.x, frame.origin.y, btnShape.frame.size.width, btnShape.frame.size.height);
	btnColor.center = CGPointMake(xPositon, yPosition);
}

-(void)setFrameOfColor:(UIButton *)btnBigColor{
	btnBigColor.enabled = TRUE;
	CGRect frame =[[[btnBigColor layer] presentationLayer] frame];
	btnBigColor.frame = frame;
}
-(void)putColorAtOriginPositionInMainThread:(NSDictionary*)btnDictionary{
	UIButton *btnColor = [btnDictionary objectForKey:@"btnColor"];
	int position = [[btnDictionary objectForKey:@"position"]intValue];
	
	CGFloat xPosition = [[[dicCenterPoint objectForKey:[NSString stringWithFormat:@"%i",btnColor.tag]] objectAtIndex:0]floatValue];
	CGFloat yPosition = [[[dicCenterPoint objectForKey:[NSString stringWithFormat:@"%i",btnColor.tag]] objectAtIndex:1]floatValue];
	btnColor.center = self.view.center;
	
	[self playSoundEffect:@"shapes_collapse.mp3" withRepeatCount:0];
	
	if ([dicColorTimer count]>0) {
		NSTimer *timer = [dicColorTimer valueForKey:[NSString stringWithFormat:@"%i",btnColor.tag]];
		if (timer) {
			[timer invalidate];
			timer=nil;
			[dicColorTimer removeObjectForKey:[NSString stringWithFormat:@"%i",btnColor.tag]];
		}
	}
	
	NSTimer *colorTimer = [NSTimer timerWithTimeInterval:0.00002 target:self selector:@selector(setFrameOfColorWithTimer:) userInfo:[NSDictionary dictionaryWithObject:btnColor forKey:@"colour"] repeats:YES];
	[[NSRunLoop mainRunLoop]addTimer:colorTimer forMode:NSRunLoopCommonModes];
	[dicColorTimer setObject:colorTimer forKey:[NSString stringWithFormat:@"%i",btnColor.tag]];
	
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:TRANSITION_ANIMATION] forKey:kCATransactionAnimationDuration];
	
	CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	CGMutablePathRef positionPath = CGPathCreateMutable();
	CGPathMoveToPoint(positionPath, NULL, self.view.center.x , self.view.center.y);
	CGPathAddLineToPoint(positionPath, NULL, xPosition,  yPosition);
	positionAnimation.path = positionPath;
	
	CABasicAnimation *shrinkAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	shrinkAnimation.fromValue = [NSNumber numberWithFloat:kScaleFactor];
	shrinkAnimation.toValue = [NSNumber numberWithFloat:1.0f];
	
	CAAnimationGroup *theGroup = [CAAnimationGroup animation];
	theGroup.delegate = self;
	theGroup.removedOnCompletion = NO;
	theGroup.fillMode = kCAFillModeForwards;
	theGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	theGroup.animations = [NSArray arrayWithObjects:positionAnimation, shrinkAnimation,nil];
	NSString *strPosition = [NSString stringWithFormat:@"%d,3",position];
	[theGroup setValue:strPosition forKey:@"AnimationGroup"];
	[[btnColor layer] addAnimation:theGroup forKey:@"AnimationGroup"];
	
	[CATransaction commit];
	
	CGPathRelease(positionPath);
	
	//[arrTimers removeObject:timer];
	
}
-(void)putColorAtOriginPosition:(NSDictionary *)btnDictionary
{
	[self performSelector:@selector(putColorAtOriginPositionInMainThread:) withObject:btnDictionary afterDelay:REMAIN_ANIMATION];
}

-(void)putColorOnScreenInMainThread:(NSDictionary*)btnDictionary{
	UIButton *btnBigColor = [btnDictionary objectForKey:@"btnColor"];
	int position = [[btnDictionary objectForKey:@"position"]intValue];
	[self playSoundEffect:@"shapes_collapse.mp3" withRepeatCount:0];
	
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
	CGPathMoveToPoint(thePath, NULL, self.view.center.x, self.view.center.y);
	CGPoint point1,point2;
	for (int i=0; i<kNoOfJumps; i++) {
		point1 = CGPointMake(self.view.center.x+(valueX*i), self.view.center.y+(valueY*i));
		point2 = CGPointMake(self.view.center.x+(valueX*(i+1)), self.view.center.y+(valueY*(i+1)));
		if (point1.y>=self.view.frame.size.height) {
			break;
		}
		CGPathAddCurveToPoint(thePath,
							  NULL,
							  point1.x,point1.y-JUMP,
							  point2.x,point1.y-JUMP,
							  point2.x,point1.y);
	}
	
	if ([dicColorTimer count]>0) {
		NSTimer *timer = [dicColorTimer valueForKey:[NSString stringWithFormat:@"%i",btnBigColor.tag]];
		if (timer) {
			[timer invalidate];
			timer=nil;
			[dicColorTimer removeObjectForKey:[NSString stringWithFormat:@"%i",btnBigColor.tag]];
		}
	}
	
	NSTimer *colorTimer = [NSTimer timerWithTimeInterval:0.00002 target:self selector:@selector(setFrameOfColorWithTimer:) userInfo:[NSDictionary dictionaryWithObject:btnBigColor forKey:@"colour"] repeats:YES];
	[[NSRunLoop mainRunLoop]addTimer:colorTimer forMode:NSRunLoopCommonModes];
	[dicColorTimer setObject:colorTimer forKey:[NSString stringWithFormat:@"%i",btnBigColor.tag]];
	
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:TRANSITION_ANIMATION] forKey:kCATransactionAnimationDuration];
	
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
	[[btnBigColor layer] addAnimation:theGroup forKey:@"AnimationGroup"];
	
	[CATransaction commit];
	
	CGPathRelease(thePath);
	
	//[arrTimers removeObject:timer];

}
-(void)putColorOnScreen:(NSDictionary *)btnDictionary
{
	[self performSelector:@selector(putColorOnScreenInMainThread:) withObject:btnDictionary afterDelay:REMAIN_ANIMATION];
	
}
#pragma mark -
#pragma mark GET IMAGES AS PER LANGUAGE
-(NSString *)getColorsTitleImageName
{
	NSString *alphabetImageName = NSLocalizedString(@"appColorsTitleImage",nil);
	@try {
		int value = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] intValue];
		switch (value) {
			case 0:
				alphabetImageName = NSLocalizedString(@"appColorsTitleImage",nil);
				break;
			case 1:
				alphabetImageName = @"colorstitle.png";
				break;
			case 2:
				alphabetImageName = @"colorstitle_spanish.png";
				break;
			case 3:
				alphabetImageName = @"colorstitle_french.png";
				break;
			default:
				break;
		}
	}
	@catch (NSException * e) {
	}
	@finally {
		return alphabetImageName;
	}
}
-(NSString *)getColorsTitleSoundName
{
	NSString *alphabetImageName = NSLocalizedString(@"appColorsTitleSoundName",nil);
	@try {
		int value = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] intValue];
		switch (value) {
			case 0:
				alphabetImageName = NSLocalizedString(@"appColorsTitleSoundName",nil);
				break;
			case 1:
				alphabetImageName = @"colors";
				break;
			case 2:
				alphabetImageName = @"colors_spanish";
				break;
			case 3:
				alphabetImageName = @"colors_french";
				break;
			default:
				break;
		}
	}
	@catch (NSException * e) {
	}
	@finally {
		return alphabetImageName;
	}
}
-(NSString *)getColorsImageName
{
	NSString *charImageName = NSLocalizedString(@"appColorsChalkImageName",nil);
	@try {
		int value = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] intValue];
		switch (value) {
			case 0:
				charImageName = NSLocalizedString(@"appColorsChalkImageName",nil);
				break;
			case 1:
				charImageName = @"%@_chalk";
				break;
			case 2:
				charImageName = @"%@_chalk";
				break;
			case 3:
				charImageName = @"%@_chalk";
				break;
			default:
				break;
		}
	}
	@catch (NSException * e) {
	}
	@finally {
		return charImageName;
	}
}
-(NSString *)getColorsSoundName
{
	NSString *soundName = NSLocalizedString(@"appColorsSoundName",nil);;
	@try {
		int value = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] intValue];
		switch (value) {
			case 0:
				soundName = NSLocalizedString(@"appColorsSoundName",nil);;
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
-(NSString *)getRainbowSoundName
{
	NSString *soundName = NSLocalizedString(@"appRainbowSoundName",nil);;
	@try {
		int value = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] intValue];
		switch (value) {
			case 0:
				soundName = NSLocalizedString(@"appRainbowSoundName",nil);;
				break;
			case 1:
				soundName = @"rainbow";
				break;
			case 2:
				soundName = @"rainbow_spanish";
				break;
			case 3:
				soundName = @"rainbow_french";
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
#pragma mark -
#pragma mark DRAG EVENTS
- (void)color:(UIButton *)color didStartDrag:(UIEvent *)event
{
	dragFlag = YES;
	if ([dicColorTimer count]>0) {
		NSTimer *timer = [dicColorTimer valueForKey:[NSString stringWithFormat:@"%i",color.tag]];
		if (timer) {
			[timer invalidate];
			timer=nil;
			[dicColorTimer removeObjectForKey:[NSString stringWithFormat:@"%i",color.tag]];
		}
	}
	
	if(color == btnAnimationRunning){
		NSLog(@"Match");
		NSString *position = [NSString stringWithFormat:@"%d",[arrColorsOnScreen indexOfObject:color]];
		//NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:fruit,@"",position,@"",nil];
		NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:color, @"btnColor", position,@"position",  nil];
		[NSRunLoop cancelPreviousPerformRequestsWithTarget:self selector:@selector(putColorOnScreenInMainThread:) object:dict];
		[NSRunLoop cancelPreviousPerformRequestsWithTarget:self selector:@selector(putColorAtOriginPositionInMainThread:) object:dict];
	}
	
	[[color layer] removeAllAnimations];
	
	UITouch *touch = [[event allTouches] anyObject];
	if (touch.phase == UITouchPhaseMoved) {
		if (!isMoving) {
			dragPlayer = [self playSoundDragEffect:@"DragLetter.mp3" withRepeatCount:-1];
		}
		isMoving = TRUE;
		CGPoint touchDownPoint = [touch locationInView:color.superview];
		color.center = touchDownPoint;
	}
}
- (void)color:(UIButton *)color didEndDrag:(UIEvent *)event
{
	if ([dicColorTimer count]>0) {
		NSTimer *timer = [dicColorTimer valueForKey:[NSString stringWithFormat:@"%i",color.tag]];
		if (timer) {
			[timer invalidate];
			timer=nil;
			[dicColorTimer removeObjectForKey:[NSString stringWithFormat:@"%i",color.tag]];
		}
	}
	
	[[color layer] removeAllAnimations];
	
	if (isMoving) {
		isMoving = FALSE;
		[self doVolumeFade:dragPlayer];
	}
	else {
		[self colorClicked:color];
	}
}
-(void)colorChalk:(UIButton*)btnSelected didStartDrag:(UIEvent*)event{
	NSLog(@"did start darg");
	if (dragCount == 0) {
		
		Objects *object = [arrObjects objectAtIndex:btnSelected.tag];
		NSString *strSoundName = [NSString stringWithFormat:[self getColorsSoundName],object.ImageName];
		[self playSound:[NSString stringWithFormat:@"%@.mp3",strSoundName]];
		[self playSoundEffect:@"TapChalkColors.mp3" withRepeatCount:0];
		NSArray *graphicsLibrary = [NSLocalizedString(@"appColorLibrary",nil) componentsSeparatedByString:@","];
		int position = arc4random() % [graphicsLibrary count];
		NSString *imageName = [graphicsLibrary objectAtIndex:position];
		imageName = [NSString stringWithFormat:imageName,object.ImageName];
		
		UIButton *btnBigColor = [UIButton buttonWithType:UIButtonTypeCustom];
		//btnBigColor.enabled = FALSE;
		btnBigColor.frame = CGRectMake(btnSelected.frame.origin.x-(BIG_BUTTON_WIDTH/2), btnSelected.frame.origin.y-(BIG_BUTTON_HEIGHT/2), BIG_BUTTON_WIDTH, BIG_BUTTON_HEIGHT);
		[btnBigColor addTarget:self action:@selector(color:didStartDrag:) forControlEvents:UIControlEventTouchDragInside | UIControlEventTouchDragOutside];
		[btnBigColor addTarget:self action:@selector(color:didEndDrag:) forControlEvents:UIControlEventTouchDragExit|UIControlEventTouchCancel|UIControlEventTouchUpOutside | UIControlEventTouchUpInside];
		
		btnBigColor.tag = btnSelected.tag;
		[appDelegate setImage:[UIImage thumbnailImage:imageName] ofButton:btnBigColor];
		btnBigColor.imageView.contentMode = UIViewContentModeScaleAspectFit;
		
		[self.view addSubview:btnBigColor];
		[arrColorsOnScreen addObject:btnBigColor];
		
		[CATransaction begin];
		[CATransaction setValue:[NSNumber numberWithFloat:TRANSITION_ANIMATION] forKey:kCATransactionAnimationDuration];
		
		CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
		CGMutablePathRef positionPath = CGPathCreateMutable();
		CGPathMoveToPoint(positionPath, NULL, btnSelected.center.x ,  btnSelected.center.y );
		CGPathAddLineToPoint(positionPath, NULL,btnSelected.center.x , btnSelected.center.y-40);
		positionAnimation.autoreverses = TRUE;
		positionAnimation.path = positionPath;
		positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
		//positionAnimation.fillMode = kCAFillModeForwards;
		positionAnimation.removedOnCompletion = YES;
		[[btnSelected layer] addAnimation:positionAnimation forKey:@"moveColorAnimation"];
		
		CGPathRelease(positionPath);
		[CATransaction commit];
		
	}
	else {
		UIButton *btn = [arrColorsOnScreen lastObject];
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

-(void)colorChalk:(UIButton*)fruiet didEndDrag:(UIEvent*)event{
	NSLog(@"didEnd drag");
	dragCount = 0;
	if (isMoving) {
		isMoving = FALSE;
		//[self doVolumeFade:dragPlayer];
		
	}
	dragCount = 0;
}



#pragma mark -
#pragma mark ADD COMMET FUNCTION
-(void)addCommetsToScreen{
	for (int i=0; i<[arrCommetsOnScreen count]; i++) {
		UIImageView *imageView = [arrCommetsOnScreen objectAtIndex:i];
		[imageView removeFromSuperview];
	}
	[arrCommetsOnScreen removeAllObjects];
	
	int randomCount = arc4random() % MAX_COMMETS;
	if (randomCount==0) {
		randomCount = 1;
	}
	int direction = -1;
	NSArray *arrImages = [NSLocalizedString(@"appCometImages",nil) componentsSeparatedByString:@","];
	for (int i=0; i<randomCount; i++) {
		int randomPosition = arc4random() % [arrImages count];
		int x = arc4random()% (int)self.view.frame.size.width;
		int y = arc4random()% (int)self.view.frame.size.height;
		UIImage *image = [UIImage thumbnailImage:[arrImages objectAtIndex:randomPosition]];
		UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
		imageView.frame = CGRectMake(x, y, COMET_IMAGE_WIDTH, COMET_IMAGE_HEIGHT);
		[arrCommetsOnScreen addObject:imageView];
		[self.view addSubview:imageView];
		
		if (x<self.view.center.x) {
			direction = 1;
		}
		else {
			direction = -1;
		}

		[CATransaction begin];
		[CATransaction setValue:[NSNumber numberWithFloat:COMMET_ANIMATION] forKey:kCATransactionAnimationDuration];
		
		CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	
		CGMutablePathRef positionPath = CGPathCreateMutable();
		CGPathMoveToPoint(positionPath, NULL, imageView.center.x ,  imageView.center.y );
		CGPathAddLineToPoint(positionPath, NULL,self.view.frame.size.width*direction , -20);
		positionAnimation.path = positionPath;
		
		positionAnimation.rotationMode = kCAAnimationRotateAuto;
		positionAnimation.delegate = self;
		positionAnimation.removedOnCompletion = NO;
		positionAnimation.fillMode = kCAFillModeForwards;
		positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
		
		NSString *strPosition = [NSString stringWithFormat:@"%d,4",i];
		[positionAnimation setValue:strPosition forKey:@"AnimationGroup"];
		[[imageView layer] addAnimation:positionAnimation forKey:@"moveCommetAnimation"];
		
		CGPathRelease(positionPath);
		
		[CATransaction commit];
		
		[imageView release];
	}
}
#pragma mark -
#pragma mark REMOVE ALL GRAPHICS ON SCREEN
-(void)removeAllAudioPlayers
{
	[dicCenterPoint removeAllObjects];
	if ([dicColorTimer count]>0) {
		for (int i=0; i<[dicColorTimer count]; i++) {
			NSTimer *timer = [dicColorTimer objectForKey:[[dicColorTimer allKeys]objectAtIndex:i]];
			if (timer) {
				[timer invalidate];
				timer = nil;
			}
		}
		[dicColorTimer removeAllObjects];
	}
	
	for (int i=0; i<[dicPlayers count]; i++) {
		AVAudioPlayer *avPlayer= [dicPlayers objectForKey:[[dicPlayers allKeys]objectAtIndex:i]];
		[avPlayer stop];
		[avPlayer release];
	}
	[dicPlayers removeAllObjects];
}
-(void)removeAllColorsOnScreen
{
	[self removeAllAudioPlayers];
	for (int i=0; i<[arrTimers count]; i++) {
		NSTimer *timer = [arrTimers objectAtIndex:i];
		if ([timer isValid]) {
			[timer invalidate];
		}
	}
	[arrTimers removeAllObjects];
	
	for (int i=0; i<[arrColorsOnScreen count]; i++) {
		UIButton *btnColor = [arrColorsOnScreen objectAtIndex:i];
		[[btnColor layer] removeAllAnimations];
		[btnColor removeFromSuperview];
	}
	[arrColorsOnScreen removeAllObjects];
}
#pragma mark -
#pragma mark BUTTON ACTIONS
-(IBAction)rainbow:(id)sender{
	[self addCommetsToScreen];
	NSString *strSoundName = [NSString stringWithFormat:@"%@.mp3",[self getRainbowSoundName]];
	[self playSound:strSoundName];
}
-(IBAction)colorsTitleClicked:(id)sender{
	[self removeAllColorsOnScreen];
	NSString *strSoundName = [NSString stringWithFormat:@"%@.mp3",[self getColorsTitleSoundName]];
	[self playSound:strSoundName];
}
-(IBAction)colorClicked:(id)sender{
	UIButton *btnSelected = sender;
	CAAnimation *anim = [[btnSelected layer]animationForKey:@"moveColorAnimation"];
	if (!anim) {
		[self.view bringSubviewToFront:btnSelected];
	//	btnSelected.enabled = FALSE;
		Objects *object = [arrObjects objectAtIndex:btnSelected.tag];
		NSString *strSoundName = [NSString stringWithFormat:[self getColorsSoundName],object.ImageName];
		[self playSound:[NSString stringWithFormat:@"%@.mp3",strSoundName]];
		
		[self playSoundEffect:@"shapes_expand.mp3" withRepeatCount:0];
		
		if ([dicColorTimer count]>0) {
			NSTimer *timer = [dicColorTimer valueForKey:[NSString stringWithFormat:@"%i",btnSelected.tag]];
			if (timer) {
				[timer invalidate];
				timer=nil;
				[dicColorTimer removeObjectForKey:[NSString stringWithFormat:@"%i",btnSelected.tag]];
			}
		}
		
		NSTimer *colorTimer = [NSTimer timerWithTimeInterval:0.00002 target:self selector:@selector(setFrameOfColorWithTimer:) userInfo:[NSDictionary dictionaryWithObject:btnSelected forKey:@"colour"] repeats:YES];
		[[NSRunLoop mainRunLoop]addTimer:colorTimer forMode:NSRunLoopCommonModes];
		[dicColorTimer setObject:colorTimer forKey:[NSString stringWithFormat:@"%i",btnSelected.tag]];
		
		NSMutableArray *arrPoint = [[NSMutableArray alloc] init];
		[arrPoint addObject:[NSString stringWithFormat:@"%f",btnSelected.center.x]];
		[arrPoint addObject:[NSString stringWithFormat:@"%f",btnSelected.center.y]];
		[dicCenterPoint setObject:arrPoint forKey:[NSString stringWithFormat:@"%i",btnSelected.tag]];
		[arrPoint release];
		
		[CATransaction begin];
		[CATransaction setValue:[NSNumber numberWithFloat:TRANSITION_ANIMATION] forKey:kCATransactionAnimationDuration];
		
		CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
		CGMutablePathRef positionPath = CGPathCreateMutable();
		CGPathMoveToPoint(positionPath, NULL, btnSelected.center.x ,  btnSelected.center.y );
		CGPathAddLineToPoint(positionPath, NULL, self.view.center.x , self.view.center.y);
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
		int position = [arrColorsOnScreen indexOfObject:btnSelected];
		NSString *strPosition = [NSString stringWithFormat:@"%d,2",position];
		[theGroup setValue:strPosition forKey:@"AnimationGroup"];
		[[btnSelected layer] addAnimation:theGroup forKey:@"AnimationGroup"];	
		
		btnAnimationRunning = btnSelected;
		[CATransaction commit];
		
		CGPathRelease(positionPath);
	}
}
-(IBAction)colorChalkClicked:(id)sender{
	if (dragCount==0) {
		UIButton *btnSelected = sender;
		Objects *object = [arrObjects objectAtIndex:btnSelected.tag];
		NSString *strSoundName = [NSString stringWithFormat:[self getColorsSoundName],object.ImageName];
		NSLog(@"sound name is:- %@",strSoundName);
		[self playSound:[NSString stringWithFormat:@"%@.mp3",strSoundName]];
		[self playSoundEffect:@"TapChalkColors.mp3" withRepeatCount:0];
		NSArray *graphicsLibrary = [NSLocalizedString(@"appColorLibrary",nil) componentsSeparatedByString:@","];
		int position = arc4random() % [graphicsLibrary count];
		NSString *imageName = [graphicsLibrary objectAtIndex:position];
		imageName = [NSString stringWithFormat:imageName,object.ImageName];
		UIButton *btnBigColor = [UIButton buttonWithType:UIButtonTypeCustom];
		//btnBigColor.enabled = FALSE;
		btnBigColor.frame = CGRectMake(btnSelected.frame.origin.x-(BIG_BUTTON_WIDTH/2), btnSelected.frame.origin.y-(BIG_BUTTON_HEIGHT/2), BIG_BUTTON_WIDTH, BIG_BUTTON_HEIGHT);
		[btnBigColor addTarget:self action:@selector(color:didStartDrag:) forControlEvents:UIControlEventTouchDragInside | UIControlEventTouchDragOutside];
		[btnBigColor addTarget:self action:@selector(color:didEndDrag:) forControlEvents:UIControlEventTouchDragExit|UIControlEventTouchCancel|UIControlEventTouchUpOutside | UIControlEventTouchUpInside];
		
		btnBigColor.tag = btnSelected.tag;
		[appDelegate setImage:[UIImage thumbnailImage:imageName] ofButton:btnBigColor];
		btnBigColor.imageView.contentMode = UIViewContentModeScaleAspectFit;
		
		[self.view addSubview:btnBigColor];
		[arrColorsOnScreen addObject:btnBigColor];
		
		//[self.view bringSubviewToFront:btnSelected];
		
		if ([dicColorTimer count]>0) {
			NSTimer *timer = [dicColorTimer valueForKey:[NSString stringWithFormat:@"%i",btnBigColor.tag]];
			if (timer) {
				[timer invalidate];
				timer=nil;
				[dicColorTimer removeObjectForKey:[NSString stringWithFormat:@"%i",btnBigColor.tag]];
			}
		}
		
		NSTimer *colorTimer = [NSTimer timerWithTimeInterval:0.00002 target:self selector:@selector(setFrameOfColorWithTimer:) userInfo:[NSDictionary dictionaryWithObject:btnBigColor forKey:@"colour"] repeats:YES];
		[[NSRunLoop mainRunLoop]addTimer:colorTimer forMode:NSRunLoopCommonModes];
		[dicColorTimer setObject:colorTimer forKey:[NSString stringWithFormat:@"%i",btnBigColor.tag]];
		
		
		[CATransaction begin];
		[CATransaction setValue:[NSNumber numberWithFloat:TRANSITION_ANIMATION] forKey:kCATransactionAnimationDuration];
		
		CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
		CGMutablePathRef positionPath = CGPathCreateMutable();
		CGPathMoveToPoint(positionPath, NULL, btnSelected.center.x ,  btnSelected.center.y );
		CGPathAddLineToPoint(positionPath, NULL,btnSelected.center.x , btnSelected.center.y-40);
		positionAnimation.autoreverses = TRUE;
		positionAnimation.path = positionPath;
		positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
		//positionAnimation.fillMode = kCAFillModeForwards;
		positionAnimation.removedOnCompletion = YES;
		[[btnSelected layer] addAnimation:positionAnimation forKey:@"moveColorAnimation"];
		
		
		CGPathRelease(positionPath);
		
		positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
		positionPath = CGPathCreateMutable();
		CGPathMoveToPoint(positionPath, NULL, btnBigColor.center.x ,  btnBigColor.center.y );
		CGPathAddLineToPoint(positionPath, NULL,self.view.center.x , self.view.center.y);
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
		int colorposition = [arrColorsOnScreen indexOfObject:btnBigColor];
		NSString *strPosition = [NSString stringWithFormat:@"%d,0",colorposition];
		[theGroup setValue:strPosition forKey:@"AnimationGroup"];
		[[btnBigColor layer] addAnimation:theGroup forKey:@"AnimationGroup"];	
		
		btnAnimationRunning = btnBigColor;
		[CATransaction commit];
		
		CGPathRelease(positionPath);
	}
	dragCount=0;
}
-(IBAction)back:(id)sender
{
	[UIImage clearThumbnailCache];
	[self removeAllColorsOnScreen];
	if (dragPlayer && [dragPlayer isPlaying]) {
		[dragPlayer stop];
		[dragPlayer release];
		dragPlayer = nil;
	}
	[self.navigationController popViewControllerAnimated:YES];
}
-(void)transformChalk:(UIButton *)btnChalk
{
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:CHALK_ANIMATION_DURATION] forKey:kCATransactionAnimationDuration];
	
	int x= [btnChalk layer].position.x;
	int y = [btnChalk layer].position.y;
	CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	CGMutablePathRef positionPath = CGPathCreateMutable();
	CGPathMoveToPoint(positionPath, NULL, x, LOAD_Y);
	CGPathAddLineToPoint(positionPath, NULL,  x,  y);
	positionAnimation.path = positionPath;
	positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	positionAnimation.fillMode = kCAFillModeForwards;
	positionAnimation.removedOnCompletion = NO;
	[[btnChalk layer] addAnimation:positionAnimation forKey:@"positionAnimation"];
	
	[CATransaction commit];
}
#pragma mark -
#pragma mark AUDIO PLAYER FINISHED EVENT
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)avPlayer error:(NSError *)error
{
	avPlayer = nil;
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)avPlayer successfully:(BOOL)flag
{
	NSObject *object = [dicPlayers objectForKey:[avPlayer description]];
	if (object) {
		[dicPlayers removeObjectForKey:[avPlayer description]];
		[avPlayer release];
	}
}
#pragma mark -
#pragma mark DYNAMICALLY LOAD IMAGES
-(void)dynamicallyLoadImages
{
	int startX = START_X, startY=START_Y;
	for (int i=0; i<[arrObjects count]; i++) {
		Objects *object = [arrObjects objectAtIndex:i];
		CGRect frame =  CGRectMake(startX, startY, BUTTON_WIDTH, BUTTON_HEIGHT);
		UIButton *btnImage = [UIButton buttonWithType:UIButtonTypeCustom];
		NSString *imageName = [NSString stringWithFormat:[self getColorsImageName],object.ImageName];
		[appDelegate setImage:[UIImage thumbnailImage:[NSString stringWithFormat:@"%@.png",imageName]] ofButton:btnImage];
		[btnImage addTarget:self action:@selector(colorChalkClicked:) forControlEvents:UIControlEventTouchUpInside];
		[btnImage addTarget:self action:@selector(colorChalk:didStartDrag:) forControlEvents:UIControlEventTouchDragInside|UIControlEventTouchDragOutside];
		[btnImage addTarget:self action:@selector(colorChalk:didEndDrag:) forControlEvents:UIControlEventTouchUpOutside|UIControlEventEditingDidEndOnExit|UIControlEventTouchUpInside];
		btnImage.imageView.contentMode = UIViewContentModeScaleAspectFill;
		btnImage.frame =frame;
		btnImage.tag = i;
		[self.view addSubview:btnImage];
		[self transformChalk:btnImage];
		startX = (startX + BUTTON_WIDTH + COLUMN_SPACE);
		[arrViews addObject:btnImage];
	}
}
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
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
	[appDelegate setImage:[UIImage thumbnailImage:@"rainbow.png"] ofButton:btnRainbow];
	resourcePath = [[[NSBundle mainBundle]resourcePath] retain];
	arrViews = [[NSMutableArray alloc]init];
	arrColorsOnScreen = [[NSMutableArray alloc]init];
	arrTimers = [[NSMutableArray alloc]init];
	arrCommetsOnScreen = [[NSMutableArray alloc]init];
	dicPlayers = [[NSMutableDictionary alloc]init];
	dicColorTimer = [[NSMutableDictionary alloc] init];
	dicCenterPoint = [[NSMutableDictionary alloc] init];
	viewStar.tag = 1;
	
	starStartXPosition = -viewStar.frame.size.width;
	starStartYPosition = STAR_START_Y;
	starEndXPosition = self.view.frame.size.width+viewStar.frame.size.width;
	starEndYPosition = STAR_END_Y;
	
	starControlXPosition = (starEndXPosition+starStartXPosition)/2;
	starControlYPosition = STAR_CONTROL_Y;
	
	starMoveDuration = STAR_MOVE_ANIMATION_DURATION;
	
	[self dynamicallyLoadImages];
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
	@try {
		[appDelegate playSound:@"ColorsBackground.mp3"];
		NSString *strColorsTitleName = [self getColorsTitleImageName];
		[appDelegate setImage:[UIImage thumbnailImage:strColorsTitleName] ofButton:btnColorsTitle];
		NSString *strSoundName = [NSString stringWithFormat:@"%@.mp3",[self getColorsTitleSoundName]];
		[self playSound:strSoundName];
		if([arrViews count]==0)
		{
			[self dynamicallyLoadImages];
		}
		
		[self moveStar];
		
	}
	@catch (NSException * e) {
	}
	@finally {
	}
}

-(void)viewDidDisappear:(BOOL)animated
{
	for (int i=0; i<[arrViews count]; i++) {
		UIView *v = [arrViews objectAtIndex:i];
		[v removeFromSuperview];
	}
	if (timerStar) {
		[timerStar invalidate];
		timerStar = nil;
	}
	if (timerMoveStar) {
		[timerMoveStar invalidate];
		timerMoveStar = nil;
	}
	viewStar.hidden = TRUE;
	[[viewStar layer] removeAllAnimations];
	[arrViews removeAllObjects];
}

 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
     return (interfaceOrientation == UIInterfaceOrientationPortrait ||
             interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
 }
 

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
	NSLog(@"Alphabet did receive memory warnings…");
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
	[dicColorTimer release];
	[dicCenterPoint release];
	[arrViews removeAllObjects];
	[arrViews release];
	[arrCommetsOnScreen removeAllObjects];
	[arrCommetsOnScreen release];
	[arrColorsOnScreen removeAllObjects];
	[arrColorsOnScreen release];
	[arrObjects removeAllObjects];
	[arrObjects release];
	[arrTimers removeAllObjects];
	[arrTimers release];
	[dicPlayers removeAllObjects];
	[dicPlayers release];
	
	[btnColorsTitle release];
	[imgBackgroundView release];
	
    [super dealloc];
}


@end
