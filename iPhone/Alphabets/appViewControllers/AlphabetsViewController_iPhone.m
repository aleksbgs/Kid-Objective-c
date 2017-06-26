//
//  AlphabetsViewController_iPhone.m
//  PreSchool
//
//  Created by Acai on 08/12/10.
//  Copyright 2010 Aca Technologies. All rights reserved.
//

#import "AlphabetsViewController_iPhone.h"

@implementation AlphabetsViewController_iPhone
-(void)setCategory:(Category *)category{
	if(!appDelegate)
	{
		appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
	}
	if (!arrObjects) {
		arrObjects = [[appDelegate getObjectsByCategoryID:category.ID] retain];
		appDelegate.arrCurrentObjects = arrObjects;
	}
}

-(void)removeAllTimers{
	[[viewBall layer] removeAllAnimations];
	[[viewBird layer] removeAllAnimations];
	[[viewBunny layer] removeAllAnimations];
	[[viewPaperPlane layer] removeAllAnimations];
	[[viewSpider layer] removeAllAnimations];
	
	[[btnSun layer] removeAllAnimations];
	[[imgSunRays layer] removeAllAnimations];
	
	
	if (timerBall) {
		[timerBall invalidate];
		timerBall = nil;
	}
	if (timerMoveBall) {
		[timerMoveBall invalidate];
		timerMoveBall = nil;
	}
	if (timerBird) {
		[timerBird invalidate];
		timerBird = nil;
	}
	if (timerMoveBird) {
		[timerMoveBird invalidate];
		timerMoveBird = nil;
	}
	if (timerBunny) {
		[timerBunny invalidate];
		timerBunny = nil;
	}
	if (timerMoveBunny) {
		[timerMoveBunny invalidate];
		timerMoveBunny = nil;
	}
	if (timerPaperPlane) {
		[timerPaperPlane invalidate];
		timerPaperPlane = nil;
	}
	if (timerMovePaperPlane) {
		[timerMovePaperPlane invalidate];
		timerMovePaperPlane = nil;
	}
	if (timerSpider) {
		[timerSpider invalidate];
		timerSpider = nil;
	}
	if (timerMoveSpider) {
		[timerMoveSpider invalidate];
		timerMoveSpider = nil;
	}
	isAnimationOnScreen = FALSE;
}
#pragma mark -
#pragma mark AUDIO PLAYER
-(void)playAudioPlayer:(NSTimer *)timer
{
	NSString *soundFileName = [[timer userInfo] objectForKey:@"SoundName"];
	int repeatCount = [[[timer userInfo] objectForKey:@"RepeatCount"]intValue];
	@try {
		NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
		resourcePath = [resourcePath stringByAppendingPathComponent:soundFileName];
		//NSLog(@"Path to play: %@", resourcePath);
		NSError* err;
		
		
		AVAudioPlayer *soundEffectsPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:
											 [NSURL fileURLWithPath:resourcePath] error:&err];
		
		if( err ){
			//bail!
			NSLog(@"Failed with reason: %@", [err localizedDescription]);
		}
		else{
			//set our delegate and begin playback
			soundEffectsPlayer.delegate = self;
			soundEffectsPlayer.numberOfLoops = repeatCount;
			[soundEffectsPlayer prepareToPlay];
			[soundEffectsPlayer play];
		}
	}
	@catch (NSException * e) {
	}
	@finally {
		//[timer release];
	}
}
-(void)playMainAudioPlayer:(NSTimer *)timer
{
	NSString *soundFileName = [[timer userInfo] objectForKey:@"SoundName"];
	@try {
		NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
		resourcePath = [resourcePath stringByAppendingPathComponent:soundFileName];
		//NSLog(@"Path to play: %@", resourcePath);
		NSError* err;
		//Initialize our player pointing to the path to our resource
		if(player && [player isPlaying])
		{
			[player stop];
			[player release];
			player = nil;
		}
		
		player = [[AVAudioPlayer alloc] initWithContentsOfURL:
				  [NSURL fileURLWithPath:resourcePath] error:&err];
		
		if( err ){
			//bail!
			NSLog(@"Failed with reason: %@", [err localizedDescription]);
		}
		else{
			//set our delegate and begin playback
			player.delegate = self;
			player.numberOfLoops = 0;
			[player prepareToPlay];
			[player play];
		}
	}
	@catch (NSException * e) {
	}
	@finally {
		//[timer release];
	}
}
-(void)playDragPlayer:(AVAudioPlayer *)avPlayer{
	[avPlayer play];
}
-(void)playGraphicAudioPlayer:(NSTimer *)timer
{
	NSString *soundFileName = [[timer userInfo] objectForKey:@"SoundName"];
	@try {
		NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
		resourcePath = [resourcePath stringByAppendingPathComponent:soundFileName];
		//NSLog(@"Path to play: %@", resourcePath);
		NSError* err;
		//Initialize our player pointing to the path to our resource
		if(graphicPlayer && [graphicPlayer isPlaying])
		{
			[graphicPlayer stop];
			[graphicPlayer release];
			graphicPlayer = nil;
		}
		
		graphicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:
						 [NSURL fileURLWithPath:resourcePath] error:&err];
		
		if( err ){
			//bail!
			NSLog(@"Failed with reason: %@", [err localizedDescription]);
		}
		else{
			//set our delegate and begin playback
			graphicPlayer.delegate = self;
			graphicPlayer.numberOfLoops = 0;
			[graphicPlayer prepareToPlay];
			[graphicPlayer play];
		}
	}
	@catch (NSException * e) {
	}
	@finally {
		//[timer release];
	}
}
-(void)playSoundGraphic:(NSString *)soundFileName
{
	NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.0f target:self selector:@selector(playGraphicAudioPlayer:) 
								   userInfo:[NSDictionary dictionaryWithObjectsAndKeys:soundFileName,@"SoundName",nil]
									repeats:NO];
	[[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
-(void)playSound:(NSString *)soundFileName
{
	NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.0f target:self selector:@selector(playMainAudioPlayer:) 
								   userInfo:[NSDictionary dictionaryWithObjectsAndKeys:soundFileName,@"SoundName",nil]
									repeats:NO];
	[[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

-(void)playSoundEffect:(NSString *)soundFileName withRepeatCount:(int)repeatCount
{
	NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.0f target:self selector:@selector(playAudioPlayer:) 
													userInfo:[NSDictionary dictionaryWithObjectsAndKeys:soundFileName,@"SoundName",[NSString stringWithFormat:@"%d",repeatCount],@"RepeatCount",nil]
													 repeats:NO];
	
	[[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
-(AVAudioPlayer *)playSoundDragEffect:(NSString *)soundFileName withRepeatCount:(int)repeatCount
{
	AVAudioPlayer *soundEffectsPlayer = nil;
	@try {
		NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
		resourcePath = [resourcePath stringByAppendingPathComponent:soundFileName];
		//NSLog(@"Path to play: %@", resourcePath);
		NSError* err;
		
		
		soundEffectsPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:
							  [NSURL fileURLWithPath:resourcePath] error:&err];
		
		if( err ){
			//bail!
			NSLog(@"Failed with reason: %@", [err localizedDescription]);
		}
		else{
			//set our delegate and begin playback
			soundEffectsPlayer.delegate = self;
			soundEffectsPlayer.numberOfLoops = repeatCount;
			[self performSelectorInBackground:@selector(playDragPlayer:) withObject:soundEffectsPlayer];
		}
	}
	@catch (NSException * e) {
	}
	@finally {
		return soundEffectsPlayer;
	}
	
}
-(void)doVolumeFade:(AVAudioPlayer *)avPlayer
{  
	// Stop and get the sound ready for playing again
	[avPlayer stop];
	[avPlayer release];
	dragPlayer = nil;
	avPlayer = nil;
}
-(BOOL)isGraphicToBeShownOnLeftSide:(NSString *)fileName
{
	BOOL bShownLeftSide = FALSE;
	NSString *strLanguage = [self getLanguageName];
	if ([[fileName lowercaseString] isEqualToString:@"d"] ||
		[[fileName lowercaseString] isEqualToString:@"i"] ||
		[[fileName lowercaseString] isEqualToString:@"j"] ||
		[[fileName lowercaseString] isEqualToString:@"m"] ||
		[[fileName lowercaseString] isEqualToString:@"s"] ||
		[[fileName lowercaseString] isEqualToString:@"t"] ||
		[[fileName lowercaseString] isEqualToString:@"u"]) {
		
		if ([[strLanguage lowercaseString]isEqualToString:@"french"] &&
			[[fileName lowercaseString] isEqualToString:@"u"]) {
			bShownLeftSide = FALSE;
		}
		else {
			bShownLeftSide = TRUE;
		}
	}
	if ([[strLanguage lowercaseString]isEqualToString:@"spanish"] &&
		[[fileName lowercaseString] isEqualToString:@"o"]) {
		bShownLeftSide = TRUE;
	}
	
	return bShownLeftSide;
}
#pragma mark -
#pragma mark SET FRAMES OF IMAGES
-(void)setFrameOfBird
{
	CGRect frame = [[viewBird.layer presentationLayer] frame];
	viewBird.frame = frame;
	if (frame.origin.x>-viewBird.frame.size.width && frame.origin.x<(self.view.frame.size.width+ viewBird.frame.size.width)) {
		//NSLog(@"bird frame");
	}
	else {
		viewBird.hidden = TRUE;
		isAnimationOnScreen = FALSE;
		[timerBird invalidate];
		timerBird = nil;
	}
}
-(void)setFrameOfBeachball
{
	BOOL bUpdate = [viewBall update];
	if (!bUpdate) {
		if (timerBall) {
			viewBall.hidden = TRUE;
			isAnimationOnScreen = FALSE;
			[timerBall invalidate];
			timerBall = nil;
		}
	}
}
-(void)setFrameOfBunny
{
	CGRect frame = [[viewBunny.layer presentationLayer] frame];
	viewBunny.frame = frame;
	if (frame.origin.x>-viewBunny.frame.size.width && frame.origin.x<(self.view.frame.size.width+viewBunny.frame.size.width)) {
		//NSLog(@"bunny frame");
	}
	else {
		viewBunny.hidden = TRUE;
		isAnimationOnScreen = FALSE;
		[timerBunny invalidate];
		timerBunny = nil;
	}
}
-(void)setFrameOfPaperPlane
{
	CGRect frame = [[viewPaperPlane.layer presentationLayer] frame];
	viewPaperPlane.frame = frame;
	if (frame.origin.x>-viewPaperPlane.frame.size.width && frame.origin.x<(self.view.frame.size.width+viewPaperPlane.frame.size.width)) {
		//NSLog([NSString stringWithFormat:@"frame:%.2f,%.2f",viewPaperPlane.frame.origin.x, viewPaperPlane.frame.size.width]);
	}
	else {
		viewPaperPlane.hidden = TRUE;
		isAnimationOnScreen = FALSE;
		[timerPaperPlane invalidate];
		timerPaperPlane = nil;
	}
}
-(void)setFrameOfSpider
{
	CGRect frame = [[viewSpider.layer presentationLayer] frame];
	viewSpider.frame = frame;
	if (frame.origin.x>-viewSpider.frame.size.width && frame.origin.x<(self.view.frame.size.width+viewSpider.frame.size.width)) {
		//NSLog(@"spider frame");
	}
	else {
		viewSpider.hidden = TRUE;
		isAnimationOnScreen = FALSE;
		[timerSpider invalidate];
		timerSpider = nil;
	}
}

#pragma mark -
#pragma mark MOVE IMAGES

-(void)moveSpider
{
	if (bViewAppeared) {
		if (!isAnimationOnScreen) {
			viewSpider.hidden = FALSE;
			isAnimationOnScreen = TRUE;
			if (viewSpider.tag==0) {
				[self playSoundEffect:@"SpiderWalksNormal.mp3" withRepeatCount:0];
			}
			else {
				[self playSoundEffect:@"SpiderWalksFast.mp3" withRepeatCount:0];
			}
			
			if (timerSpider) {
				[timerSpider invalidate];
				timerSpider = nil;
			}
			
			timerSpider = [NSTimer scheduledTimerWithTimeInterval:spiderMoveDuration/DIVIDE_FRAME_TIMER target:self selector:@selector(setFrameOfSpider) userInfo:nil repeats:YES];
			[[NSRunLoop mainRunLoop] addTimer:timerSpider forMode:NSRunLoopCommonModes];
			
			[CATransaction begin];
			[CATransaction setValue:[NSNumber numberWithFloat:spiderMoveDuration] forKey:kCATransactionAnimationDuration];
			
			CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
			positionAnimation.delegate = self;
			CGMutablePathRef positionPath = CGPathCreateMutable();
			CGPathMoveToPoint(positionPath, NULL,  spiderStartXPosition,  viewSpider.center.y );
			CGPathAddLineToPoint(positionPath, NULL, spiderEndXPosition , viewSpider.center.y );
			positionAnimation.path = positionPath;
			positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
			positionAnimation.fillMode = kCAFillModeForwards;
			positionAnimation.removedOnCompletion = NO;
			[[viewSpider layer] addAnimation:positionAnimation forKey:@"moveSpiderAnimation"];
			
			[CATransaction commit];
			CGPathRelease(positionPath);
			
			if (viewSpider.tag==0) {
				spiderStartXPosition = self.view.frame.size.width;
				spiderEndXPosition = -self.view.frame.size.width;
			}
			else {
				spiderStartXPosition = 0;
				spiderEndXPosition = self.view.frame.size.width+viewSpider.frame.size.width;
			}
		}
		
		float randomAnimation = spiderMoveDuration + MAX_TIME_REST + (arc4random() % RANDOM_MAX_DURATION);
		timerMoveSpider = [NSTimer scheduledTimerWithTimeInterval:randomAnimation target:self selector:@selector(moveSpider) userInfo:nil repeats:NO];
		[[NSRunLoop mainRunLoop] addTimer:timerMoveSpider forMode:NSRunLoopCommonModes];
	}
}

-(void)moveBird
{
	if (bViewAppeared) {
		if (!isAnimationOnScreen) {
			viewBird.hidden = FALSE;
			isAnimationOnScreen = TRUE;
			if (viewBird.tag==1) {
				[self playSoundEffect:@"BirdFlyingNormal.mp3" withRepeatCount:0];
			}
			else {
				[self playSoundEffect:@"BirdFlyingFast.mp3" withRepeatCount:0];
			}
			
			if (timerBird) {
				[timerBird invalidate];
				timerBird = nil;
			}
			timerBird = [NSTimer scheduledTimerWithTimeInterval:birdMoveDuration/DIVIDE_FRAME_TIMER target:self selector:@selector(setFrameOfBird) userInfo:nil repeats:YES];
			[[NSRunLoop mainRunLoop] addTimer:timerBird forMode:NSRunLoopCommonModes];
			
			[CATransaction begin];
			[CATransaction setValue:[NSNumber numberWithFloat:birdMoveDuration] forKey:kCATransactionAnimationDuration];
			
			CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
			positionAnimation.delegate = self;
			CGMutablePathRef positionPath = CGPathCreateMutable();
			CGPathMoveToPoint(positionPath, NULL,  birdStartXPosition,  viewBird.center.y );
			CGPathAddLineToPoint(positionPath, NULL, birdEndXPosition , viewBird.center.y );
			positionAnimation.path = positionPath;
			positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
			positionAnimation.fillMode = kCAFillModeForwards;
			positionAnimation.removedOnCompletion = NO;
			[[viewBird layer] addAnimation:positionAnimation forKey:@"movePaperPlaneAnimation"];
			
			[CATransaction commit];
			CGPathRelease(positionPath);
			
			if (viewBird.tag==0) {
				birdStartXPosition = self.view.frame.size.width;
				birdEndXPosition = -self.view.frame.size.width;
			}
			else {
				birdStartXPosition = 0;
				birdEndXPosition = (self.view.frame.size.width+viewBird.frame.size.width+30);
			}
		}
		float randomAnimation = birdMoveDuration + MAX_TIME_REST + (arc4random() % RANDOM_MAX_DURATION);
		timerMoveBird = [NSTimer scheduledTimerWithTimeInterval:randomAnimation target:self selector:@selector(moveBird) userInfo:nil repeats:NO];
		[[NSRunLoop mainRunLoop] addTimer:timerMoveBird forMode:NSRunLoopCommonModes];
	}
	
}

-(void)movePaperPlane
{
	if (bViewAppeared) {
		if (!isAnimationOnScreen) {
			viewPaperPlane.hidden = FALSE;
			isAnimationOnScreen = TRUE;
			if (!isPaperPlaneClicked) {
				int randomYPosition = arc4random() % (int)(self.view.frame.size.height);
				CGPoint center = viewPaperPlane.center;
				center.y = randomYPosition;
				viewPaperPlane.center = center;
			}
			isPaperPlaneClicked = FALSE;
			
			if (viewPaperPlane.tag==1) {
				[self playSoundEffect:@"PaperPlaneFlyingNormal.mp3" withRepeatCount:0];
			}
			else {
				[self playSoundEffect:@"PaperPlaneFlyingFast.mp3" withRepeatCount:0];
			}
			
			if (timerPaperPlane) {
				[timerPaperPlane invalidate];
				timerPaperPlane = nil;
			}
			timerPaperPlane = [NSTimer scheduledTimerWithTimeInterval:paperPlaneMoveDuration/DIVIDE_FRAME_TIMER target:self selector:@selector(setFrameOfPaperPlane) userInfo:nil repeats:YES];
			[[NSRunLoop mainRunLoop] addTimer:timerPaperPlane forMode:NSRunLoopCommonModes];
			
			[CATransaction begin];
			[CATransaction setValue:[NSNumber numberWithFloat:paperPlaneMoveDuration] forKey:kCATransactionAnimationDuration];
			
			CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
			positionAnimation.delegate = self;
			CGMutablePathRef positionPath = CGPathCreateMutable();
			CGPathMoveToPoint(positionPath, NULL,  paperPlaneStartXPosition,  viewPaperPlane.center.y );
			CGPathAddLineToPoint(positionPath, NULL, paperPlaneEndXPosition , viewPaperPlane.center.y );
			positionAnimation.path = positionPath;
			positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
			positionAnimation.fillMode = kCAFillModeForwards;
			positionAnimation.removedOnCompletion = NO;
			[[viewPaperPlane layer] addAnimation:positionAnimation forKey:@"movePaperPlaneAnimation"];
			
			[CATransaction commit];
			CGPathRelease(positionPath);
			if (viewPaperPlane.tag==0) {
				paperPlaneStartXPosition = self.view.frame.size.width;
				paperPlaneEndXPosition = -self.view.frame.size.width;
			}
			else {
				paperPlaneStartXPosition = 0;
				paperPlaneEndXPosition = (self.view.frame.size.width+viewPaperPlane.frame.size.width+30);
			}
		}
		
		float randomAnimation = paperPlaneMoveDuration + MAX_TIME_REST + (arc4random() % RANDOM_MAX_DURATION);
		timerMovePaperPlane = [NSTimer scheduledTimerWithTimeInterval:randomAnimation target:self selector:@selector(movePaperPlane) userInfo:nil repeats:NO];
		[[NSRunLoop mainRunLoop] addTimer:timerMovePaperPlane forMode:NSRunLoopCommonModes];
	}
	
}
-(void)moveBunny
{
	if (bViewAppeared) {
		if (!isAnimationOnScreen) {
			viewBunny.hidden = FALSE;
			isAnimationOnScreen = TRUE;
			if (viewBunny.tag==0) {
				[self playSoundEffect:@"RabbitJumpNormal.mp3" withRepeatCount:0];
			}
			else {
				[self playSoundEffect:@"RabbitJumpFast.mp3" withRepeatCount:0];
			}
			
			CGRect frame = viewBunny.frame;
			frame.origin.y = self.view.frame.size.height - viewBunny.frame.size.height;
			viewBunny.frame = frame;
			if (timerBunny) {
				[timerBunny invalidate];
				timerBunny = nil;
			}
			timerBunny = [NSTimer scheduledTimerWithTimeInterval:bunnyMoveDuration/DIVIDE_FRAME_TIMER target:self selector:@selector(setFrameOfBunny) userInfo:nil repeats:YES];
			[[NSRunLoop mainRunLoop] addTimer:timerBunny forMode:NSRunLoopCommonModes];
			
			float value = 100.0f;
			if (viewBunny.tag==0) {
				value= -100.0f;
			}
			
			CGMutablePathRef thePath = CGPathCreateMutable();
			CGPathMoveToPoint(thePath, NULL, bunnyStartXPosition, viewBunny.center.y);
			for (int i=0; i<4; i++) {
				CGPoint point1 = CGPointMake(bunnyStartXPosition+(value*i), viewBunny.center.y);
				CGPoint point2 = CGPointMake(bunnyStartXPosition+(value*(i+1)), viewBunny.center.y);
				CGPathAddCurveToPoint(thePath,
									  NULL,
									  point1.x,point1.y-70.0f,
									  point2.x,point1.y-70.0f,
									  point2.x,point1.y);
			}
			
			[CATransaction begin];
			[CATransaction setValue:[NSNumber numberWithFloat:bunnyMoveDuration] forKey:kCATransactionAnimationDuration];
			
			CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
			positionAnimation.delegate = self;
			positionAnimation.path = thePath;
			positionAnimation.calculationMode = kCAAnimationPaced;
			positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
			positionAnimation.fillMode = kCAFillModeForwards;
			positionAnimation.removedOnCompletion = NO;
			[[viewBunny layer] addAnimation:positionAnimation forKey:@"moveBunnyAnimation"];
			
			[CATransaction commit];
			
			CGPathRelease(thePath);
			
			if (viewBunny.tag==0) {
				bunnyStartXPosition = self.view.frame.size.width;
				bunnyEndXPosition = -self.view.frame.size.width;
			}
			else {
				bunnyStartXPosition = 0;
				bunnyEndXPosition = self.view.frame.size.width+viewBunny.frame.size.width;
			}
		}
		float randomAnimation = bunnyMoveDuration + MAX_TIME_REST + (arc4random() % RANDOM_MAX_DURATION);
		timerMoveBunny = [NSTimer scheduledTimerWithTimeInterval:randomAnimation target:self selector:@selector(moveBunny) userInfo:nil repeats:NO];
		[[NSRunLoop mainRunLoop] addTimer:timerMoveBunny forMode:NSRunLoopCommonModes];
	}
	
}
-(void)moveBeachBall
{
	if (bViewAppeared) {
		if (!isAnimationOnScreen) {
			viewBall.hidden = FALSE;
			isAnimationOnScreen = TRUE;
			viewBall.position = CGPointMake(ballStartXPosition, 140.0f);
			viewBall.velocity = velocity;
			viewBall.radius = RADIUS_BALL;
			viewBall.minY = MIN_Y_BALL;
			viewBall.maxY = MAX_Y_BALL;
			
			if (viewBall.tag==0) {
				[self playSoundEffect:@"BallBounceNormal.mp3" withRepeatCount:1];
			}
			else {
				[self playSoundEffect:@"BallBounceFast.mp3" withRepeatCount:0];
			}
			
			if (timerBall) {
				[timerBall invalidate];
				timerBall = nil;
			}
			
			timerBall = [NSTimer scheduledTimerWithTimeInterval:BALL_MOVE_ANIMATION_DURATION/DIVIDE_FRAME_TIMER target:self selector:@selector(setFrameOfBeachball) userInfo:nil repeats:YES];
			[[NSRunLoop mainRunLoop] addTimer:timerBall forMode:NSRunLoopCommonModes];
			
			if (viewBall.tag==0) {
				ballStartXPosition = self.view.frame.size.width;
				ballEndXPosition = -viewBall.frame.size.width;
			}
			else {
				ballStartXPosition = 0;
				ballEndXPosition = self.view.frame.size.width+viewBall.frame.size.width;
			}
		}
		float randomAnimation = BALL_MOVE_ANIMATION_DURATION + MAX_TIME_REST + (arc4random() % RANDOM_MAX_DURATION);
		timerMoveBall = [NSTimer scheduledTimerWithTimeInterval:randomAnimation target:self selector:@selector(moveBeachBall) userInfo:nil repeats:NO];
		[[NSRunLoop mainRunLoop] addTimer:timerMoveBall forMode:NSRunLoopCommonModes];
	}
	
}

#pragma mark -
#pragma mark INITIALIZE ANIMATE IMAGES

-(void)initSpiderImage:(float)animationDuration
{
	if([viewSpider.animationImages count]==0){
		NSArray *arrSpiderImages = [[NSArray alloc]initWithObjects:
									[UIImage thumbnailImage:@"spider1.png"],
									[UIImage thumbnailImage:@"spider2.png"],nil];
		
		viewSpider.animationImages = [arrSpiderImages copy];
		[arrSpiderImages release];
	}
	viewSpider.animationDuration = animationDuration;
	viewSpider.animationRepeatCount = -1;
	[viewSpider startAnimating];
	
	[self moveSpider];
	
}
-(void)initBirdImage:(float)animationDuration
{
	if([viewBird.animationImages count]==0){
		NSArray *arrBirdImages = [[NSArray alloc]initWithObjects:
								  [UIImage thumbnailImage:@"bird1.png"],
								  [UIImage thumbnailImage:@"bird2.png"],nil];
		
		viewBird.animationImages = [arrBirdImages copy];
		[arrBirdImages release];
	}
	viewBird.animationDuration = animationDuration;
	viewBird.animationRepeatCount = -1;
	[viewBird startAnimating];
	
	[self moveBird];
	
}
#pragma mark -
#pragma mark AUDIO PLAYER FINISHED EVENT
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)avPlayer error:(NSError *)error
{
	avPlayer = nil;
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)avPlayer successfully:(BOOL)flag
{
	if (bSwiped) {
		if (avPlayer==player) {
			Objects *object = [arrObjects objectAtIndex:currentPosition];
			NSString *strSoundName = [NSString stringWithFormat: [self getGraphicsSoundName],[object.SoundFileName lowercaseString]];
			[self playSoundGraphic:[NSString stringWithFormat:@"%@.mp3",strSoundName]];
			bSwiped=FALSE;
		}
	}
	if (avPlayer!=player &&
		avPlayer!=graphicPlayer) {
		[avPlayer release];
		avPlayer = nil;
	}
}
#pragma mark DRAG ACTIONS
- (IBAction)graphic:(UIButton *)btnGraphic didStartDrag:(UIEvent *)event
{
	
	UITouch *touch = [[event allTouches] anyObject];
	if (touch.phase == UITouchPhaseMoved) {
		if (btnGraphic==btnLeftGraphic && !isMoving) {
			dragPlayer = [self playSoundDragEffect:@"DragLetter.mp3" withRepeatCount:-1];
		}
		else if (btnGraphic==btnRightGraphic && !isMoving) {
			dragPlayer = [self playSoundDragEffect:@"DragLetter.mp3" withRepeatCount:-1];
		}
		else if (btnGraphic==btnCloud && !isMoving) {
			dragPlayer = [self playSoundDragEffect:@"DragCloud.mp3" withRepeatCount:-1];
		}
		isMoving = TRUE;
		
	}
	CGPoint touchLocation = [touch locationInView:self.view];
	if (btnGraphic==btnCloud) {
		CGPoint center = btnCloud.center;
		center.x = touchLocation.x;
		btnCloud.center = center;
		CGRect sunFrame= btnSun.frame;
		sunFrame.size.width = sunFrame.size.width+50;
		sunFrame.size.height = sunFrame.size.height+50;
		sunFrame.origin.x = sunFrame.origin.x-25;
		
		if (CGRectContainsPoint(sunFrame, touchLocation)) {
			darkLayerView.backgroundColor = [UIColor blackColor];
			darkLayerView.alpha = 0.4;
		}
		else {
			darkLayerView.backgroundColor = [UIColor clearColor];
		}
		
	}
	else if(btnGraphic==btnSun){
		CGPoint center = btnSun.center;
		center.x = touchLocation.x;
		btnSun.center = center;
		imgSunRays.center = center;
		if (CGRectContainsPoint(btnCloud.frame, touchLocation)) {
			darkLayerView.backgroundColor = [UIColor blackColor];
			darkLayerView.alpha = 0.4;
		}
		else {
			darkLayerView.backgroundColor = [UIColor clearColor];
		}
		
	}
	else {
		btnGraphic.center = touchLocation;
	}
	
	
	

}
- (IBAction)graphic:(UIButton *)btnGraphic didEndDrag:(UIEvent *)event
{
	
	if (isMoving) {
		isMoving = FALSE;
		[self doVolumeFade:dragPlayer];
		if (btnGraphic==btnLeftGraphic ||
			btnGraphic==btnRightGraphic) {
			Objects *object = [arrObjects objectAtIndex:currentPosition];
			object.strFrame = [NSString stringWithFormat:@"{{%f,%f},{%f,%f}}",
							   btnGraphic.frame.origin.x, btnGraphic.frame.origin.y,btnGraphic.frame.size.width, btnGraphic.frame.size.height];			
		}
	}
	else {
		if (btnGraphic == btnCloud) {
			[self cloudClicked:btnCloud];
		}
		else {
			if (btnGraphic!=btnSun) {
				[self graphicClicked:btnGraphic];
			}
			
		}
	}
}
#pragma mark -
#pragma mark ANIMATE OBJECT VIEW DELEGATE EVENT
- (void)didClickFirstTime:(id)animView
{
	
	if(animView==viewSpider)
	{
		if (timerSpider) {
			isAnimationOnScreen = FALSE;
			[timerSpider invalidate];
			timerSpider = nil;
		}
		if (timerMoveSpider) {
			[timerMoveSpider invalidate];
			timerMoveSpider = nil;
		}
		[[viewSpider layer] removeAnimationForKey:@"moveSpiderAnimation"];
		if (spiderMoveDuration>=1.0f) {
			spiderMoveDuration = SPIDER_MOVE_ANIMATION_DURATION/2.0f;
		}
		spiderStartXPosition = viewSpider.center.x;
		if (viewSpider.tag==1) {
			spiderEndXPosition = (self.view.frame.size.width +viewSpider.center.x+ viewSpider.frame.size.width);
		}
		else {
			spiderEndXPosition =  -(self.view.frame.size.width + viewSpider.center.x+ viewSpider.frame.size.width);
		}
		[self moveSpider];
	}
	else if(animView==viewBall)
	{
		if (timerBall) {
			isAnimationOnScreen = FALSE;
			[timerBall invalidate];
			timerBall = nil;
		}
		if (timerMoveBall) {
			[timerMoveBall invalidate];
			timerMoveBall = nil;
		}
		velocity = viewBall.velocity;
		if (viewBall.tag==1) {
			velocity.y-=0.5f;
		}
		else {
			velocity.y+=0.5f;
		}
		
		ballStartXPosition = viewBall.center.x;
		if (viewBall.tag==1) {
			ballEndXPosition = (self.view.frame.size.width + viewBall.frame.size.width);
		}
		else {
			ballEndXPosition =  -(0 + viewBall.frame.size.width);
		}
		
		[self moveBeachBall];
	}
	else if(animView==viewBunny)
	{
		if (timerBunny) {
			isAnimationOnScreen = FALSE;
			[timerBunny invalidate];
			timerBunny = nil;
		}
		if (timerMoveBunny) {
			[timerMoveBunny invalidate];
			timerMoveBunny = nil;
		}
		[[viewBunny layer] removeAnimationForKey:@"moveBunnyAnimation"];
		if (bunnyMoveDuration>=1.0f) {
			bunnyMoveDuration = BUNNY_MOVE_ANIMATION_DURATION/2.0f;
		}
		bunnyStartXPosition = viewBunny.center.x;
		if (viewBunny.tag==1) {
			bunnyEndXPosition = (self.view.frame.size.width + viewBunny.center.x + viewBunny.frame.size.width);
		}
		else {
			bunnyEndXPosition =  -(self.view.frame.size.width + viewBunny.center.x + viewBunny.frame.size.width);
		}
		[self moveBunny];
	}
	else if(animView==viewPaperPlane)
	{
		isPaperPlaneClicked = TRUE;
		if (timerPaperPlane) {
			isAnimationOnScreen = FALSE;
			[timerPaperPlane invalidate];
			timerPaperPlane = nil;
		}
		if (timerMovePaperPlane) {
			[timerMovePaperPlane invalidate];
			timerMovePaperPlane = nil;
		}
		[[viewPaperPlane layer] removeAnimationForKey:@"movePaperPlaneAnimation"];
		if (paperPlaneMoveDuration>=1.0f) {
			paperPlaneMoveDuration = PAPER_PLANE_MOVE_ANIMATION_DURATION/2.0f;
		}
		paperPlaneStartXPosition = viewPaperPlane.center.x;
		if (viewPaperPlane.tag==1) {
			paperPlaneEndXPosition = (self.view.frame.size.width + viewPaperPlane.center.x + viewPaperPlane.frame.size.width);
		}
		else {
			paperPlaneEndXPosition =  -(self.view.frame.size.width + viewPaperPlane.center.x + viewPaperPlane.frame.size.width);
		}
		[self movePaperPlane];
	}
	else if(animView==viewBird)
	{
		if (timerBird) {
			isAnimationOnScreen = FALSE;
			[timerBird invalidate];
			timerBird = nil;
		}
		if (timerMoveBird) {
			[timerMoveBird invalidate];
			timerMoveBird = nil;
		}
		[[viewBird layer] removeAnimationForKey:@"moveBirdAnimation"];
		if (birdMoveDuration>=1.0f) {
			birdMoveDuration = BIRD_MOVE_ANIMATION_DURATION/2.0f;
		}
		birdStartXPosition = viewBird.center.x;
		if (viewBird.tag==1) {
			birdEndXPosition = (self.view.frame.size.width + viewBird.center.x + viewBird.frame.size.width);
		}
		else {
			birdEndXPosition =  -(self.view.frame.size.width + viewBird.center.x + viewBird.frame.size.width);
		}
		[self moveBird];
	}
}
- (void)didClickSecondTime:(id)animView
{
	if(animView==viewSpider)
	{
		if (timerSpider) {
			isAnimationOnScreen = FALSE;
			[timerSpider invalidate];
			timerSpider = nil;
		}
		if (timerMoveSpider) {
			[timerMoveSpider invalidate];
			timerMoveSpider = nil;
		}
		[[viewSpider layer] removeAnimationForKey:@"moveSpiderAnimation"];
		spiderStartXPosition = viewSpider.center.x;
		spiderMoveDuration = SPIDER_MOVE_ANIMATION_DURATION;
		if (viewSpider.tag==1) {
			viewSpider.tag =0;
			viewSpider.transform = CGAffineTransformMake(1, 0.0, 0.0, 1.0, viewSpider.frame.size.width , 0.0);
			spiderEndXPosition = -viewSpider.center.x;
		}
		else {
			viewSpider.tag = 1;
			viewSpider.transform = CGAffineTransformMake(-1, 0.0, 0.0, 1.0, viewSpider.frame.size.width , 0.0);
			spiderEndXPosition = (self.view.frame.size.width + viewSpider.frame.size.width);
		}
		
		[self moveSpider];
	}
	else if(animView==viewBall)
	{
		if (timerBall) {
			isAnimationOnScreen = FALSE;
			[timerBall invalidate];
			timerBall = nil;
		}
		if (timerMoveBall) {
			[timerMoveBall invalidate];
			timerMoveBall = nil;
		}
		ballStartXPosition = viewBall.center.x;
		if (viewBall.tag==1) {
			viewBall.tag =0;
			velocity = CGPointMake(-VELOCITY_BALL_X, -VELOCITY_BALL_Y);
			ballEndXPosition = -viewBall.center.x;
		}
		else {
			viewBall.tag = 1;
			velocity = CGPointMake(VELOCITY_BALL_X, VELOCITY_BALL_Y);
			ballEndXPosition = (self.view.frame.size.width + viewBall.frame.size.width);
		}
		
		[self moveBeachBall];
	}
	else if(animView==viewBunny)
	{
		if (timerBunny) {
			isAnimationOnScreen = FALSE;
			[timerBunny invalidate];
			timerBunny = nil;
		}
		if (timerMoveBunny) {
			[timerMoveBunny invalidate];
			timerMoveBunny = nil;
		}
		[[viewBunny layer] removeAnimationForKey:@"moveBunnyAnimation"];
		bunnyStartXPosition = viewBunny.center.x;
		bunnyMoveDuration = BUNNY_MOVE_ANIMATION_DURATION;
		if (viewBunny.tag==1) {
			viewBunny.tag =0;
			viewBunny.transform = CGAffineTransformMake(1, 0.0, 0.0, 1.0, viewBunny.frame.size.width , 0.0);
			bunnyEndXPosition = -viewBunny.center.x;
		}
		else {
			viewBunny.tag = 1;
			viewBunny.transform = CGAffineTransformMake(-1, 0.0, 0.0, 1.0, viewBunny.frame.size.width , 0.0);
			bunnyEndXPosition = (self.view.frame.size.width + viewBunny.frame.size.width);
		}
		
		[self moveBunny];
	}
	
	else if(animView==viewPaperPlane)
	{
		isPaperPlaneClicked = TRUE;
		if (timerPaperPlane) {
			isAnimationOnScreen = FALSE;
			[timerPaperPlane invalidate];
			timerPaperPlane = nil;
		}
		if (timerMovePaperPlane) {
			[timerMovePaperPlane invalidate];
			timerMovePaperPlane = nil;
		}
		[[viewPaperPlane layer] removeAnimationForKey:@"movePaperPlaneAnimation"];
		paperPlaneStartXPosition = viewPaperPlane.center.x;
		paperPlaneMoveDuration = PAPER_PLANE_MOVE_ANIMATION_DURATION;
		if (viewPaperPlane.tag==1) {
			viewPaperPlane.tag =0;
			viewPaperPlane.transform = CGAffineTransformMake(-1, 0.0, 0.0, 1.0, viewPaperPlane.frame.size.width , 0.0);
			paperPlaneEndXPosition = -viewPaperPlane.center.x;
		}
		else {
			viewPaperPlane.tag = 1;
			viewPaperPlane.transform = CGAffineTransformMake(1, 0.0, 0.0, 1.0, viewPaperPlane.frame.size.width , 0.0);
			paperPlaneEndXPosition = (self.view.frame.size.width + viewPaperPlane.frame.size.width);
		}
		
		[self movePaperPlane];
	}
	else if(animView==viewBird)
	{
		if (timerBird) {
			isAnimationOnScreen = FALSE;
			[timerBird invalidate];
			timerBird = nil;
		}
		if (timerMoveBird) {
			[timerMoveBird invalidate];
			timerMoveBird = nil;
		}
		[[viewBird layer] removeAnimationForKey:@"moveBirdAnimation"];
		birdStartXPosition = viewBird.center.x;
		birdMoveDuration = BIRD_MOVE_ANIMATION_DURATION;
		if (viewBird.tag==1) {
			viewBird.tag =0;
			viewBird.transform = CGAffineTransformMake( -1, 0.0, 0.0, 1.0, viewBird.frame.size.width , 0.0);
			birdEndXPosition = -viewBird.center.x;
		}
		else {
			viewBird.tag = 1;
			viewBird.transform = CGAffineTransformMake(1, 0.0, 0.0, 1.0, viewBird.frame.size.width , 0.0);
			birdEndXPosition = (self.view.frame.size.width + viewBird.frame.size.width);
		}
		
		[self moveBird];
	}
}
#pragma mark -
#pragma mark ANIMATION STOPPED EVENT
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
	CAAnimation *cloudAnimation = [[btnCloud layer] animationForKey:@"shrinkAnimationClicked"];
	CAAnimation *spiderAnimation = [[viewSpider layer] animationForKey:@"moveSpiderAnimation"];
	CAAnimation *paperPlaneAnimation = [[viewSpider layer] animationForKey:@"movePaperPlaneAnimation"];
	CAAnimation *birdAnimation = [[viewSpider layer] animationForKey:@"moveBirdAnimation"];
	CAAnimation *bunnyAnimation = [[viewSpider layer] animationForKey:@"moveBunnyAnimation"];
	if (anim==cloudAnimation) {
		[[btnCloud layer] removeAnimationForKey:@"shrinkAnimationClicked"];
		//[self transformCloud];
		//timer = [NSTimer scheduledTimerWithTimeInterval:CLOUD_ANIMATION_DURATION target:self selector:@selector(transformCloud) userInfo:nil repeats:YES];
	}
	else if (anim == spiderAnimation) {
		if (timerSpider) {
			[timerSpider invalidate];
			timerSpider = nil;
		}
	}
	else if (anim == paperPlaneAnimation) {
		if (timerPaperPlane) {
			[timerPaperPlane invalidate];
			timerPaperPlane = nil;
		}
	}
	else if (anim == birdAnimation) {
		if (timerBird) {
			[timerBird invalidate];
			timerBird = nil;
		}
	}
	else if (anim == bunnyAnimation) {
		if (timerBunny) {
			[timerBunny invalidate];
			timerBunny = nil;
		}
	}
}
#pragma mark -
#pragma mark IB ACTIONS
-(void)touchAnywhereElseForCloud:(id)sender
{
	UIButton *btnBackground = sender;
	@try {
		
		NSString *strSoundFileName = [self getCloudSoundName];
		[self playSound:[NSString stringWithFormat:@"%@.mp3", strSoundFileName]];
		
		[CATransaction begin];
		[CATransaction setValue:[NSNumber numberWithFloat:CHAR_ANIMATION_DURATION] forKey:kCATransactionAnimationDuration];
		
		CABasicAnimation *shrinkAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
		shrinkAnimation.delegate = self;
		shrinkAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
		shrinkAnimation.fromValue = [NSNumber numberWithFloat:kCloudScaleFactor];
		shrinkAnimation.toValue = [NSNumber numberWithFloat:1.0];
		shrinkAnimation.fillMode = kCAFillModeForwards;
		shrinkAnimation.removedOnCompletion = NO;
		[[btnSelected layer] addAnimation:shrinkAnimation forKey:@"shrinkAnimation"];
		[CATransaction commit];
		
		[btnBackground removeFromSuperview];
		
	}
	@catch (NSException * e) {
	}
	@finally {
	}
}
-(IBAction)charClicked:(id)sender
{
	bSwiped = FALSE;
	btnSelected = sender;
	@try {
		[self playSoundEffect:@"TapFeatureGraphics.mp3" withRepeatCount:0];
		[self playSoundEffect:@"ExpansionFeatureGraphics.mp3" withRepeatCount:0];
		
		Objects *object = [arrObjects objectAtIndex:currentPosition];
		NSString *strSoundFileName = [NSString stringWithFormat:[self getCharSoundName],object.SoundFileName];
		[self playSound:[NSString stringWithFormat:@"%@.mp3", strSoundFileName]];
		
		[self scaleAnimation:btnSelected];
		
	}
	@catch (NSException * e) {
	}
	@finally {
	}
}

-(IBAction)graphicClicked:(id)sender
{
	[self playSoundEffect:@"TapFeatureGraphics.mp3" withRepeatCount:0];
	[self playSoundEffect:@"ExpansionFeatureGraphics.mp3" withRepeatCount:0];
	bSwiped = FALSE;
	btnSelected = sender;
	@try {
		
		Objects *object = [arrObjects objectAtIndex:currentPosition];
		NSString *strSoundName = [NSString stringWithFormat: [self getGraphicsSoundName],[object.SoundFileName lowercaseString]];
		[self playSoundGraphic:[NSString stringWithFormat:@"%@.mp3",strSoundName]];
		
		[CATransaction begin];
		[CATransaction setValue:[NSNumber numberWithFloat:CHAR_ANIMATION_DURATION] forKey:kCATransactionAnimationDuration];
		
		CABasicAnimation *shrinkAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
		shrinkAnimation.delegate = self;
		shrinkAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
		shrinkAnimation.fromValue = [NSNumber numberWithFloat:1.0];
		shrinkAnimation.toValue = [NSNumber numberWithFloat:kGraphicScaleFactor];
		shrinkAnimation.autoreverses = TRUE;
		shrinkAnimation.fillMode = kCAFillModeForwards;
		shrinkAnimation.removedOnCompletion = YES;
		[[btnSelected layer] addAnimation:shrinkAnimation forKey:@"shrinkAnimation"];
		[CATransaction commit];
	}
	@catch (NSException * e) {
	}
	@finally {
	}
}
-(IBAction)alphabetClicked:(id)sender
{
	bSwiped = FALSE;
	btnSelected = sender;
	NSString *strSoundName = [self getAlphabetTitleSoundName];
	[self playSound:[NSString stringWithFormat:@"%@.mp3",strSoundName]];
}
-(IBAction)back:(id)sender
{
	[UIImage clearThumbnailCache];
	[self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)sunClicked:(id)sender
{
	[self playSoundEffect:@"TapSun.mp3" withRepeatCount:0];
	[self playSoundEffect:@"SpinSun.mp3" withRepeatCount:0];
	@try {
		if (timerRotateSun) {
			[timerRotateSun invalidate];
			timerRotateSun = nil;
		}
		if (timerSunBackToNormal) {
			[timerSunBackToNormal invalidate];
			timerSunBackToNormal = nil;
		}
		[btnSun.layer removeAllAnimations];
		[imgSunRays.layer removeAllAnimations];
		sunRoateDuration = SUN_ANIMATION_DURATION - 20.0f;
		[self rotateSun];
		timerRotateSun = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(rotateSunNormally) userInfo:nil repeats:NO];
		[[NSRunLoop mainRunLoop]addTimer:timerRotateSun forMode:NSRunLoopCommonModes];
	}
	@catch (NSException * e) {
	}
	@finally {
	}
}
-(IBAction)cloudClicked:(id)sender
{
	btnSelected = sender;
	@try {
		[self playSoundEffect:@"TapCloud.mp3" withRepeatCount:0];
		bSwiped = FALSE;
		//NSString *strSoundName = NSLocalizedString(@"appCloudSoundName",nil);
		//[self playSound:[NSString stringWithFormat:@"%@.mp3",strSoundName]];
		
		[[btnCloud layer]removeAllAnimations];
		
		[CATransaction begin];
		[CATransaction setValue:[NSNumber numberWithFloat:GRAPHIC_ANIMATION_DURATION] forKey:kCATransactionAnimationDuration];
		
		CABasicAnimation *shrinkAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
		shrinkAnimation.delegate = self;
		shrinkAnimation.autoreverses = TRUE;
		shrinkAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
		shrinkAnimation.fromValue = [NSNumber numberWithFloat:1.0];
		shrinkAnimation.toValue = [NSNumber numberWithFloat:kCloudScaleFactor];
		shrinkAnimation.fillMode = kCAFillModeForwards;
		shrinkAnimation.removedOnCompletion = NO;
		[[btnSelected layer] addAnimation:shrinkAnimation forKey:@"shrinkAnimationClicked"];
		[CATransaction commit];
	}
	@catch (NSException * e) {
	}
	@finally {
	}
	
}
#pragma mark -
#pragma mark ROTATE SUN
-(void)rotateSunBackToNormal
{
	@try {
		if (timerSunBackToNormal) {
			[timerSunBackToNormal invalidate];
			timerSunBackToNormal = nil;
		}
		[btnSun.layer removeAllAnimations];
		[imgSunRays.layer removeAllAnimations];
		sunRoateDuration = SUN_ANIMATION_DURATION;
		[self rotateSun];
	}
	@catch (NSException * e) {
	}
	@finally {
	}
}
-(void)rotateSunNormally
{
	@try {
		if (timerRotateSun) {
			[timerRotateSun invalidate];
			timerRotateSun = nil;
		}
		[btnSun.layer removeAllAnimations];
		[imgSunRays.layer removeAllAnimations];
		sunRoateDuration = SUN_ANIMATION_DURATION - 5.0f;
		[self rotateSun];
		timerSunBackToNormal = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(rotateSunBackToNormal) userInfo:nil repeats:NO];
		[[NSRunLoop mainRunLoop]addTimer:timerSunBackToNormal forMode:NSRunLoopCommonModes];
	}
	@catch (NSException * e) {
	}
	@finally {
	}
}
-(void)rotateSun
{
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:sunRoateDuration] forKey:kCATransactionAnimationDuration];
	
	CABasicAnimation* spinAnimation = [CABasicAnimation
									   animationWithKeyPath:@"transform.rotation"];
	CGAffineTransform transform = [[btnSun.layer presentationLayer] affineTransform];
	float fromAngle = atan2(transform.b, transform.a);
	float toAngle = fromAngle + 4*M_PI;
	spinAnimation.fromValue = [NSNumber numberWithFloat:fromAngle];
	spinAnimation.toValue = [NSNumber numberWithFloat:toAngle];
	spinAnimation.repeatCount = 1.24e24f;
	spinAnimation.removedOnCompletion = YES;
	[btnSun.layer addAnimation:spinAnimation forKey:@"spinAnimation"];
	[imgSunRays.layer addAnimation:spinAnimation forKey:@"spinAnimation"];
	[CATransaction commit];
}

#pragma mark -
#pragma mark SCALE ANIMATION
-(void)scaleAnimation:(UIButton *)button
{
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:CHAR_ANIMATION_DURATION] forKey:kCATransactionAnimationDuration];
	
	CABasicAnimation *shrinkAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	shrinkAnimation.delegate = self;
	shrinkAnimation.autoreverses = TRUE;
	shrinkAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	shrinkAnimation.fromValue = [NSNumber numberWithFloat:1.0];
	shrinkAnimation.toValue = [NSNumber numberWithFloat:kLetterScaleFactor];
	shrinkAnimation.fillMode = kCAFillModeForwards;
	shrinkAnimation.removedOnCompletion = NO;
	[[button layer] addAnimation:shrinkAnimation forKey:@"shrinkAnimation"];
	[CATransaction commit];
}
#pragma mark -
#pragma mark FADE ANIMATION

-(void)fadeOut:(UIButton *)btnGraphic
{
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:GRAPHIC_ANIMATION_DURATION] forKey:kCATransactionAnimationDuration];
	
	CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	//fadeAnimation.delegate = self;
	//fadeAnimation.autoreverses = TRUE;
	fadeAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
	fadeAnimation.toValue = [NSNumber numberWithFloat:0.0f];
	fadeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	fadeAnimation.fillMode = kCAFillModeForwards;
	fadeAnimation.removedOnCompletion = NO;
	[[btnGraphic layer] addAnimation:fadeAnimation forKey:@"fadeOutAnimation"];
	[CATransaction commit];
	//[btnGraphic setImage:[UIImage thumbnailImage:[NSString stringWithFormat:@"%@.png",ImageName]] forState:UIControlStateNormal];
}
-(void)fadeIn:(NSString *)ImageName withButton:(UIButton *)btnGraphic
{
	btnGraphic.hidden = FALSE;
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:GRAPHIC_ANIMATION_DURATION] forKey:kCATransactionAnimationDuration];
	
	CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	fadeAnimation.delegate = self;
	fadeAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
	fadeAnimation.toValue = [NSNumber numberWithFloat:1.0f];
	fadeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	fadeAnimation.fillMode = kCAFillModeForwards;
	fadeAnimation.removedOnCompletion = NO;
	[[btnGraphic layer] addAnimation:fadeAnimation forKey:@"fadeAnimation"];
	[CATransaction commit];
	[appDelegate setImage:[UIImage thumbnailImage:[NSString stringWithFormat:@"%@.png",ImageName]] ofButton:btnGraphic];
	//[btnGraphic setImage:[UIImage thumbnailImage:[NSString stringWithFormat:@"%@.png",ImageName]] forState:UIControlStateNormal];
}
#pragma mark -
#pragma mark SWIPE VIEW DATASOURCE METHODS
- (int)noOfPagesToSwipe
{
	return 2000;
}
#pragma mark -
#pragma mark SWIPE VIEW DELEGATE METHODS
- (void)willSwipeLeft:(int)currentPage
{
	[self playSoundEffect:@"NavigateLeft.mp3" withRepeatCount:0];
	if(!bOldVersion) {
		if (!btnRightGraphic.hidden) {
			[self fadeOut:btnRightGraphic];
		}
		else {
			[self fadeOut:btnLeftGraphic];
		}
	}
}
- (void)willSwipeRight:(int)currentPage
{
	[self playSoundEffect:@"NavigateRight.mp3" withRepeatCount:0];
	if(!bOldVersion){
		if (!btnRightGraphic.hidden) {
			[self fadeOut:btnRightGraphic];
		}
		else {
			[self fadeOut:btnLeftGraphic];
		}
	}
	
	
	
}
- (void)didSwipe:(int)currentPage
{
	bSwiped = TRUE;
	int page= currentPage;
	currentPage = currentPage%[arrObjects count];
	currentPosition = currentPage;
	
	NSString *strLanguage = [self getLanguageName];
	
	Objects *object = [arrObjects objectAtIndex:currentPage];
	NSString *strCharImageName = [NSString stringWithFormat:[self getCharImageName],[object.SoundFileName lowercaseString]];
	
	CGRect frame = btnCharCenter.frame;
	frame.origin.x = 50 + (swipeView.frame.size.width * page);
	frame.origin.y = (swipeView.frame.size.height - btnCharCenter.frame.size.height)/2 - 9;
	
	
	if (![dicLetters objectForKey:[NSString stringWithFormat:@"%d",currentPage-1]]) {
		[dicLetters removeObjectForKey:[NSString stringWithFormat:@"%d",currentPage-1]];
	}
	
	if (![dicLetters objectForKey:[NSString stringWithFormat:@"%d",currentPage+1]]) {
		[dicLetters removeObjectForKey:[NSString stringWithFormat:@"%d",currentPage+1]];
	}
	
	if (![dicLetters objectForKey:[NSString stringWithFormat:@"%d",currentPage]]) {
		UIButton *btnChar = [UIButton buttonWithType:UIButtonTypeCustom];
		[btnChar addTarget:self action:@selector(charClicked:) forControlEvents:UIControlEventTouchUpInside];
		btnChar.frame = frame;
		[swipeView addSubview:btnChar];
		[dicLetters setObject:btnChar forKey:[NSString stringWithFormat:@"%d",currentPage]];
		btnCharCenter = btnChar;
	}
	else {
		UIButton *btnChar = [dicLetters objectForKey:[NSString stringWithFormat:@"%d",currentPage]];
		btnChar.frame = frame;
		btnCharCenter = btnChar;
	}
	
	[appDelegate setImage:[UIImage thumbnailImage:[NSString stringWithFormat:@"%@.png",strCharImageName]] ofButton:btnCharCenter];
	NSString *strImageName = [NSString stringWithFormat:[self getGraphicsImageName], object.SoundFileName];
	
	if ([[strLanguage lowercaseString] isEqualToString:@"french"] &&
		([[object.SoundFileName lowercaseString] isEqualToString:@"b"] ||
		 [[object.SoundFileName lowercaseString] isEqualToString:@"h"] ||
		 [[object.SoundFileName lowercaseString] isEqualToString:@"q"] ||
		 [[object.SoundFileName lowercaseString] isEqualToString:@"u"])) {
			strImageName = [NSString stringWithFormat:@"%@_%@",strImageName,[strLanguage lowercaseString]];
		}
	
	if ([[strLanguage lowercaseString] isEqualToString:@"spanish"] &&
		([[object.SoundFileName lowercaseString] isEqualToString:@"b"] ||
		 [[object.SoundFileName lowercaseString] isEqualToString:@"h"] ||
		 [[object.SoundFileName lowercaseString] isEqualToString:@"nn"] ||
		 [[object.SoundFileName lowercaseString] isEqualToString:@"s"] ||
		 [[object.SoundFileName lowercaseString] isEqualToString:@"z"] ||
		 [[object.SoundFileName lowercaseString] isEqualToString:@"o"])) {
			strImageName = [NSString stringWithFormat:@"%@_%@",strImageName,[strLanguage lowercaseString]];
		}
	BOOL bLeft =[self isGraphicToBeShownOnLeftSide:object.SoundFileName];
	if (bLeft) {
		btnLeftGraphic.hidden = FALSE;
		btnRightGraphic.hidden = TRUE;
		if ([object.strFrame length]>0) {
			CGRect frame = CGRectFromString(object.strFrame);
			btnLeftGraphic.frame = frame;
		}
		else {
			btnLeftGraphic.frame= defaultLeftGrahicFrame;
		}
		
		[self fadeIn:strImageName withButton:btnLeftGraphic];
	}
	else {
		btnLeftGraphic.hidden = TRUE;
		btnRightGraphic.hidden = FALSE;
		if ([object.strFrame length]>0) {
			CGRect frame = CGRectFromString(object.strFrame);
			btnRightGraphic.frame = frame;
		}
		else {
			btnRightGraphic.frame= defaultRightGrahicFrame;
		}
		[self fadeIn:strImageName withButton:btnRightGraphic];
	}
	[self playSound:[NSString stringWithFormat:@"%@.mp3",[NSString stringWithFormat:[self getCharSoundName], [object.SoundFileName lowercaseString]]]];
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
#pragma mark -
#pragma mark GET IMAGES AS PER LANGUAGE
-(NSString *)getAlphabetTitleImageName
{
	NSString *alphabetImageName = NSLocalizedString(@"appAlphabetTitleImage",nil);
	@try {
		int value = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] intValue];
		switch (value) {
			case 0:
				alphabetImageName = NSLocalizedString(@"appAlphabetTitleImage",nil);
				break;
			case 1:
				alphabetImageName = @"alphabetstitle.png";
				break;
			case 2:
				alphabetImageName = @"alphabetstitle_spanish.png";
				break;
			case 3:
				alphabetImageName = @"alphabetstitle_french.png";
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
-(NSString *)getAlphabetTitleSoundName
{
	NSString *alphabetImageName = NSLocalizedString(@"appAlphabetTitleSoundName",nil);
	@try {
		int value = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] intValue];
		switch (value) {
			case 0:
				alphabetImageName = NSLocalizedString(@"appAlphabetTitleSoundName",nil);
				break;
			case 1:
				alphabetImageName = @"sound_alphabet";
				break;
			case 2:
				alphabetImageName = @"sound_alphabet_spanish";
				break;
			case 3:
				alphabetImageName = @"sound_alphabet_french";
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
-(NSString *)getGraphicsImageName
{
	NSString *graphicsImageName = NSLocalizedString(@"appAlphabetGraphicTitle",nil);
	@try {
		int value = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] intValue];
		switch (value) {
			case 0:
				graphicsImageName = NSLocalizedString(@"appAlphabetGraphicTitle",nil);
				break;
			case 1:
				graphicsImageName = @"graphic_%@";
				break;
			case 2:
				graphicsImageName = @"graphic_%@";
				break;
			case 3:
				graphicsImageName = @"graphic_%@";
				break;
			default:
				break;
		}
	}
	@catch (NSException * e) {
	}
	@finally {
		return graphicsImageName;
	}
}
-(NSString *)getCharImageName
{
	NSString *charImageName = NSLocalizedString(@"appAlphabetLetterTitle",nil);
	@try {
		int value = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] intValue];
		switch (value) {
			case 0:
				charImageName = NSLocalizedString(@"appAlphabetLetterTitle",nil);
				break;
			case 1:
				charImageName = @"%@";
				break;
			case 2:
				charImageName = @"%@";
				break;
			case 3:
				charImageName = @"%@";
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
-(NSString *)getCloudSoundName
{
	NSString *soundName = NSLocalizedString(@"appCloudSoundName",nil);
	@try {
		int value = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] intValue];
		switch (value) {
			case 0:
				soundName = NSLocalizedString(@"appCloudSoundName",nil);
				break;
			case 1:
				soundName = @"sound_cloud";
				break;
			case 2:
				soundName = @"sound_cloud_spanish";
				break;
			case 3:
				soundName = @"sound_cloud_french";
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
-(NSString *)getCharSoundName
{
	NSString *soundName = NSLocalizedString(@"appAlphabetSoundName",nil);;
	@try {
		int value = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] intValue];
		switch (value) {
			case 0:
				soundName = NSLocalizedString(@"appAlphabetSoundName",nil);;
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
-(NSString *)getGraphicsSoundName
{
	NSString *soundName = NSLocalizedString(@"appAlphabetGraphicSoundName",nil);
	@try {
		int value = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] intValue];
		switch (value) {
			case 0:
				soundName = NSLocalizedString(@"appAlphabetGraphicSoundName",nil);
				break;
			case 1:
				soundName = @"sound_%@";
				break;
			case 2:
				soundName = @"sound_%@_spanish";
				break;
			case 3:
				soundName = @"sound_%@_french";
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
#pragma mark VIEW ACTIONS

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	darkLayerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	darkLayerView.userInteractionEnabled = FALSE;
	[self.view addSubview:darkLayerView];
	darkLayerView.backgroundColor = [UIColor clearColor];
	NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
	if([systemVersion isEqualToString:@"3.1.2"] ||
	   [systemVersion isEqualToString:@"3.1.3"] ){
		bOldVersion = TRUE;
	}
	else {
		bOldVersion = FALSE;
	}
	
	defaultLeftGrahicFrame = btnLeftGraphic.frame;
	defaultRightGrahicFrame = btnRightGraphic.frame;
	
	swipeView.pagingEnabled = YES;
    swipeView.contentSize = CGSizeMake(swipeView.frame.size.width * 20000, swipeView.frame.size.height);
    swipeView.showsHorizontalScrollIndicator = NO;
    swipeView.showsVerticalScrollIndicator = NO;
    swipeView.scrollsToTop = NO;
    swipeView.delegate = swipeView;
	
	btnRightGraphic.imageView.contentMode = UIViewContentModeScaleAspectFit;
	btnLeftGraphic.imageView.contentMode = UIViewContentModeScaleAspectFit;
	
	
	dicLetters = [[NSMutableDictionary alloc]init];
	
	spiderStartXPosition = self.view.frame.size.width;
	spiderEndXPosition = -self.view.frame.size.width;
	
	bunnyStartXPosition = self.view.frame.size.width;
	bunnyEndXPosition = -self.view.frame.size.width;
	
	ballStartXPosition = self.view.frame.size.width;
	ballEndXPosition = -self.view.frame.size.width;
	velocity = CGPointMake(-VELOCITY_BALL_X, -VELOCITY_BALL_Y);
	
	viewPaperPlane.tag = 1;
	paperPlaneStartXPosition = 0;
	paperPlaneEndXPosition = (self.view.frame.size.width+ viewPaperPlane.frame.size.width+30);
	
	viewBird.tag = 1;
	birdStartXPosition = 0;
	birdEndXPosition = (self.view.frame.size.width+ viewBird.frame.size.width+30);
	
	spiderMoveDuration = SPIDER_MOVE_ANIMATION_DURATION;
	birdMoveDuration = BIRD_MOVE_ANIMATION_DURATION;
	paperPlaneMoveDuration = PAPER_PLANE_MOVE_ANIMATION_DURATION;
	bunnyMoveDuration = BUNNY_MOVE_ANIMATION_DURATION;
	
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
	[appDelegate playSound:@"Alphabets.mp3"];
	appDelegate.bFirstTimeLoaded = FALSE;
	if (appDelegate.bChangedLanguage) {
		currentPosition = 0;
		btnCharCenter.tag = currentPosition;
		btnRightGraphic.tag = currentPosition;
		[self didSwipe:currentPosition];
		[self scaleAnimation:btnCharCenter];
		swipeView.contentOffset = CGPointMake(0, 0);
		appDelegate.bChangedLanguage = FALSE;
	}
	if ([dicLetters count]==0 && currentPosition==0) {
		[self didSwipe:currentPosition];
	}
	bViewAppeared = TRUE;
	UIImage *image = [UIImage thumbnailImage:[self getAlphabetTitleImageName]];
	[appDelegate setImage:image ofButton:btnAlphabetTitle];
	[appDelegate setImage:[UIImage thumbnailImage:@"sun.png"] ofButton:btnSun];
	[appDelegate setImage:[UIImage thumbnailImage:@"sky.png"] ofButton:btnCloud];
	
	
	viewBall.velocity = CGPointMake(-VELOCITY_BALL_X, -VELOCITY_BALL_Y);
	@try {
		sunRoateDuration = SUN_ANIMATION_DURATION;
		[self rotateSun];
	}
	@catch (NSException * e) {
	}
	@finally {
	}
	
	[self initSpiderImage:GIF_SPIDER_ANIMATION_DURATION];
	[self initBirdImage:GIF_BIRD_ANIMATION_DURATION];
	[self moveBunny];
	[self moveBeachBall];
	[self movePaperPlane];
	
	NSString *strLanguage = [self getLanguageName];
	if ([[strLanguage lowercaseString] isEqualToString:@"spanish"]) {
		if ([arrObjects count]==MAX_ALPHABET_COUNT) {
			Objects *object = [[Objects alloc]init];
			object.SoundFileName = @"nn";
			object.ImageName = @"name";
			object.EnglishTitle = @"Name";
			object.FrenchTitle = @"Name";
			object.SpanishTitle = @"Name";
			object.categoryID = 1;
			[arrObjects insertObject:object atIndex:14];
			[object release];
		}
	}
	else {
		if ([arrObjects count]>MAX_ALPHABET_COUNT) {
			@try {
				UIButton *btnChar = [dicLetters objectForKey:[NSString stringWithFormat:@"%d", MAX_ALPHABET_COUNT]];
				[btnChar removeFromSuperview];
				[dicLetters removeObjectForKey:[NSString stringWithFormat:@"%d", MAX_ALPHABET_COUNT]];
				[arrObjects removeObjectAtIndex:14];
				Objects *object = [arrObjects objectAtIndex:14];
				NSString *strCharImageName = [NSString stringWithFormat:[self getCharImageName],[object.SoundFileName lowercaseString]];
				btnChar = [dicLetters objectForKey:@"14"];
				[appDelegate setImage:[UIImage thumbnailImage:[NSString stringWithFormat:@"%@.png",strCharImageName]] ofButton:btnChar];
			}
			@catch (NSException * e) {
			}
			@finally {
			}
			
		}
	}
	
}

-(void)viewWillDisappear:(BOOL)animated
{
	bViewAppeared = FALSE;
	
	viewBall.hidden = TRUE;
	viewBird.hidden = TRUE;
	viewBunny.hidden = TRUE;
	viewPaperPlane.hidden = TRUE;
	viewSpider.hidden = TRUE;
	
	[self removeAllTimers];
	isAnimationOnScreen = FALSE;
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
	[self removeAllTimers];
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
    [super dealloc];
}


@end
