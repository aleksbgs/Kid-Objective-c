//
//  AnimalsViewController_iPhone.m
//  KIDPedia
//
//  Created by Acai on 07/03/11.
//  Copyright 2011 Aca Technologies. All rights reserved.
//

#import "AnimalsViewController_iPad.h"
//#define P(x,y) CGPointMake(x, y)

@implementation AnimalsViewController_iPad

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
#pragma mark SET FRAME OF BIG ANIMAL AND FISH
-(void)setFrameOfAnimalWithTimer:(NSTimer *)Timer
{
	NSLog(@"setShapeFrame");
	UIButton *btnAnimal = [[Timer userInfo] valueForKey:@"animal"];
	CGRect frame =[[[btnAnimal layer]presentationLayer] frame];
	CGFloat xPositon = frame.origin.x+frame.size.width/2;
	CGFloat yPosition = frame.origin.y+frame.size.height/2;
	//NSLog(@"current position of button:- %f %f and width is:- %f %f and original size is:- %f %f",frame.origin.x, frame.origin.y,frame.size.width,frame.size.height,btnShape.frame.size.width,btnShape.frame.size.height);
	//btnShape.frame = CGRectMake(frame.origin.x, frame.origin.y, btnShape.frame.size.width, btnShape.frame.size.height);
	btnAnimal.center = CGPointMake(xPositon, yPosition);
	[self.view bringSubviewToFront:btnAnimal];
}


-(void)setFrameOfDragonFly:(NSTimer*)timerDragon{
	NSLog(@"set Dragon Frame");
	
	AnimateObjectView *viewDragon = [[timerDragon userInfo]objectForKey:@"Dragon"];
	CGRect frame = [[viewDragon.layer presentationLayer] frame];
	NSLog(@"view dragon frame is:- %f %f %f %f",frame.origin.x,frame.origin.y,viewDragon.frame.size.width,viewDragon.frame.size.height);
	viewDragon.frame = CGRectMake(frame.origin.x, frame.origin.y, viewDragon.frame.size.width, viewDragon.frame.size.height);
	NSLog(@"viewDragpn");
	if (frame.origin.x<-90||frame.origin.y<-90) {
		NSLog(@"remove timer");
		
		AVAudioPlayer *dPlayer = [dicPlayers valueForKey:[NSString stringWithFormat:@"%i",viewDragon.ID]];
		NSLog(@"audioplayer description :- %@",[dPlayer description]);
		if (dPlayer) {
			[dPlayer stop];
			[dPlayer release];
			dPlayer = nil;
			[dicPlayers removeObjectForKey:[NSString stringWithFormat:@"%i",viewDragon.ID]];
		}
		
		viewDragon.hidden = TRUE;
		[timerDragon invalidate];
		timerDragon = nil;
		//[dicDragonTimer removeObjectForKey:[NSString stringWithFormat:@"%i",viewDragon.ID]];
	}
	NSLog(@"end dragon frame");
	
}


//-(void)setFrameOfDragonFly:(NSTimer*)timerDragon{
//	NSLog(@"set frame of dragon fly");
//	AnimateObjectView *viewDragon = [[timerDragon userInfo]objectForKey:@"Dragon"];
//	CGRect frame = [[viewDragon.layer presentationLayer] frame];
//	viewDragon.frame = CGRectMake(frame.origin.x, frame.origin.y, viewDragon.frame.size.width, viewDragon.frame.size.height);
//	if (frame.origin.x<-90||frame.origin.y<-90) {
//		NSLog(@"remove timer");
//		viewDragon.hidden = TRUE;
//		[timerDragon invalidate];
//		timerDragon = nil;
//		//[dicDragonTimer removeObjectForKey:[NSString stringWithFormat:@"%i",viewDragon.ID]];
//		
//	}
//	
//}

-(void)setFrameOfFish:(NSTimer *)timerFish
{
	UIView *viewFish = [[timerFish userInfo]objectForKey:@"Fish"];
	CGRect frame = [[viewFish.layer presentationLayer] frame];
	viewFish.frame = CGRectMake(frame.origin.x, frame.origin.y, viewFish.frame.size.width, viewFish.frame.size.height);
	if (frame.origin.x>-viewFish.frame.size.width && frame.origin.x<(self.view.frame.size.width+viewFish.frame.size.width)) {
		//NSLog(@"Moving Fish");
	}
	else {
		viewFish.hidden = TRUE;
		[timerFish invalidate];
		timerFish = nil;
	}
}
-(void)setFrameOfAnimal:(UIButton *)btnAnimal
{
	CGRect frame =[[[btnAnimal layer] presentationLayer] frame];
	btnAnimal.frame = frame;
	//NSLog(@"%.2f,%.2f",btnAnimal.frame.origin.x,btnAnimal.frame.origin.y);
}
-(void)enableButton:(UIButton *)btnAnimal
{
	btnAnimal.enabled = TRUE;
}

-(void)jumpAnimalAtRandomPosition:(UIButton *)btnAnimal
{
	//[self.view bringSubviewToFront:btnAnimal];
	float randomX = arc4random()%(int)self.view.frame.size.width;
	float randomY = arc4random()%(int)self.view.frame.size.height;
	if (randomY>=(self.view.frame.size.height-150)) {
		randomY = arc4random() % (int)(self.view.frame.size.height -150);
	}
	// make it jump a couple of times
	CGMutablePathRef thePath = CGPathCreateMutable();
	CGPathMoveToPoint(thePath, NULL, btnAnimal.center.x, btnAnimal.center.y);
	CGPoint point;
	float distanceX = (btnAnimal.center.x - randomX)/kNoOfJumps;
	float distanceY = (btnAnimal.center.y - randomY)/kNoOfJumps;
	for (int i=0; i<kNoOfJumps; i++) {
		point = CGPointMake(btnAnimal.center.x - ((i+1)*distanceX), btnAnimal.center.y - ((i+1)*distanceY));
		if (i==2) {
			if (point.x<20) {
				point.x = 100;
			}
			else if(point.x>618){
				point.x = 650;
			}
			
			if (point.y<300) {
				point.y=350;
			}
			
		}
		
		CGPathAddQuadCurveToPoint(thePath, nil,
								  point.x, point.y-JUMP, 
								  point.x, point.y);
	}
	
	[self playSoundEffect:@"animals_normal.mp3" withRepeatCount:0];
	
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:TRANSITION_ANIMATION] forKey:kCATransactionAnimationDuration];
	
	CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	CGPathMoveToPoint(thePath, NULL, btnAnimal.center.x , btnAnimal.center.y);
	positionAnimation.path = thePath;
	
	CAAnimationGroup *theGroup = [CAAnimationGroup animation];
	theGroup.delegate = self;
	theGroup.removedOnCompletion = NO;
	theGroup.fillMode = kCAFillModeForwards;
	theGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	theGroup.animations = [NSArray arrayWithObjects:positionAnimation,nil];
	int  position= btnAnimal.tag;
	NSString *strPosition = [NSString stringWithFormat:@"%d,5", position];
	[theGroup setValue:strPosition forKey:@"AnimationGroup"];
	[[btnAnimal layer] addAnimation:theGroup forKey:@"AnimationGroup"];
	
	[CATransaction commit];
	
	CGPathRelease(thePath);
	
}
-(void)putAnimalAtOriginPositionInMainThread:(NSDictionary*)btnDictionary{
	UIButton *btnAnimal = [btnDictionary objectForKey:@"btnAnimal"];
	int  position= [[btnDictionary objectForKey:@"position"]intValue];
	CGFloat xPosition = [[[dicCenterPoint objectForKey:[NSString stringWithFormat:@"%i",btnAnimal.tag]] objectAtIndex:0]floatValue];
	CGFloat yPosition = [[[dicCenterPoint objectForKey:[NSString stringWithFormat:@"%i",btnAnimal.tag]] objectAtIndex:1]floatValue];
	btnAnimal.center = self.view.center;
	
	//[self playSoundEffect:@"animals_normal.mp3" withRepeatCount:0];
	
	if ([dicAnimalTimer count]>0) {
		NSTimer *timer = [dicAnimalTimer valueForKey:[NSString stringWithFormat:@"%i",btnAnimal.tag]];
		if (timer) {
			[timer invalidate];
			timer=nil;
			[dicAnimalTimer removeObjectForKey:[NSString stringWithFormat:@"%i",btnAnimal.tag]];
		}
	}
	
	NSTimer *animalTimer = [NSTimer timerWithTimeInterval:0.00002 target:self selector:@selector(setFrameOfAnimalWithTimer:) userInfo:[NSDictionary dictionaryWithObject:btnAnimal forKey:@"animal"] repeats:YES];
	[[NSRunLoop mainRunLoop]addTimer:animalTimer forMode:NSRunLoopCommonModes];
	[dicAnimalTimer setObject:animalTimer forKey:[NSString stringWithFormat:@"%i",btnAnimal.tag]];
	
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:TRANSITION_ANIMATION] forKey:kCATransactionAnimationDuration];
	
	CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	CGMutablePathRef positionPath = CGPathCreateMutable();
	CGPathMoveToPoint(positionPath, NULL, self.view.center.x , self.view.center.y- (BOX_POSITION_LIMIT/3));
	CGPathAddLineToPoint(positionPath, NULL, xPosition , yPosition);
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
	NSString *strPosition = [NSString stringWithFormat:@"%d,3", position];
	[theGroup setValue:strPosition forKey:@"AnimationGroup"];
	[[btnAnimal layer] addAnimation:theGroup forKey:@"AnimationGroup"];
	
	[CATransaction commit];
	
	CGPathRelease(positionPath);
	
	//	[arrTimers removeObject:timer];


}

-(void)putAnimalAtOriginPosition:(NSDictionary *)btnDictionary
{
	[self performSelector:@selector(putAnimalAtOriginPositionInMainThread:) withObject:btnDictionary afterDelay:REMAIN_ANIMATION];
}
-(void)putAnimalOnScreenInMainThread:(NSDictionary*)btnDictionary{
	UIButton *btnAnimal = [btnDictionary objectForKey:@"btnAnimal"];
	btnAnimal.userInteractionEnabled = TRUE;
	[self.view bringSubviewToFront:btnAnimal];
	btnChest.userInteractionEnabled = TRUE;
	
	int position = [[btnDictionary objectForKey:@"position"]intValue];
	float randomX = arc4random()%(int)self.view.center.x;
	float randomY = arc4random()%(int)self.view.center.y;
	
	float directionRandomX = arc4random()% (int)self.view.center.x;
	float directionRandomY = arc4random()% (int)self.view.center.y;
	
	float valueX = 1*((self.view.center.x - randomX)/kNoOfJumps);
	if (randomX<directionRandomX) {
		valueX = -1*((self.view.center.x - randomX)/kNoOfJumps);
	}
	float valueY = 1*((self.view.center.y - randomY)/kNoOfJumps);
	if (randomY<directionRandomY) {
		valueY = -1*((self.view.center.y - randomY)/kNoOfJumps);
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
		if (point1.x<20) {
			point1.x = 100;
		}
		else if(point1.x>618){
			point1.x = 650;
		}
		if (point2.x<30) {
			point2.x = 100;
		}
		else if(point2.x>618){
			point2.x = 650;
		}
		if (point1.x>618&&point1.y<300) {
			point1.x = 650;
			point1.y=350;
		}
		if (point2.x>618&&point1.y<300) {
			point2.x = 650;
			point1.y=350;
		}
		
		CGPathAddCurveToPoint(thePath,
							  NULL,
							  point1.x,point1.y-JUMP,
							  point2.x,point1.y-JUMP,
							  point2.x,point1.y);
	}
	
	if ([dicAnimalTimer count]>0) {
		NSTimer *timer = [dicAnimalTimer valueForKey:[NSString stringWithFormat:@"%i",btnAnimal.tag]];
		if (timer) {
			[timer invalidate];
			timer=nil;
			[dicAnimalTimer removeObjectForKey:[NSString stringWithFormat:@"%i",btnAnimal.tag]];
		}
	}
	
	NSTimer *animalTimer = [NSTimer timerWithTimeInterval:0.00002 target:self selector:@selector(setFrameOfAnimalWithTimer:) userInfo:[NSDictionary dictionaryWithObject:btnAnimal forKey:@"animal"] repeats:YES];
	[[NSRunLoop mainRunLoop]addTimer:animalTimer forMode:NSRunLoopCommonModes];
	[dicAnimalTimer setObject:animalTimer forKey:[NSString stringWithFormat:@"%i",btnAnimal.tag]];
	
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
	[[btnAnimal layer] addAnimation:theGroup forKey:@"AnimationGroup"];
	
	[CATransaction commit];
	
	CGPathRelease(thePath);
	
	//	[arrTimers removeObject:timer];	
	
}
-(void)putAnimalOnScreen:(NSDictionary *)btnDictionary
{
	[self performSelector:@selector(putAnimalOnScreenInMainThread:) withObject:btnDictionary afterDelay:REMAIN_ANIMATION];
	
}
#pragma mark -
#pragma mark GET NAMES ACCORDING TO LANGUAGE SELECTION

-(NSString *)getAnimalsTitleSoundName
{
	NSString *soundName = NSLocalizedString(@"appAnimalsTitleSoundName",nil);
	@try {
		int value = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] intValue];
		switch (value) {
			case 0:
				soundName = NSLocalizedString(@"appAnimalsTitleSoundName",nil);
				break;
			case 1:
				soundName = @"animals";
				break;
			case 2:
				soundName = @"animals_spanish";
				break;
			case 3:
				soundName = @"animals_french";
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
-(NSString *)getAnimalSoundName
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
-(NSString *)getAnimalGraphicName
{
	NSString *graphicName = NSLocalizedString(@"appAnimalGraphicName",nil);
	@try {
		int value = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] intValue];
		switch (value) {
			case 0:
				graphicName = NSLocalizedString(@"appAnimalGraphicName",nil);
				break;
			case 1:
				graphicName = @"%@";
				break;
			case 2:
				graphicName = @"%@";
				break;
			case 3:
				graphicName = @"%@";
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

-(NSString *)getAnimalsTitleGraphicName
{
	NSString *graphicName = NSLocalizedString(@"appAnimalsTitleGraphicName",nil);
	@try {
		int value = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] intValue];
		switch (value) {
			case 0:
				graphicName = NSLocalizedString(@"appAnimalsTitleGraphicName",nil);
				break;
			case 1:
				graphicName = @"animalstitle";
				break;
			case 2:
				graphicName = @"animalstitle_spanish";
				break;
			case 3:
				graphicName = @"animalstitle_french";
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
#pragma mark -
#pragma mark ADD DRAGONFLY FUNCTION
-(void)addDragonFliesToScreen{
	if (!flagChestClose) {
		
		//for (int i=0; i<[arrDragonFliesOnScreen count]; i++) {
//			UIImageView *imageView = [arrDragonFliesOnScreen objectAtIndex:i];
//			[imageView removeFromSuperview];
//		}
		//[arrDragonFliesOnScreen removeAllObjects];
		
		int randomCount = arc4random() % MAX_DRAGONS;
		if (randomCount==0) {
			randomCount = 1;
		}
		CGFloat direction = -1;
		for (int i=0; i<randomCount; i++) {
			NSArray *arrImages = [NSLocalizedString(@"appDragonFlyImages",nil) componentsSeparatedByString:@","];
			int randomPosition = arc4random() % [NSLocalizedString(@"appDragonFlyTotalImages", nil) intValue];//[arrImages count];
			int x = btnChest.center.x; //arc4random()% (int)self.view.frame.size.width;
			int y = btnChest.center.y-80;//arc4random()% (int)self.view.frame.size.height;
			NSMutableArray *arrUIImages = [[NSMutableArray alloc]init];
			for(int i=0;i<[arrImages count];i++){
				NSString *strImageName = [NSString stringWithFormat:[arrImages objectAtIndex:i],randomPosition];
				UIImage *image = [UIImage thumbnailImage:strImageName];
				[arrUIImages addObject:image];
			}
			AnimateObjectView *imageView = [[AnimateObjectView alloc]init];
			imageView.animationImages = arrUIImages;
			imageView.animationDuration = 0.2f;
			imageView.delegate=self;
			imageView.userInteractionEnabled=TRUE;
			imageView.tag=100;
			imageView.ID=index;
			[imageView startAnimating];
			imageView.frame = CGRectMake(x, y, DRAGON_WIDTH, DRAGON_HEIGHT);
			[arrDragonFliesOnScreen addObject:imageView];
			[self.view addSubview:imageView];
			
			[arrUIImages release];
			
			int randomX = arc4random()% (int)self.view.frame.size.width;
			//int randomY = arc4random()% (int)self.view.frame.size.height;
			if (i==1||i==3) {
				direction = 1.5;
			}
			else {
				direction = -1;
			}
			NSTimer *timerFlyDragon = [NSTimer scheduledTimerWithTimeInterval:DRAGON_ANIMATION_DURATION/DIVIDE_FRAME_TIMER target:self selector:@selector(setFrameOfDragonFly:) userInfo:[NSDictionary dictionaryWithObject:imageView forKey:@"Dragon"] repeats:YES];
			[[NSRunLoop mainRunLoop] addTimer:timerFlyDragon forMode:NSRunLoopCommonModes];
			//[arrTimers addObject:timerFlyDragon];
			[dicDragonTimer setObject:timerFlyDragon forKey:[NSString stringWithFormat:@"%i",imageView.ID]];
			
			[CATransaction begin];
			[CATransaction setValue:[NSNumber numberWithFloat:DRAGON_ANIMATION_DURATION] forKey:kCATransactionAnimationDuration];
			
			CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
			
			CGMutablePathRef positionPath = CGPathCreateMutable();
			CGPathMoveToPoint(positionPath, NULL, imageView.center.x ,  imageView.center.y );
			CGPathAddLineToPoint(positionPath, NULL,randomX*direction , -60);
			positionAnimation.path = positionPath;
			
			//positionAnimation.rotationMode = kCAAnimationRotateAuto;
			positionAnimation.delegate = self;
			positionAnimation.removedOnCompletion = NO;
			positionAnimation.fillMode = kCAFillModeForwards;
			positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
			
			NSString *strPosition = [NSString stringWithFormat:@"%i,6",index];
			[positionAnimation setValue:strPosition forKey:@"AnimationGroup"];
			[[imageView layer] addAnimation:positionAnimation forKey:@"moveCommetAnimation"];
			index++;
			
			NSString *soundFile = @"dragonfly.mp3";
			NSMutableDictionary *dicSound = [[NSMutableDictionary alloc] init];
			[dicSound setObject:soundFile forKey:@"sound"];
			[dicSound setObject:[NSString stringWithFormat:@"%i",imageView.ID] forKey:@"object"];
			
			[self performSelector:@selector(playDragonEffect:) withObject:dicSound];
			
			CGPathRelease(positionPath);
			[CATransaction commit];
			[imageView release];
			
			
		}
		
	}
		
}


#pragma mark -
#pragma mark REMOVE ALL GRAPHICS ON SCREEN
-(void)removeAllTimers
{		
	isViewAppeared = FALSE;
	
	[dicCenterPoint removeAllObjects];
	if ([dicAnimalTimer count]>0) {
		for (int i=0; i<[dicAnimalTimer count]; i++) {
			NSTimer *timer = [dicAnimalTimer objectForKey:[[dicAnimalTimer allKeys]objectAtIndex:i]];
			if (timer) {
				[timer invalidate];
				timer = nil;
			}
		}
		[dicAnimalTimer removeAllObjects];
	}
	for (int i=0; i<[fishTimers count]; i++) {
		NSTimer *timer = [fishTimers objectForKey:[[fishTimers allKeys] objectAtIndex:i]];
		if ([timer isValid]) {
			[timer invalidate];
		}
	}
	[fishTimers removeAllObjects];
	
	[[NSRunLoop mainRunLoop] cancelPerformSelectorsWithTarget:self];
	[[NSRunLoop currentRunLoop] cancelPerformSelectorsWithTarget:self];
	[NSRunLoop cancelPreviousPerformRequestsWithTarget:self];
	
	if ([timerRotateWatermill isValid]) {
		[timerRotateWatermill invalidate];
	}
}
-(void)removeAllAudioPlayers
{
	for (int i=0; i<[dicPlayers count];) {
		NSObject *object = [dicPlayers objectForKey:[[dicPlayers allKeys]objectAtIndex:i]];
        if([object isKindOfClass:[AVAudioPlayer class]]){
            AVAudioPlayer *avPlayer = (AVAudioPlayer *)object;
            if([avPlayer isPlaying]){
                [avPlayer stop];
                [avPlayer release];
            }
            [dicPlayers removeObjectForKey:[[dicPlayers allKeys]objectAtIndex:i]];
        }else{
            i++;
        }
	}
    //[dicPlayers removeAllObjects];
}
-(void)removeAllAnimalsOnScreen
{
	
	[self removeAllAudioPlayers];
	if ([dicDragonTimer count]>0) {
		NSArray *arrTemp = [dicDragonTimer allValues];
		for (int l=0; l<[arrTemp count]; l++) {
			NSTimer *dTimer = [arrTemp objectAtIndex:l];
			if (dTimer) {
				[dTimer invalidate];
				dTimer=nil;
			}
		}
	}
	[dicDragonTimer removeAllObjects];
	
	for (int i=0; i<[arrTimers count]; i++) {
		NSTimer *timer = [arrTimers objectAtIndex:i];
		if ([timer isValid]) {
			[timer invalidate];
		}
	}
	[arrTimers removeAllObjects];
	
	for (int i=0; i<[arrAnimalsOnScreen count]; i++) {
		UIButton *btnAnimal = [arrAnimalsOnScreen objectAtIndex:i];
		[[btnAnimal layer] removeAllAnimations];
		[btnAnimal removeFromSuperview];
	}
	for (int k=0; k<[arrDragonFliesOnScreen count]; k++) {
		UIImageView *imageView = [arrDragonFliesOnScreen objectAtIndex:k];
		[[imageView layer]removeAllAnimations];
		[imageView removeFromSuperview];
	}
	index=0;
	[arrDragonFliesOnScreen removeAllObjects];
	[arrAnimalsOnScreen removeAllObjects];
	
}
#pragma mark -
#pragma mark AUDIO PLAYER DELEGATE EVENTS
-(void)playAnimalSoundEffect:(Objects *)object{
	[self playSoundEffect:[NSString stringWithFormat:@"effect_%@.mp3",[object.EnglishTitle lowercaseString]] withRepeatCount:0];
}

-(void)removeAudioPlayer:(AVAudioPlayer*)avPlayer{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	if (avPlayer) {
		[dicPlayers removeObjectForKey:[avPlayer description]];
		[dicPlayers removeObjectForKey:[NSString stringWithFormat:@"VO#%@",[avPlayer description]]];
		[avPlayer release];
		avPlayer=nil;
	}
	
	[pool release];
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)avPlayer successfully:(BOOL)flag
{
	[self performSelector:@selector(removeAudioPlayer:) withObject:avPlayer];
	
	//NSObject *object = [dicPlayers objectForKey:[avPlayer description]];
//	//if (!object) {
////		object = [dicPlayers objectForKey:[NSString stringWithFormat:@"VO#%@",[avPlayer description]]];
////		if (object) {
////			NSArray *array = (NSArray *)object;
////			if ([array count]>1) {
////                int position = [[array objectAtIndex:1] intValue];
////				Objects *animalobject = [arrObjects objectAtIndex:position];
////				[self playAnimalSoundEffect:animalobject];
////			}
////            [avPlayer release];
////		}
////	}
//	if (object) {
//		[dicPlayers removeObjectForKey:[avPlayer description]];
//		[avPlayer release];
//	}
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
-(void)playDragonEffect:(NSMutableDictionary*)dicObject{
	
	NSError *error;
	NSString *soundPath = [[NSString alloc] initWithFormat:@"%@/%@", resourcePath,[dicObject valueForKey:@"sound"]];
	AVAudioPlayer *effectPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:&error];
	
	if (error) {
		NSLog(@"Failed with reason: %@", [error localizedDescription]);
	}
	else {
		effectPlayer.numberOfLoops = -1;
		[effectPlayer play];
		[dicPlayers setObject:effectPlayer forKey:[dicObject valueForKey:@"object"]];
	}
	[soundPath release];
	
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

-(void)playVOAudioPlayer:(NSTimer *)timer{
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
			[dicPlayers setObject:soundEffectsPlayer forKey:[soundEffectsPlayer description]];//[NSString stringWithFormat:@"VO#%@",[soundEffectsPlayer description]]];
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

-(void)playVOSound:(NSString *)soundFileName withObject:(Objects *)object
{
	NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.0f target:self selector:@selector(playVOAudioPlayer:) 
													userInfo:[NSDictionary dictionaryWithObjectsAndKeys:soundFileName,@"SoundName",@"0",@"RepeatCount",object,@"Object",nil]
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
#pragma mark SLIDE ANIMATION
-(void)slideAnimal:(UIButton *)btnAnimal
{
	[self.view bringSubviewToFront:imgSlideView];
	[self.view bringSubviewToFront:btnAnimal];
	CGMutablePathRef thePath = CGPathCreateMutable();
	CGPathMoveToPoint(thePath, NULL, 280.0f, 280.0f);
	Objects *object = [arrObjects objectAtIndex:btnAnimal.tag];
	NSString *strSoundName = [NSString stringWithFormat:[self getAnimalSoundName],object.SoundFileName];
	[self playVOSound:[NSString stringWithFormat:@"%@.mp3",strSoundName] withObject:object];
	
	[self playSoundEffect:@"slide_sound_effect.mp3" withRepeatCount:0];
	[self performSelector:@selector(playAnimalSoundEffect:) withObject:object afterDelay:SLIDE_ANIMATION_DURATION/2];
	
	NSArray *controlPoints = [NSLocalizedString(@"iPhoneAnimalsSlideControlParameters_iPad",nil) componentsSeparatedByString:@";"];
	NSArray *points = [NSLocalizedString(@"iPhoneAnimalsSlideParameters_iPad",nil) componentsSeparatedByString:@";"];
	
	for (int i=0; i<[controlPoints count]; i++) {
		CGPoint controlPoint = CGPointFromString([controlPoints objectAtIndex:i]);
		CGPoint point = CGPointFromString([points objectAtIndex:i]);
		
		CGPathAddQuadCurveToPoint(thePath, NULL, 
								  controlPoint.x,controlPoint.y, 
								  point.x,point.y);
	}
	
	if ([dicAnimalTimer count]>0) {
		NSTimer *timer = [dicAnimalTimer valueForKey:[NSString stringWithFormat:@"%i",btnAnimal.tag]];
		if (timer) {
			[timer invalidate];
			timer=nil;
			[dicAnimalTimer removeObjectForKey:[NSString stringWithFormat:@"%i",btnAnimal.tag]];
		}
	}
	
	NSTimer *animalTimer = [NSTimer timerWithTimeInterval:0.00002 target:self selector:@selector(setFrameOfAnimalWithTimer:) userInfo:[NSDictionary dictionaryWithObject:btnAnimal forKey:@"animal"] repeats:YES];
	[[NSRunLoop mainRunLoop]addTimer:animalTimer forMode:NSRunLoopCommonModes];
	[dicAnimalTimer setObject:animalTimer forKey:[NSString stringWithFormat:@"%i",btnAnimal.tag]];
	
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:SLIDE_ANIMATION_DURATION] forKey:kCATransactionAnimationDuration];
	
	CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	anim.delegate = self;
	anim.path = thePath;
	anim.repeatCount = 0;
	int position = [arrAnimalsOnScreen indexOfObject:btnAnimal];
	NSString *strPosition = [NSString stringWithFormat:@"%d,4", position];
	[anim setValue:strPosition forKey:@"AnimationGroup"];
	
	[btnAnimal.layer addAnimation:anim forKey:@"AnimationGroup"];
	
	[CATransaction commit];
	CGPathRelease(thePath);	
	
	btnAnimal.center = CGPointMake(524.00,424.00);
}
#pragma mark -
#pragma mark DRAG EVENTS
- (void)animal:(UIButton *)animal didStartDrag:(UIEvent *)event
{
	dragFlag = YES;
	if ([dicAnimalTimer count]>0) {
		NSTimer *timer = [dicAnimalTimer valueForKey:[NSString stringWithFormat:@"%i",animal.tag]];
		if (timer) {
			[timer invalidate];
			timer=nil;
			[dicAnimalTimer removeObjectForKey:[NSString stringWithFormat:@"%i",animal.tag]];
		}
	}
	if(animal == btnAnimationRunning){
		NSLog(@"Match");
		NSString *position = [NSString stringWithFormat:@"%d",[arrAnimalsOnScreen indexOfObject:animal]];
		//NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:fruit,@"",position,@"",nil];
		NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:animal, @"btnAnimal", position,@"position",  nil];
		[NSRunLoop cancelPreviousPerformRequestsWithTarget:self selector:@selector(putAnimalOnScreenInMainThread:) object:dict];
		[NSRunLoop cancelPreviousPerformRequestsWithTarget:self selector:@selector(putAnimalAtOriginPositionInMainThread:) object:dict];
	}
	[[animal layer] removeAllAnimations];
	
	//[self.view bringSubviewToFront:imgSlideView];
	[self.view bringSubviewToFront:animal];
	UITouch *touch = [[event allTouches] anyObject];
	if (touch.phase == UITouchPhaseMoved) {
		if (!isMoving) {
			dragPlayer = [self playSoundDragEffect:@"DragLetter.mp3" withRepeatCount:-1];
			//oldFrame = animal.frame;
		}
		isMoving = TRUE;
		CGPoint touchDownPoint = [touch locationInView:animal.superview];
		animal.center = touchDownPoint;
	}
}
- (void)animal:(UIButton *)animal didEndDrag:(UIEvent *)event
{
	if ([dicAnimalTimer count]>0) {
		NSTimer *timer = [dicAnimalTimer valueForKey:[NSString stringWithFormat:@"%i",animal.tag]];
		if (timer) {
			[timer invalidate];
			timer=nil;
			[dicAnimalTimer removeObjectForKey:[NSString stringWithFormat:@"%i",animal.tag]];
		}
	}
	[[animal layer] removeAllAnimations];
	
	if (isMoving) {
		UITouch *touch = [[event allTouches] anyObject];
		CGPoint touchDownPoint = [touch locationInView:animal.superview];
		isMoving = FALSE;
		[self doVolumeFade:dragPlayer];
		if (CGRectContainsPoint(imgSlideView.frame, touchDownPoint)) {
			[self slideAnimal:animal];
		}
	}
	else {
		[self animalClicked:animal];
	}
}

- (void)chest:(UIButton *)chest didStartDrag:(UIEvent *)event
{
	[self.view bringSubviewToFront:chest];
	UITouch *touch = [[event allTouches] anyObject];
	if (touch.phase == UITouchPhaseMoved) {
		if (!isMoving) {
			dragPlayer = [self playSoundDragEffect:@"DragLetter.mp3" withRepeatCount:-1];
			//oldFrame = animal.frame;
		}
		isMoving = TRUE;
		CGPoint touchDownPoint = [touch locationInView:chest.superview];
		chest.center = touchDownPoint;
	}
}
- (void)chest:(UIButton *)chest didEndDrag:(UIEvent *)event
{
	if (isMoving) {
		isMoving = FALSE;
		[self doVolumeFade:dragPlayer];
	}
	else {
		[self chestClicked:chest];
	}
	
}
#pragma mark -
#pragma mark MOVE FISH
-(void)moveFishToLeftWithView:(AnimateObjectView *)viewFish withPoints:(NSArray *)arrPoints
{
	
	if (isViewAppeared) {
		viewFish.hidden = FALSE;
		int fishMoveDuration = viewFish.duration;
		
		int startXPosition=0,endXPosition=0,startYPosition=0, endYPosition=0;
		if ([arrPoints count]>3) {
			startXPosition = [[arrPoints objectAtIndex:0] intValue];
			endXPosition = [[arrPoints objectAtIndex:1] intValue];
			startYPosition = [[arrPoints objectAtIndex:2] intValue];
			endYPosition = [[arrPoints objectAtIndex:3] intValue];
		}
		
		if (viewFish.tag==1) {
			[self playSoundEffect:@"fish_normal.mp3" withRepeatCount:0];
		}
		else {
			[self playSoundEffect:@"fish_fast.mp3" withRepeatCount:0];
		}
		
		NSTimer *timerFish = [NSTimer scheduledTimerWithTimeInterval:fishMoveDuration/DIVIDE_FRAME_TIMER target:self selector:@selector(setFrameOfFish:) userInfo:[NSDictionary dictionaryWithObject:viewFish forKey:@"Fish"] repeats:YES];
		[[NSRunLoop mainRunLoop] addTimer:timerFish forMode:NSRunLoopCommonModes];
		[fishTimers setObject:timerFish forKey:[NSString stringWithFormat:@"%d-1",viewFish.ID]];
		
		[CATransaction begin];
		[CATransaction setValue:[NSNumber numberWithFloat:fishMoveDuration] forKey:kCATransactionAnimationDuration];
		
		CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
		rotateAnimation.rotationMode = kCAAnimationRotateAuto;
		
		CGMutablePathRef movePath = CGPathCreateMutable();
		CGPathMoveToPoint(movePath, nil, startXPosition, startYPosition);
		CGPathAddLineToPoint(movePath, nil,endXPosition, endYPosition);
		
		rotateAnimation.path = movePath;
		[rotateAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
		
		[viewFish.layer addAnimation:rotateAnimation forKey:@"moveFishAnimation"];
		
		[CATransaction commit];
		CGPathRelease(movePath);
		
		startXPosition = arc4random() % (int)self.view.frame.size.width;
		endXPosition = (self.view.frame.size.width+ viewFish.frame.size.width+30);
		startYPosition = (self.view.frame.size.height-20);
		endYPosition=self.view.frame.size.height-150;
		if (startXPosition<=10) {
			startXPosition = 30;
			startYPosition = self.view.frame.size.height+10;
		}
		
		float randomAnimation = fishMoveDuration + MAX_TIME_REST + (arc4random() % RANDOM_MAX_DURATION);
		NSTimer *timerMoveFish = [NSTimer scheduledTimerWithTimeInterval:randomAnimation target:self selector:@selector(moveFishToLeft:) userInfo:[NSDictionary dictionaryWithObjectsAndKeys:viewFish,@"Fish",[NSString stringWithFormat:@"%d,%d,%d,%d",startXPosition, endXPosition,startYPosition, endYPosition],@"Point", nil] repeats:NO];
		[fishTimers setObject:timerMoveFish forKey:[NSString stringWithFormat:@"%d",viewFish.ID]];
		[[NSRunLoop mainRunLoop] addTimer:timerMoveFish forMode:NSRunLoopCommonModes];
	}
}

-(void)moveFishToRightWithView:(AnimateObjectView *)viewFish withPoints:(NSArray *)arrPoints
{
	
	if (isViewAppeared) {
		viewFish.hidden = FALSE;
		int fishMoveDuration = viewFish.duration;
		
		int startXPosition=0,endXPosition=0,startYPosition=0, endYPosition=0;
		if ([arrPoints count]>3) {
			startXPosition = [[arrPoints objectAtIndex:0] intValue];
			endXPosition = [[arrPoints objectAtIndex:1] intValue];
			startYPosition = [[arrPoints objectAtIndex:2] intValue];
			endYPosition = [[arrPoints objectAtIndex:3] intValue];
		}
		
		if (viewFish.tag==1) {
			[self playSoundEffect:@"fish_normal.mp3" withRepeatCount:0];
		}
		else {
			[self playSoundEffect:@"fish_fast.mp3" withRepeatCount:0];
		}
		
		NSTimer *timerFish = [NSTimer scheduledTimerWithTimeInterval:fishMoveDuration/DIVIDE_FRAME_TIMER target:self selector:@selector(setFrameOfFish:) userInfo:[NSDictionary dictionaryWithObject:viewFish forKey:@"Fish"] repeats:YES];
		[[NSRunLoop mainRunLoop] addTimer:timerFish forMode:NSRunLoopCommonModes];
		[fishTimers setObject:timerFish forKey:[NSString stringWithFormat:@"%d-1",viewFish.ID]];
		
		[CATransaction begin];
		[CATransaction setValue:[NSNumber numberWithFloat:fishMoveDuration] forKey:kCATransactionAnimationDuration];
		
		CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
		rotateAnimation.rotationMode = kCAAnimationRotateAutoReverse;
		
		CGMutablePathRef movePath = CGPathCreateMutable();
		CGPathMoveToPoint(movePath, nil, startXPosition, startYPosition);
		CGPathAddLineToPoint(movePath, nil,endXPosition, endYPosition);
		
		rotateAnimation.path = movePath;
		[rotateAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
		
		[viewFish.layer addAnimation:rotateAnimation forKey:@"moveFishAnimation"];
		
		[CATransaction commit];
		CGPathRelease(movePath);
		
		startXPosition = self.view.frame.size.width;
		endXPosition = -self.view.frame.size.width;
		startYPosition = (self.view.frame.size.height-135) + (arc4random() % 135);
		endYPosition=self.view.frame.size.height+150;
		
		float randomAnimation = fishMoveDuration + MAX_TIME_REST + (arc4random() % RANDOM_MAX_DURATION);
		NSTimer *timerMoveFish = [NSTimer scheduledTimerWithTimeInterval:randomAnimation target:self selector:@selector(moveFishToRight:) userInfo:[NSDictionary dictionaryWithObjectsAndKeys:viewFish,@"Fish",[NSString stringWithFormat:@"%d,%d,%d,%d",startXPosition, endXPosition,startYPosition, endYPosition],@"Point", nil] repeats:NO];
		[fishTimers setObject:timerMoveFish forKey:[NSString stringWithFormat:@"%d",viewFish.ID]];
		[[NSRunLoop mainRunLoop] addTimer:timerMoveFish forMode:NSRunLoopCommonModes];
	}
}

-(void)moveFishToLeft:(NSTimer *)timer
{
	if (isViewAppeared) {
		AnimateObjectView *viewFish = [[timer userInfo] objectForKey:@"Fish"];
		NSArray *arrPoints = [[[timer userInfo] objectForKey:@"Point"] componentsSeparatedByString:@","];
		[self moveFishToLeftWithView:viewFish withPoints:arrPoints];
	}
}

-(void)moveFishToRight:(NSTimer *)timer
{
	if (isViewAppeared) {
		AnimateObjectView *viewFish = [[timer userInfo] objectForKey:@"Fish"];
		NSArray *arrPoints = [[[timer userInfo] objectForKey:@"Point"] componentsSeparatedByString:@","];
		[self moveFishToRightWithView:viewFish withPoints:arrPoints];
	}
}

-(void)showAgainRemoveFish:(AnimateObjectView*)viewFish{
	[self.view addSubview:viewFish];
	[self.view insertSubview:viewFish belowSubview:imgTopBackgroundView];
	[self.view bringSubviewToFront:btnAnimalsTitle];
}

#pragma mark -
#pragma mark ANIMATE OBJECT VIEW DELEGATE EVENT
- (void)didClickFirstTime:(id)animView
{
	[self playSoundEffect:@"slide_sound_effect.mp3" withRepeatCount:0];
	AnimateObjectView *obj = animView;
	if (obj.tag==100) {
		NSTimer *timer = [dicDragonTimer valueForKey:[NSString stringWithFormat:@"%i",obj.ID]];
		NSLog(@"dictionary is:- %@",[dicDragonTimer description]);
		if (timer) {
			[timer invalidate];
			timer=nil;
			[dicDragonTimer removeObjectForKey:[NSString stringWithFormat:@"%i",obj.ID]];
		}
		AVAudioPlayer *dPlayer = [dicPlayers valueForKey:[NSString stringWithFormat:@"%i",obj.ID]];
		NSLog(@"audioplayer description :- %@",[dPlayer description]);
		if (dPlayer) {
			[dPlayer stop];
			[dPlayer release];
			dPlayer = nil;
			[dicPlayers removeObjectForKey:[NSString stringWithFormat:@"%i",obj.ID]];
		}
		
		
		
		[obj removeFromSuperview];
		[[obj layer] removeAllAnimations];
				
	}
	else {
		isViewAppeared = FALSE;
		AnimateObjectView *viewFish = (AnimateObjectView *)animView;
		NSTimer *timer = [fishTimers objectForKey:[NSString stringWithFormat:@"%d",viewFish.ID]];
		NSTimer *timerFish = [fishTimers objectForKey:[NSString stringWithFormat:@"%d-1",viewFish.ID]];
		int fishMoveDuration = viewFish.duration;
		
		if ([timer isValid]) {
			[timer invalidate];
		}
		if ([timerFish isValid]) {
			[timerFish invalidate];
		}
		
		[fishTimers removeObjectForKey:[NSString stringWithFormat:@"%d-1",viewFish.ID]];
		[fishTimers removeObjectForKey:[NSString stringWithFormat:@"%d",viewFish.ID]];
		
		[[viewFish layer] removeAnimationForKey:@"moveFishAnimation"];
		[viewFish removeFromSuperview];
		//[self playSoundEffect:@"slide_sound_effect.mp3" withRepeatCount:0];
		[self performSelector:@selector(showAgainRemoveFish:) withObject:viewFish afterDelay:SHOW_REMOVE_FISH];
		
		viewFish.duration = fishMoveDuration;
		
		int startXPosition = viewFish.center.x;
		int endXPosition = 0.0f;
		int startYPosition = viewFish.center.y+10;
		int endYPosition = 0.0f;
		if (!viewFish.isLeft) {
			endXPosition = -self.view.frame.size.width;
			endYPosition=self.view.frame.size.height+150;
		}
		else {
			endXPosition = (self.view.frame.size.width+viewFish.frame.size.width+30);
			endYPosition=self.view.frame.size.height-150;
		}
		
		isViewAppeared = TRUE;
		NSString *strPoints = [NSString stringWithFormat:@"%d,%d,%d,%d",startXPosition, endXPosition, startYPosition, endYPosition];
		if (viewFish.isLeft) {
			[self moveFishToLeftWithView:viewFish withPoints:[strPoints componentsSeparatedByString:@","]];
		}else {
			[self moveFishToRightWithView:viewFish withPoints:[strPoints componentsSeparatedByString:@","]];
		}
		
	}
	
}
- (void)didClickSecondTime:(id)animView
{
	[self playSoundEffect:@"slide_sound_effect.mp3" withRepeatCount:0];
	AnimateObjectView *obj = animView;
	if (obj.tag==100) {
		NSTimer *timer = [dicDragonTimer valueForKey:[NSString stringWithFormat:@"%i",obj.ID]];
		NSLog(@"dictionary is:- %@",[dicDragonTimer description]);
		if (timer) {
			[timer invalidate];
			timer=nil;
			[dicDragonTimer removeObjectForKey:[NSString stringWithFormat:@"%i",obj.ID]];
		}
		AVAudioPlayer *dPlayer = [dicPlayers valueForKey:[NSString stringWithFormat:@"%i",obj.ID]];
		NSLog(@"audioplayer description :- %@",[dPlayer description]);
		if (dPlayer) {
			[dPlayer stop];
			[dPlayer release];
			dPlayer = nil;
			[dicPlayers removeObjectForKey:[NSString stringWithFormat:@"%i",obj.ID]];
		}
		[obj removeFromSuperview];
		[[obj layer] removeAllAnimations];
		
	}
	else {
		isViewAppeared = FALSE;
		AnimateObjectView *viewFish = (AnimateObjectView *)animView;
		NSTimer *timer = [fishTimers objectForKey:[NSString stringWithFormat:@"%d",viewFish.ID]];
		NSTimer *timerFish = [fishTimers objectForKey:[NSString stringWithFormat:@"%d-1",viewFish.ID]];
		
		if ([timer isValid]) {
			[timer invalidate];
		}
		if ([timerFish isValid]) {
			[timerFish invalidate];
		}
		
		[fishTimers removeObjectForKey:[NSString stringWithFormat:@"%d-1",viewFish.ID]];
		[fishTimers removeObjectForKey:[NSString stringWithFormat:@"%d",viewFish.ID]];
		
		[[viewFish layer] removeAnimationForKey:@"moveFishAnimation"];
		int startXPosition = viewFish.center.x;
		int endXPosition = 0.0f;
		int startYPosition = viewFish.center.y+10;
		int endYPosition = 0.0f;
		int fishMoveDuration = FISH_MOVE_ANIMATION_DURATION;
		[viewFish removeFromSuperview];
		//[self playSoundEffect:@"slide_sound_effect.mp3" withRepeatCount:0];
		[self performSelector:@selector(showAgainRemoveFish:) withObject:viewFish afterDelay:SHOW_REMOVE_FISH];
		
		viewFish.duration = fishMoveDuration;
		if (viewFish.isLeft) {
			endXPosition = -self.view.frame.size.width;
			endYPosition=self.view.frame.size.height+150;
			viewFish.imageName = [viewFish.imageName stringByReplacingOccurrencesOfString:@"left" withString:@"right"];
		}
		else {
			endXPosition = (self.view.frame.size.width+viewFish.frame.size.width+30);
			endYPosition=self.view.frame.size.height-150;
			viewFish.imageName = [viewFish.imageName stringByReplacingOccurrencesOfString:@"right" withString:@"left"];
		}
		viewFish.image = [UIImage thumbnailImage:viewFish.imageName];
		viewFish.isLeft = !viewFish.isLeft;
		isViewAppeared = TRUE;
		NSString *strPoints = [NSString stringWithFormat:@"%d,%d,%d,%d",startXPosition, endXPosition, startYPosition, endYPosition];
		if (viewFish.isLeft) {
			[self moveFishToLeftWithView:viewFish withPoints:[strPoints componentsSeparatedByString:@","]];
		}else {
			[self moveFishToRightWithView:viewFish withPoints:[strPoints componentsSeparatedByString:@","]];
		}
		
	}
		
}

#pragma mark -
#pragma mark ROTATE WATERMILL
-(void)rotateWatermillNormally
{
	@try {
		if (timerRotateWatermill) {
			[timerRotateWatermill invalidate];
			timerRotateWatermill = nil;
		}
		[btnWatermill.imageView stopAnimating];
		btnWatermill.imageView.animationDuration = WATERMILL_ANIMATION_DURATION;
		[btnWatermill.imageView startAnimating];
	}
	@catch (NSException * e) {
	}
	@finally {
	}
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
			UIButton *btnAnimal;
			if ([arrAnimalsOnScreen count]>position) {
				btnAnimal = [arrAnimalsOnScreen objectAtIndex:position];
				if ([dicAnimalTimer count]>0) {
					NSTimer *timer = [dicAnimalTimer valueForKey:[NSString stringWithFormat:@"%i",btnAnimal.tag]];
					if (timer) {
						[timer invalidate];
						timer=nil;
						[dicAnimalTimer removeObjectForKey:[NSString stringWithFormat:@"%i",btnAnimal.tag]];
					}
				}
			}
			
			//NSTimer *timer = nil;
			switch (animSequence) {
				case 0:
					//btnAnimal.enabled = FALSE
					btnAnimal.center = self.view.center;
					//timer = [NSTimer scheduledTimerWithTimeInterval:REMAIN_ANIMATION target:self selector:@selector(putAnimalOnScreen:) userInfo:[NSDictionary dictionaryWithObjectsAndKeys:btnAnimal, @"btnAnimal", [NSString stringWithFormat:@"%d",position],@"position",  nil] repeats:NO];
//					[[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
//					[arrTimers addObject:timer];
					[self performSelectorOnMainThread:@selector(putAnimalOnScreen:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:btnAnimal, @"btnAnimal", [NSString stringWithFormat:@"%d",position],@"position",  nil] waitUntilDone:NO];
					
					break;
				case 1:
					[self setFrameOfAnimal:btnAnimal];
					[self enableButton:btnAnimal];
					[[btnAnimal layer] removeAllAnimations];
					if (btnAnimal.tag == [arrObjects count]-1) {
						
						//[self.view bringSubviewToFront:btnAnimal];
						//[self.view bringSubviewToFront:imgSlideView];
						[self.view insertSubview:btnAnimal belowSubview:imgSlideView];
						if (btnChest.tag==0) {
							//btnChest.tag=0;
							[self performSelector:@selector(chestClicked:) withObject:btnChest afterDelay:TRANSITION_ANIMATION];
							//[self chestClicked:btnChest];
							[self.view bringSubviewToFront:btnChest];
							
						}
					}
					break;
				case 2:
					//timer = [NSTimer scheduledTimerWithTimeInterval:REMAIN_ANIMATION target:self selector:@selector(putAnimalAtOriginPosition:) userInfo:[NSDictionary dictionaryWithObjectsAndKeys:btnAnimal, @"btnAnimal", [NSString stringWithFormat:@"%d",position],@"position",  nil] repeats:NO];
//					[[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
//					[arrTimers addObject:timer];
					
					[self performSelectorOnMainThread:@selector(putAnimalAtOriginPosition:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:btnAnimal, @"btnAnimal", [NSString stringWithFormat:@"%d",position],@"position",  nil] waitUntilDone:NO];
					break;
				case 3:
					[self setFrameOfAnimal:btnAnimal];
					[self enableButton:btnAnimal];
					[[btnAnimal layer] removeAllAnimations];
					break;
				case 4:
					[[btnAnimal layer] removeAllAnimations];
					[self jumpAnimalAtRandomPosition:btnAnimal];
					[self.view insertSubview:btnAnimal belowSubview:imgSlideView];
					break;
				case 5:
					[self setFrameOfAnimal:btnAnimal];
					[[btnAnimal layer] removeAllAnimations];
					//[self.view bringSubviewToFront:btnAnimal];
					[self.view insertSubview:btnAnimal belowSubview:imgSlideView];
					break;
                case 6:
				{
					NSLog(@"remove at index:- %i",position);
                    AnimateObjectView *imageView = [arrDragonFliesOnScreen objectAtIndex:position];
					
					AVAudioPlayer *dPlayer = [dicPlayers valueForKey:[NSString stringWithFormat:@"%i",imageView.ID]];
					if (dPlayer) {
						[dPlayer stop];
						[dPlayer release];
						dPlayer = nil;
						[dicPlayers removeObjectForKey:[NSString stringWithFormat:@"%i",imageView.ID]];
					}
					[imageView removeFromSuperview];
					[[imageView layer] removeAllAnimations];
					
				}
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
}
#pragma mark -
#pragma mark ACTIONS EVENT
-(IBAction)animalsTitleClicked:(id)sender{
	chestCount=0;
	[self removeAllAnimalsOnScreen];
	btnChest.userInteractionEnabled = TRUE;
	if (btnChest.tag==0) {
		flagChestClose = TRUE;
		[self playSoundEffect:@"chest_closes.mp3" withRepeatCount:0];
		[appDelegate setImage:[UIImage thumbnailImage:@"chestclosed.png"] ofButton:btnChest];
		btnChest.tag=1;
	}
	
	NSString *strSoundName = [NSString stringWithFormat:@"%@.mp3",[self getAnimalsTitleSoundName]];
	[self playSound:strSoundName];
}
-(IBAction)watermillClicked:(id)sender{
	[btnWatermill.imageView stopAnimating];
	[self playSoundEffect:@"watermill_fast.mp3" withRepeatCount:0];
	btnWatermill.imageView.animationDuration = WATERMILL_ANIMATION_DURATION/2;
	[btnWatermill.imageView startAnimating];
	timerRotateWatermill = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(rotateWatermillNormally) userInfo:nil repeats:NO];
	[[NSRunLoop mainRunLoop]addTimer:timerRotateWatermill forMode:NSRunLoopCommonModes];
}
-(void)animalClicked:(id)sender{
	UIButton *btnSelected = sender;
	CAAnimation *anim = [[btnSelected layer]animationForKey:@"moveAnimalAnimation"];
	if (!anim) {
		[self.view bringSubviewToFront:btnSelected];
		//btnSelected.enabled = FALSE;
		Objects *object = [arrObjects objectAtIndex:btnSelected.tag];
		NSString *strSoundName = [NSString stringWithFormat:[self getAnimalSoundName],object.SoundFileName];
		[self playVOSound:[NSString stringWithFormat:@"%@.mp3",strSoundName] withObject:object];
		
		[self playSoundEffect:@"animals_expand.mp3" withRepeatCount:0];
		
		[self performSelector:@selector(playAnimalSoundEffect:) withObject:object afterDelay:TRANSITION_ANIMATION+REMAIN_ANIMATION ];

		if ([dicAnimalTimer count]>0) {
			NSTimer *timer = [dicAnimalTimer valueForKey:[NSString stringWithFormat:@"%i",btnSelected.tag]];
			if (timer) {
				[timer invalidate];
				timer=nil;
				[dicAnimalTimer removeObjectForKey:[NSString stringWithFormat:@"%i",btnSelected.tag]];
			}
		}
		
		NSTimer *animalTimer = [NSTimer timerWithTimeInterval:0.00002 target:self selector:@selector(setFrameOfAnimalWithTimer:) userInfo:[NSDictionary dictionaryWithObject:btnSelected forKey:@"animal"] repeats:YES];
		[[NSRunLoop mainRunLoop]addTimer:animalTimer forMode:NSRunLoopCommonModes];
		[dicAnimalTimer setObject:animalTimer forKey:[NSString stringWithFormat:@"%i",btnSelected.tag]];
		
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
		CGPathAddLineToPoint(positionPath, NULL, self.view.center.x , self.view.center.y - (BOX_POSITION_LIMIT/3) );
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
		NSString *strPosition = [NSString stringWithFormat:@"%d,2", [arrAnimalsOnScreen indexOfObject:btnSelected]];
		[theGroup setValue:strPosition forKey:@"AnimationGroup"];
		[[btnSelected layer] addAnimation:theGroup forKey:@"AnimationGroup"];
		
		btnAnimationRunning = btnSelected;
		[CATransaction commit];
		
		CGPathRelease(positionPath);
	}
}
-(void)BtnChestEnable{
	btnChest.userInteractionEnabled = TRUE;
}
-(IBAction)chestClicked:(id)sender{
	[self.view bringSubviewToFront:btnChest];
	btnChest.userInteractionEnabled = FALSE;
	[self performSelector:@selector(BtnChestEnable) withObject:nil afterDelay:1];
	//if (chestCount==0) {
	//		btnChest.userInteractionEnabled = FALSE;
	//	}
	//	else {
	//		btnChest.userInteractionEnabled = TRUE;
	//	}
	
	chestCount++;
	if (btnChest.tag==1) {
		
		flagChestClose = FALSE;
		[self playSoundEffect:@"chest_opens.mp3" withRepeatCount:0];
		[appDelegate setImage:[UIImage thumbnailImage:@"chestopen.png"] ofButton:btnChest];
		if ([arrAnimalsOnScreen count]==0) {
			//NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(dynamicallyLoadImages) object:nil];
			//			[thread start];
			//[self dynamicallyLoadImages];
			//[self performSelectorInBackground:@selector(dynamicallyLoadImages) withObject:nil];
			NSTimer *loadTimer = [NSTimer timerWithTimeInterval:0 target:self selector:@selector(dynamicallyLoadImages) userInfo:nil repeats:NO];
			[[NSRunLoop mainRunLoop] addTimer:loadTimer forMode:NSRunLoopCommonModes];
			[self playSoundEffect:@"musical_pop.mp3" withRepeatCount:0];
		}
		else {
			//[self addDragonFliesToScreen];
			NSTimer *loadTimer = [NSTimer timerWithTimeInterval:0 target:self selector:@selector(addDragonFliesToScreen) userInfo:nil repeats:NO];
			[[NSRunLoop mainRunLoop] addTimer:loadTimer forMode:NSRunLoopCommonModes];
		}
		btnChest.tag=0;
		
		
	}
	else {
		//btnChest.userInteractionEnabled = TRUE;
		flagChestClose = TRUE;
		[self playSoundEffect:@"chest_closes.mp3" withRepeatCount:0];
		[appDelegate setImage:[UIImage thumbnailImage:@"chestclosed.png"] ofButton:btnChest];
		btnChest.tag=1;
	}
}
-(IBAction)back:(id)sender{
	NSLog(@"back button clicked");
	[UIImage clearThumbnailCache];
	[self removeAllAnimalsOnScreen];
	[self.navigationController popViewControllerAnimated:YES];
}
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

-(void)transformAnimal:(UIButton *)btnAnimal
{
	if ([dicAnimalTimer count]>0) {
		NSTimer *timer = [dicAnimalTimer valueForKey:[NSString stringWithFormat:@"%i",btnAnimal.tag]];
		if (timer) {
			[timer invalidate];
			timer=nil;
			[dicAnimalTimer removeObjectForKey:[NSString stringWithFormat:@"%i",btnAnimal.tag]];
		}
	}
	
	NSTimer *animalTimer = [NSTimer timerWithTimeInterval:0.00002 target:self selector:@selector(setFrameOfAnimalWithTimer:) userInfo:[NSDictionary dictionaryWithObject:btnAnimal forKey:@"animal"] repeats:YES];
	[[NSRunLoop mainRunLoop]addTimer:animalTimer forMode:NSRunLoopCommonModes];
	[dicAnimalTimer setObject:animalTimer forKey:[NSString stringWithFormat:@"%i",btnAnimal.tag]];
	
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:TRANSITION_ANIMATION] forKey:kCATransactionAnimationDuration];
	
	CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	CGMutablePathRef positionPath = CGPathCreateMutable();
	CGPathMoveToPoint(positionPath, NULL, btnChest.center.x ,  btnChest.center.y-70 );
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
	int position = [arrAnimalsOnScreen indexOfObject:btnAnimal];
	NSString *strPosition = [NSString stringWithFormat:@"%d,0",position];
	[theGroup setValue:strPosition forKey:@"AnimationGroup"];
	[[btnAnimal layer] addAnimation:theGroup forKey:@"AnimationGroup"];
	
	[CATransaction commit];
	
	CGPathRelease(positionPath);
}
-(void)loadButtonFromObject:(Objects *)object
{
	int startX=0,startY=0;
	CGRect frame =  CGRectMake(startX, startY, ANIMAL_WIDTH, ANIMAL_HEIGHT);
	UIButton *btnImage = [UIButton buttonWithType:UIButtonTypeCustom];
	NSString *imageName = [NSString stringWithFormat:[self getAnimalGraphicName],object.ImageName];
	[appDelegate setImage:[UIImage thumbnailImage:[NSString stringWithFormat:@"%@.png",imageName]] ofButton:btnImage];
	[btnImage addTarget:self action:@selector(animal:didStartDrag:) forControlEvents:UIControlEventTouchDragInside | UIControlEventTouchDragOutside];
	[btnImage addTarget:self action:@selector(animal:didEndDrag:) forControlEvents:UIControlEventTouchDragExit|UIControlEventTouchCancel|UIControlEventTouchUpOutside | UIControlEventTouchUpInside];
	btnImage.imageView.contentMode = UIViewContentModeScaleAspectFill;
	//btnImage.userInteractionEnabled = FALSE;
	btnImage.frame =frame;
	btnImage.tag = [arrObjects indexOfObject:object];
	btnAnimationRunning = btnImage;
	[self.view addSubview:btnImage];
	[arrAnimalsOnScreen addObject:btnImage];
	[self performSelectorOnMainThread:@selector(transformAnimal:) withObject:btnImage waitUntilDone:YES];
	//[self transformAnimal:btnImage];
}
#pragma mark -
#pragma mark DYNAMICALLY LOAD IMAGES
-(void)dynamicallyLoadImages
{
	for (int i=0; i<[arrObjects count]; i++) {
		Objects *object = [arrObjects objectAtIndex:i];
		[self loadButtonFromObject:object];
	}
	//[self performSelector:@selector(addDragonFliesToScreen) withObject:nil afterDelay:3];
	//[self addDragonFliesToScreen];
}

#pragma mark -
#pragma mark LOAD FISHES
-(void)loadFishesForLeft
{
	NSArray *arrFishes = [NSLocalizedString(@"appFishLeftGrpahicLibrary",nil) componentsSeparatedByString:@","];
	for (int i=0; i<MAX_FISHES ; i++) {
		int position = arc4random() % [arrFishes count];
		NSString *imageName = [arrFishes objectAtIndex:position];
		AnimateObjectView *viewFish = [[AnimateObjectView alloc]initWithImage:[UIImage thumbnailImage:imageName]];
		viewFish.imageName = imageName;
		viewFish.ID = i;
		viewFish.isLeft = TRUE;
		viewFish.delegate = self;
		viewFish.hidden = TRUE;
		viewFish.userInteractionEnabled = TRUE;
		int startXPosition = 0, endXPosition = 0, startYPosition=0, endYPosition = 0;
		
		//viewFish.tag = 1;
		startXPosition = arc4random() % (int)self.view.frame.size.width;
		endXPosition = (self.view.frame.size.width+ viewFish.frame.size.width+30);
		startYPosition = (self.view.frame.size.height-20);
		endYPosition=self.view.frame.size.height-150;
		
		if (startXPosition<=10) {
			startXPosition = 30;
			startYPosition = self.view.frame.size.height+10;
		}
		
		int fishMoveDuration = FISH_MOVE_ANIMATION_DURATION;
		viewFish.duration = fishMoveDuration;
		viewFish.frame = CGRectMake(startXPosition, startYPosition, FISH_WIDTH, FISH_HEIGHT);
		[self.view addSubview:viewFish];
		
		float randomDuration = arc4random()%MAX_TIME_REST;
		NSTimer *timerMoveFish = [NSTimer scheduledTimerWithTimeInterval:randomDuration target:self selector:@selector(moveFishToLeft:) userInfo:[NSDictionary dictionaryWithObjectsAndKeys:viewFish,@"Fish",[NSString stringWithFormat:@"%d,%d,%d,%d",startXPosition, endXPosition, startYPosition, endYPosition],@"Point",nil] repeats:NO];
		[[NSRunLoop mainRunLoop] addTimer:timerMoveFish forMode:NSRunLoopCommonModes];
		
		[viewFish release];
	}
}

-(void)loadFishesForRight
{
	NSArray *arrFishes = [NSLocalizedString(@"appFishRightGrpahicLibrary",nil) componentsSeparatedByString:@","];
	for (int i=0; i<MAX_FISHES ; i++) {
		int position = arc4random() % [arrFishes count];
		NSString *imageName = [arrFishes objectAtIndex:position];
		AnimateObjectView *viewFish = [[AnimateObjectView alloc]initWithImage:[UIImage thumbnailImage:imageName]];
		viewFish.imageName = imageName;
		viewFish.ID = i+MAX_FISHES;
		viewFish.isLeft = FALSE;
		viewFish.delegate = self;
		viewFish.hidden = TRUE;
		viewFish.userInteractionEnabled = TRUE;
		int startXPosition = 0, endXPosition = 0, startYPosition=0, endYPosition = 0;
		
		//viewFish.tag = 0;
		startXPosition = self.view.frame.size.width;
		endXPosition = -self.view.frame.size.width;
		startYPosition = (self.view.frame.size.height-135) + (arc4random() % 135);
		endYPosition=self.view.frame.size.height+150;
		
		int fishMoveDuration = FISH_MOVE_ANIMATION_DURATION;
		viewFish.duration = fishMoveDuration;
		viewFish.frame = CGRectMake(startXPosition, startYPosition, FISH_WIDTH, FISH_HEIGHT);
		[self.view addSubview:viewFish];
		
		float randomDuration = arc4random()%MAX_TIME_REST;
		NSTimer *timerMoveFish = [NSTimer scheduledTimerWithTimeInterval:randomDuration target:self selector:@selector(moveFishToRight:) userInfo:[NSDictionary dictionaryWithObjectsAndKeys:viewFish,@"Fish",[NSString stringWithFormat:@"%d,%d,%d,%d",startXPosition, endXPosition, startYPosition, endYPosition],@"Point",nil] repeats:NO];
		[[NSRunLoop mainRunLoop] addTimer:timerMoveFish forMode:NSRunLoopCommonModes];
		[viewFish release];
	}
}
#pragma mark -
#pragma mark VIEW EVENTS
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	index = 0;
	chestCount=0;
	resourcePath = [[[NSBundle mainBundle]resourcePath] retain];
	dicPlayers = [[NSMutableDictionary alloc]init];
	arrAnimalsOnScreen = [[NSMutableArray alloc]init];
	arrTimers = [[NSMutableArray alloc]init];
	fishTimers = [[NSMutableDictionary alloc]init];
    arrDragonFliesOnScreen = [[NSMutableArray alloc]init];
	dicDragonTimer = [[NSMutableDictionary alloc] init];
	dicAnimalTimer = [[NSMutableDictionary alloc] init];
	dicCenterPoint = [[NSMutableDictionary alloc] init];
	
	NSArray *arrImages = [NSArray arrayWithObjects:
						  [UIImage thumbnailImage:@"watermill001.png"],
						  [UIImage thumbnailImage:@"watermill002.png"],
						  [UIImage thumbnailImage:@"watermill003.png"],
						  [UIImage thumbnailImage:@"watermill004.png"],
						  [UIImage thumbnailImage:@"watermill005.png"],nil];
	
	[btnWatermill setImage:[UIImage thumbnailImage:@"watermill001.png"] forState:UIControlStateNormal];
	[btnWatermill setImage:[UIImage thumbnailImage:@"watermill001.png"] forState:UIControlStateHighlighted];
	[btnWatermill setImage:[UIImage thumbnailImage:@"watermill001.png"] forState:UIControlStateSelected];
	[btnWatermill setImage:[UIImage thumbnailImage:@"watermill001.png"] forState:UIControlStateDisabled];
	
	btnWatermill.imageView.animationImages = arrImages;
	btnWatermill.imageView.animationRepeatCount=-1;
	btnWatermill.imageView.contentMode = UIViewContentModeScaleToFill;
	btnWatermill.imageView.animationDuration = WATERMILL_ANIMATION_DURATION;
	[btnWatermill.imageView startAnimating];
	[self playSoundEffect:@"effect_watermill.mp3" withRepeatCount:0];
	
	[appDelegate setImage:[UIImage thumbnailImage:@"chestclosed.png"] ofButton:btnChest];
	[btnChest addTarget:self action:@selector(chest:didStartDrag:) forControlEvents:UIControlEventTouchDragInside | UIControlEventTouchDragOutside];
	[btnChest addTarget:self action:@selector(chest:didEndDrag:) forControlEvents:UIControlEventTouchDragExit|UIControlEventTouchCancel|UIControlEventTouchUpOutside | UIControlEventTouchUpInside];
	
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
	btnChest.tag=1;
	@try {
		isViewAppeared = TRUE;
		[appDelegate playSound:@"AnimalsBackground.mp3"];
		NSString *strAnimalsTitleName = [NSString stringWithFormat:@"%@.png",[self getAnimalsTitleGraphicName]];
		[appDelegate setImage:[UIImage thumbnailImage:strAnimalsTitleName] ofButton:btnAnimalsTitle];
		NSString *strSoundName = [NSString stringWithFormat:@"%@.mp3",[self getAnimalsTitleSoundName]];
		[self playSound:strSoundName];
		
		[self loadFishesForLeft];
		[self loadFishesForRight];
		[self.view bringSubviewToFront:imgTopBackgroundView];
		[self.view bringSubviewToFront:btnAnimalsTitle];
	}
	@catch (NSException * e) {
	}
	@finally {
	}
	[self.view bringSubviewToFront:btnAnimalsTitle];

}
-(void)viewWillDisappear:(BOOL)animated{
	[UIImage clearThumbnailCache];
	[self removeAllAnimalsOnScreen];
	[self removeAllTimers];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait ||
			interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
	NSLog(@"---------------------------------Receive memory warnning---------------------------------");
	
	[UIImage clearThumbnailCache];
	[self removeAllAnimalsOnScreen];
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
	[dicCenterPoint release];
	[dicAnimalTimer release];
	[imgBackgroundView release];
	[imgTopBackgroundView release];
	[imgWatermillBackgroundView release];
	[imgSlideView release];
	[btnWatermill release];
	[btnChest release];
	[btnAnimalsTitle release];
	[btnBack release];
	[arrObjects removeAllObjects];
	[arrObjects release];
	[arrTimers removeAllObjects];
	[arrTimers release];
	[arrAnimalsOnScreen removeAllObjects];
	[arrAnimalsOnScreen release];
    
    [arrDragonFliesOnScreen removeAllObjects];
    [arrDragonFliesOnScreen release];
	
	[resourcePath release];
	
	[dicPlayers removeAllObjects];
	[dicPlayers release];
	
	[fishTimers removeAllObjects];
	[fishTimers release];
	
    [super dealloc];
}


@end
