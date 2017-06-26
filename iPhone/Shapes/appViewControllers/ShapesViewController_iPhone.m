//
//  ShapesViewController_iPhone.m
//  PreSchool
//
//  Created by Acai on 27/01/11.
//  Copyright 2011 Aca Technologies. All rights reserved.
//

#import "ShapesViewController_iPhone.h"


@implementation ShapesViewController_iPhone

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
#pragma mark SET FRAME OF BIG SHAPE
-(void)setFrameOfShapeWithTimer:(NSTimer *)Timer
{
	NSLog(@"setShapeFrame");
	UIButton *btnShape = [[Timer userInfo] valueForKey:@"shape"];
	CGRect frame =[[[btnShape layer]presentationLayer] frame];
	CGFloat xPositon = frame.origin.x+frame.size.width/2;
	CGFloat yPosition = frame.origin.y+frame.size.height/2;
	//NSLog(@"current position of button:- %f %f and width is:- %f %f and original size is:- %f %f",frame.origin.x, frame.origin.y,frame.size.width,frame.size.height,btnShape.frame.size.width,btnShape.frame.size.height);
	//btnShape.frame = CGRectMake(frame.origin.x, frame.origin.y, btnShape.frame.size.width, btnShape.frame.size.height);
	btnShape.center = CGPointMake(xPositon, yPosition);
}

-(void)setFrameOfShape:(UIButton *)btnBigShape
{
	CGRect frame =[[[btnBigShape layer] presentationLayer] frame];
	btnBigShape.frame = frame;
}
-(void)enableButton:(UIButton *)btnShape
{
	btnShape.enabled = TRUE;
}
-(void)putShapeAtOriginPositionInMainThread:(NSDictionary*)btnDictionary{
	UIButton *btnShape = [btnDictionary objectForKey:@"btnShape"];
	btnShape.enabled = TRUE;
	int  position= [[btnDictionary objectForKey:@"position"]intValue];
	//CGPoint shapePosition = btnShape.center;
	CGFloat xPosition = [[[dicCenterPoint objectForKey:[NSString stringWithFormat:@"%i",btnShape.tag]] objectAtIndex:0]floatValue];
	CGFloat yPosition = [[[dicCenterPoint objectForKey:[NSString stringWithFormat:@"%i",btnShape.tag]] objectAtIndex:1]floatValue];
	btnShape.center = self.view.center;
	
	[self playSoundEffect:@"shapes_collapse.mp3" withRepeatCount:0];
	
	if ([dicShapeTimer count]>0) {
		NSTimer *timer = [dicShapeTimer valueForKey:[NSString stringWithFormat:@"%i",btnShape.tag]];
		if (timer) {
			[timer invalidate];
			timer=nil;
			[dicShapeTimer removeObjectForKey:[NSString stringWithFormat:@"%i",btnShape.tag]];
		}
	}
	NSTimer *shapeTimer = [NSTimer timerWithTimeInterval:0.00002 target:self selector:@selector(setFrameOfShapeWithTimer:) userInfo:[NSDictionary dictionaryWithObject:btnShape forKey:@"shape"] repeats:YES];
	[[NSRunLoop mainRunLoop]addTimer:shapeTimer forMode:NSRunLoopCommonModes];
	[dicShapeTimer setObject:shapeTimer forKey:[NSString stringWithFormat:@"%i",btnShape.tag]];
	
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:TRANSITION_ANIMATION] forKey:kCATransactionAnimationDuration];
	
	CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	CGMutablePathRef positionPath = CGPathCreateMutable();
	CGPathMoveToPoint(positionPath, NULL, self.view.center.x , self.view.center.y- (BOX_POSITION_LIMIT/3));
	CGPathAddLineToPoint(positionPath, NULL, xPosition ,  yPosition);
	positionAnimation.path = positionPath;
	
	//CABasicAnimation *shrinkAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//	shrinkAnimation.fromValue = [NSNumber numberWithFloat:kScaleFactor];
//	shrinkAnimation.toValue = [NSNumber numberWithFloat:1.0f];
	
	CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
	rotateAnimation.fromValue = [NSNumber numberWithFloat:2.0];
	rotateAnimation.toValue = [NSNumber numberWithFloat:0.0];
	
	CAAnimationGroup *theGroup = [CAAnimationGroup animation];
	theGroup.delegate = self;
	theGroup.removedOnCompletion = NO;
	theGroup.fillMode = kCAFillModeForwards;
	theGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	theGroup.animations = [NSArray arrayWithObjects:positionAnimation,rotateAnimation,nil];
	NSString *strPosition = [NSString stringWithFormat:@"%d,3", position];
	[theGroup setValue:strPosition forKey:@"AnimationGroup"];
	[[btnShape layer] addAnimation:theGroup forKey:@"AnimationGroup"];
	
	[CATransaction commit];
	
	CGPathRelease(positionPath);
	
	//[arrTimers removeObject:timer];
	
}
-(void)putShapeAtOriginPosition:(NSDictionary *)btnDictionary
{
	[self performSelector:@selector(putShapeAtOriginPositionInMainThread:) withObject:btnDictionary afterDelay:REMAIN_ANIMATION];	

}
//-(void)putShapeOnScreenInMainThread:(NSDictionary*)btnDictionary{
//	UIButton *btnBigShape = [btnDictionary objectForKey:@"btnShape"];
//	int position = [[btnDictionary objectForKey:@"position"]intValue];
//	[self playSoundEffect:@"shapes_collapse.mp3" withRepeatCount:0];
//	
//	float randomX = arc4random()%(int)self.view.center.x;
//	float randomY = arc4random()%(int)self.view.center.y;
//	
//	float directionRandomX = arc4random()% (int)self.view.center.x;
//	float directionRandomY = arc4random()% (int)self.view.center.y;
//	
//	float valueX = 1*(randomX/kNoOfJumps);
//	if (randomX<directionRandomX) {
//		valueX = -1*(randomX/kNoOfJumps);
//	}
//	float valueY = 1*(randomY/kNoOfJumps);
//	if (randomY<directionRandomY) {
//		valueY = -1*(randomY/kNoOfJumps);
//	}
//	
//	// make it jump a couple of times
//	CGMutablePathRef thePath = CGPathCreateMutable();
//	CGPathMoveToPoint(thePath, NULL, self.view.center.x, self.view.center.y- (BOX_POSITION_LIMIT/3));
//	CGPoint point1,point2;
//	for (int i=0; i<kNoOfJumps; i++) {
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
//	
//	if ([dicShapeTimer count]>0) {
//		NSTimer *timer = [dicShapeTimer valueForKey:[NSString stringWithFormat:@"%i",btnBigShape.tag]];
//		if (timer) {
//			[timer invalidate];
//			timer=nil;
//			[dicShapeTimer removeObjectForKey:[NSString stringWithFormat:@"%i",btnBigShape.tag]];
//		}
//	}
//	
//	NSTimer *shapeTimer = [NSTimer timerWithTimeInterval:0.00002 target:self selector:@selector(setFrameOfShapeWithTimer:) userInfo:[NSDictionary dictionaryWithObject:btnBigShape forKey:@"shape"] repeats:YES];
//	[[NSRunLoop mainRunLoop]addTimer:shapeTimer forMode:NSRunLoopCommonModes];
//	[dicShapeTimer setObject:shapeTimer forKey:[NSString stringWithFormat:@"%i",btnBigShape.tag]];
//	
//	[CATransaction begin];
//	[CATransaction setValue:[NSNumber numberWithFloat:TRANSITION_ANIMATION] forKey:kCATransactionAnimationDuration];
//	
//	CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//	positionAnimation.path = thePath;
//	positionAnimation.calculationMode = kCAAnimationPaced;
//	
//	// scale it down
//	CABasicAnimation *shrinkAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//	shrinkAnimation.fromValue = [NSNumber numberWithFloat:kScaleFactor];
//	shrinkAnimation.toValue = [NSNumber numberWithFloat:1.0];
//	
//	CAAnimationGroup *theGroup = [CAAnimationGroup animation];
//	theGroup.delegate = self;
//	theGroup.removedOnCompletion = NO;
//	theGroup.fillMode = kCAFillModeForwards;
//	theGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//	theGroup.animations = [NSArray arrayWithObjects:positionAnimation, shrinkAnimation,nil];
//	NSString *strPosition = [NSString stringWithFormat:@"%d,1",position];
//	[theGroup setValue:strPosition forKey:@"AnimationGroup"];
//	[[btnBigShape layer] addAnimation:theGroup forKey:@"AnimationGroup"];
//	
//	[CATransaction commit];
//	
//	CGPathRelease(thePath);
//	
//	
//}
//-(void)putShapeOnScreen:(NSDictionary *)btnDictionary
//{
//	[self performSelector:@selector(putShapeOnScreenInMainThread:) withObject:btnDictionary afterDelay:REMAIN_ANIMATION];	
//}
#pragma mark -
#pragma mark REMOVE ALL GRAPHICS ON SCREEN
-(void)removeAllAudioPlayers
{
	[dicCenterPoint removeAllObjects];
	if ([dicShapeTimer count]>0) {
		for (int i=0; i<[dicShapeTimer count]; i++) {
			NSTimer *timer = [dicShapeTimer objectForKey:[[dicShapeTimer allKeys]objectAtIndex:i]];
			if (timer) {
				[timer invalidate];
				timer = nil;
			}
		}
		[dicShapeTimer removeAllObjects];
	}
	
	for (int i=0; i<[dicPlayers count]; i++) {
		AVAudioPlayer *avPlayer= [dicPlayers objectForKey:[[dicPlayers allKeys]objectAtIndex:i]];
		[avPlayer stop];
		[avPlayer release];
	}
	[dicPlayers removeAllObjects];
}
-(void)removeAllShapesOnScreen
{

	[self removeAllAudioPlayers];
	for (int i=0; i<[arrTimers count]; i++) {
		NSTimer *timer = [arrTimers objectAtIndex:i];
		if ([timer isValid]) {
			[timer invalidate];
		}
	}
	[arrTimers removeAllObjects];
	
	for (int i=0; i<[arrShapesOnScreen count]; i++) {
		UIButton *btnShape = [arrShapesOnScreen objectAtIndex:i];
		[[btnShape layer] removeAllAnimations];
		[btnShape removeFromSuperview];
	}
	[arrShapesOnScreen removeAllObjects];
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
			UIButton *btnShape = [arrShapesOnScreen objectAtIndex:position];
			if ([dicShapeTimer count]>0) {
				NSTimer *timer = [dicShapeTimer valueForKey:[NSString stringWithFormat:@"%i",btnShape.tag]];
				if (timer) {
					[timer invalidate];
					timer=nil;
					[dicShapeTimer removeObjectForKey:[NSString stringWithFormat:@"%i",btnShape.tag]];
				}
			}
			//NSTimer *timer = nil;
			switch (animSequence) {
				case 0:
					[[btnShape layer] removeAllAnimations];
					//[self performSelectorOnMainThread:@selector(putShapeOnScreen:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:btnShape, @"btnShape", [NSString stringWithFormat:@"%d",position],@"position",  nil] waitUntilDone:NO];
					
					break;
				case 1:
					[self setFrameOfShape:btnShape];
					[self enableButton:btnShape];
					[[btnShape layer] removeAllAnimations];
					break;
				case 2:
					btnShape.tag = btnShape.tag/100;
					//timer = [NSTimer scheduledTimerWithTimeInterval:REMAIN_ANIMATION target:self selector:@selector(putShapeAtOriginPosition:) userInfo:[NSDictionary dictionaryWithObjectsAndKeys:btnShape, @"btnShape", [NSString stringWithFormat:@"%d",position],@"position",  nil] repeats:NO];
//					[[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
//					[arrTimers addObject:timer];
					
					//[self performSelectorOnMainThread:@selector(putShapeAtOriginPosition:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:btnShape, @"btnShape", [NSString stringWithFormat:@"%d",position],@"position",  nil] waitUntilDone:NO];
					break;
				case 3:
					[self setFrameOfShape:btnShape];
					[self enableButton:btnShape];
					[[btnShape layer] removeAllAnimations];
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
	if ([[anim valueForKey:@"rotate"] isEqualToString:@"star"]) {
		[self performSelector:@selector(rotateStar)];
	}
	else if([[anim valueForKey:@"rotate"] isEqualToString:@"trangle"]){
		[self performSelector:@selector(rotateTrangle)];
	}
	else if([[anim valueForKey:@"rotate"] isEqualToString:@"starFinal"]){
		btnStar.tag=1;
	}
	else if([[anim valueForKey:@"rotate"] isEqualToString:@"trangleFinal"]){
		btnTrangle.tag=1;
	}
	
}
#pragma mark -
#pragma mark IB ACTIONS
-(IBAction)back:(id)sender
{
	[UIImage clearThumbnailCache];
	[self removeAllShapesOnScreen];
	for (int i=0; i<[arrViews count]; i++) {
		UIView *v = [arrViews objectAtIndex:i];
		[v removeFromSuperview];
	}
	[arrViews removeAllObjects];
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)rotateStar{
	
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:GRAPHIC_MOVE_DURATION*1.5] forKey:kCATransactionAnimationDuration];
	
	CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
	rotateAnimation.removedOnCompletion = NO;
	rotateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	rotateAnimation.fillMode = kCAFillModeForwards;
	rotateAnimation.delegate = self;
	rotateAnimation.fromValue = [NSNumber numberWithFloat:2];
	rotateAnimation.toValue = [NSNumber  numberWithFloat:6.3];
	[rotateAnimation setValue:@"starFinal" forKey:@"rotate"];
	[[btnStar layer] addAnimation:rotateAnimation forKey:@"rotate"];
	[CATransaction commit];
	
}
-(void)rotateTrangle{
	
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:GRAPHIC_MOVE_DURATION*1.5] forKey:kCATransactionAnimationDuration];

	CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
	rotateAnimation.removedOnCompletion = NO;
	rotateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	rotateAnimation.fillMode = kCAFillModeForwards;
	rotateAnimation.delegate=self;
	rotateAnimation.fromValue = [NSNumber numberWithFloat:2];
	rotateAnimation.toValue = [NSNumber  numberWithFloat:6.3];
	[rotateAnimation setValue:@"trangleFinal" forKey:@"rotate"];
	[[btnTrangle layer] addAnimation:rotateAnimation forKey:@"finalrotate"];
	[CATransaction commit];
}

-(IBAction)clickOnTrangleGraphic:(id)sender{
	if (btnTrangle.tag==100) {
		[[btnTrangle layer] removeAllAnimations];
		btnTrangle.tag=1;
	}
	else {
		[self playSoundEffect:@"spinning.mp3" withRepeatCount:0];
		[CATransaction begin];
		[CATransaction setValue:[NSNumber numberWithFloat:GRAPHIC_MOVE_DURATION/2] forKey:kCATransactionAnimationDuration];
		btnTrangle.tag=100;
		
		CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
		rotateAnimation.removedOnCompletion = NO;
		rotateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
		rotateAnimation.fillMode = kCAFillModeForwards;
		rotateAnimation.delegate = self;
		rotateAnimation.fromValue = [NSNumber numberWithFloat:0.0];
		rotateAnimation.toValue = [NSNumber  numberWithFloat:2];
		[rotateAnimation setValue:@"trangle" forKey:@"rotate"];
		[[btnTrangle layer] addAnimation:rotateAnimation forKey:@"rotate"];
		[CATransaction commit];
		
	}
		
}
-(IBAction)clickOnStarGraphic:(id)sender{
	if (btnStar.tag==100) {
		[[btnStar layer] removeAllAnimations];
		btnStar.tag=1;
	}
	else {
		[self playSoundEffect:@"spinning.mp3" withRepeatCount:0];
		[CATransaction begin];
		[CATransaction setValue:[NSNumber numberWithFloat:GRAPHIC_MOVE_DURATION/2] forKey:kCATransactionAnimationDuration];
		btnStar.tag=100;
		CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
		rotateAnimation.removedOnCompletion = NO;
		rotateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
		rotateAnimation.fillMode = kCAFillModeForwards;
		rotateAnimation.delegate = self;
		rotateAnimation.fromValue = [NSNumber numberWithFloat:0.0];
		rotateAnimation.toValue = [NSNumber  numberWithFloat:2];
		[rotateAnimation setValue:@"star" forKey:@"rotate"];
		[[btnStar layer] addAnimation:rotateAnimation forKey:@"rotate"];
		[CATransaction commit];
	}

}

-(IBAction)shapesTitleClicked:(id)sender
{
	[self removeAllShapesOnScreen];
	NSString *strSoundName = [NSString stringWithFormat:@"%@.mp3",[self getShapesTitleSoundName]];
	[self playSound:strSoundName];
}
-(IBAction)shapeClicked:(id)sender
{
	UIButton *btnSelected = sender;
	if (btnSelected.tag>=100) {
		[[btnSelected layer] removeAllAnimations];
		btnSelected.tag = btnSelected.tag/100;
	}
	else {
		CAAnimation *anim = [[btnSelected layer]animationForKey:@"moveShapeAnimation"];
		if (!anim) {
			[self.view bringSubviewToFront:btnSelected];
			//btnSelected.enabled = FALSE;
			Objects *object = [arrObjects objectAtIndex:btnSelected.tag];
			NSString *strSoundName = [NSString stringWithFormat:[self getShapeSoundName],object.ImageName];
			[self playSound:[NSString stringWithFormat:@"%@.mp3",strSoundName]];
			[self playSoundEffect:@"spinning.mp3" withRepeatCount:0];
			
			//if ([dicShapeTimer count]>0) {
//				NSTimer *timer = [dicShapeTimer valueForKey:[NSString stringWithFormat:@"%i",btnSelected.tag]];
//				if (timer) {
//					[timer invalidate];
//					timer=nil;
//					[dicShapeTimer removeObjectForKey:[NSString stringWithFormat:@"%i",btnSelected.tag]];
//				}
//			}
//			
//			NSTimer *shapeTimer = [NSTimer timerWithTimeInterval:0.00002 target:self selector:@selector(setFrameOfShapeWithTimer:) userInfo:[NSDictionary dictionaryWithObject:btnSelected forKey:@"shape"] repeats:YES];
//			[[NSRunLoop mainRunLoop]addTimer:shapeTimer forMode:NSRunLoopCommonModes];
//			[dicShapeTimer setObject:shapeTimer forKey:[NSString stringWithFormat:@"%i",btnSelected.tag]];
//			NSMutableArray *arrPoint = [[NSMutableArray alloc] init];
//			[arrPoint addObject:[NSString stringWithFormat:@"%f",btnSelected.center.x]];
//			[arrPoint addObject:[NSString stringWithFormat:@"%f",btnSelected.center.y]];
//			[dicCenterPoint setObject:arrPoint forKey:[NSString stringWithFormat:@"%i",btnSelected.tag]];
//			[arrPoint release];
			[CATransaction begin];
			[CATransaction setValue:[NSNumber numberWithFloat:TRANSITION_ANIMATION*2] forKey:kCATransactionAnimationDuration];
			
			//CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
			//		CGMutablePathRef positionPath = CGPathCreateMutable();
			//		CGPathMoveToPoint(positionPath, NULL, btnSelected.center.x ,  btnSelected.center.y );
			//		CGPathAddLineToPoint(positionPath, NULL, self.view.center.x , self.view.center.y - (BOX_POSITION_LIMIT/3) );
			//		positionAnimation.path = positionPath;
			
			//CABasicAnimation *shrinkAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
			//		shrinkAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
			//		shrinkAnimation.toValue = [NSNumber numberWithFloat:kScaleFactor];
			
			CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
			rotateAnimation.fromValue = [NSNumber numberWithFloat:0.0];
			rotateAnimation.toValue = [NSNumber numberWithFloat:6.3];
			
			CAAnimationGroup *theGroup = [CAAnimationGroup animation];
			theGroup.delegate = self;
			theGroup.removedOnCompletion = NO;
			theGroup.fillMode = kCAFillModeForwards;
			theGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
			theGroup.animations = [NSArray arrayWithObjects:rotateAnimation,nil];
			NSString *strPosition = [NSString stringWithFormat:@"%d,2", [arrShapesOnScreen indexOfObject:btnSelected]];
			[theGroup setValue:strPosition forKey:@"AnimationGroup"];
			[[btnSelected layer] addAnimation:theGroup forKey:@"AnimationGroup"];
			btnSelected.tag = btnSelected.tag*100;
			btnAnimationRunning = btnSelected;
			[CATransaction commit];
			
			//CGPathRelease(positionPath);
		}
		
	}

}

-(IBAction)smallShapeClicked:(id)sender
{	
	if (dragCount==0) {
		UIButton *btnSelected= sender;
		Objects *object = [arrObjects objectAtIndex:btnSelected.tag];
		NSString *strSoundName = [NSString stringWithFormat:[self getShapeSoundName],object.ImageName];
		[self playSound:[NSString stringWithFormat:@"%@.mp3",strSoundName]];
		[self playSoundEffect:@"shapes_expand.mp3" withRepeatCount:0];
		
		UIImage *image = btnSelected.currentImage;
		if (image==nil) {
			image = btnSelected.currentBackgroundImage;
		}
		
		UIButton *btnBigShape = [UIButton buttonWithType:UIButtonTypeCustom];
		//btnBigShape.enabled = FALSE;
		//btnBigShape.frame = CGRectMake((self.view.frame.size.width- BIG_BUTTON_WIDTH)/2, self.view.frame.size.height , BIG_BUTTON_WIDTH, BIG_BUTTON_HEIGHT);
		btnBigShape.frame = CGRectMake(btnSelected.frame.origin.x-(BUTTON_WIDTH/2), btnSelected.frame.origin.y-BUTTON_HEIGHT-10, BIG_BUTTON_WIDTH, BIG_BUTTON_HEIGHT);
		[btnBigShape addTarget:self action:@selector(shape:didStartDrag:) forControlEvents:UIControlEventTouchDragInside | UIControlEventTouchDragOutside];
		[btnBigShape addTarget:self action:@selector(shape:didEndDrag:) forControlEvents:UIControlEventTouchDragExit|UIControlEventTouchCancel|UIControlEventTouchUpOutside | UIControlEventTouchUpInside];
		
		btnBigShape.tag = btnSelected.tag;
		[appDelegate setImage:image ofButton:btnBigShape];
		
		[self.view addSubview:btnBigShape];
		[arrShapesOnScreen addObject:btnBigShape];
		
		//[self.view bringSubviewToFront:btnSelected];
		
		if ([dicShapeTimer count]>0) {
			NSTimer *timer = [dicShapeTimer valueForKey:[NSString stringWithFormat:@"%i",btnBigShape.tag]];
			if (timer) {
				[timer invalidate];
				timer=nil;
				[dicShapeTimer removeObjectForKey:[NSString stringWithFormat:@"%i",btnBigShape.tag]];
			}
		}
		
		NSTimer *shapeTimer = [NSTimer timerWithTimeInterval:0.00002 target:self selector:@selector(setFrameOfShapeWithTimer:) userInfo:[NSDictionary dictionaryWithObject:btnBigShape forKey:@"shape"] repeats:YES];
		[[NSRunLoop mainRunLoop]addTimer:shapeTimer forMode:NSRunLoopCommonModes];
		[dicShapeTimer setObject:shapeTimer forKey:[NSString stringWithFormat:@"%i",btnBigShape.tag]];
		
		[CATransaction begin];
		[CATransaction setValue:[NSNumber numberWithFloat:TRANSITION_ANIMATION] forKey:kCATransactionAnimationDuration];
		
		CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
		CGMutablePathRef positionPath = CGPathCreateMutable();
		CGPathMoveToPoint(positionPath, NULL, btnBigShape.center.x ,  btnBigShape.center.y );
		CGPathAddLineToPoint(positionPath, NULL,self.view.center.x , self.view.center.y - (BOX_POSITION_LIMIT/3));
		positionAnimation.path = positionPath;
		
		//CABasicAnimation *shrinkAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//		shrinkAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
//		shrinkAnimation.toValue = [NSNumber numberWithFloat:kScaleFactor];
		
		CAAnimationGroup *theGroup = [CAAnimationGroup animation];
		theGroup.delegate = self;
		theGroup.removedOnCompletion = NO;
		theGroup.fillMode = kCAFillModeForwards;
		theGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
		theGroup.animations = [NSArray arrayWithObjects:positionAnimation,nil];
		int position = [arrShapesOnScreen indexOfObject:btnBigShape];
		NSString *strPosition = [NSString stringWithFormat:@"%d,0",position];
		[theGroup setValue:strPosition forKey:@"AnimationGroup"];
		[[btnBigShape layer] addAnimation:theGroup forKey:@"AnimationGroup"];
		
		btnAnimationRunning = btnBigShape;
		[CATransaction commit];
		
		CGPathRelease(positionPath);
	}
	dragCount=0;
	
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
#pragma mark DRAG EVENTS
- (void)shape:(UIButton *)shape didStartDrag:(UIEvent *)event
{
	dragFlag = YES;
	if ([dicShapeTimer count]>0) {
		NSTimer *timer = [dicShapeTimer valueForKey:[NSString stringWithFormat:@"%i",shape.tag]];
		if (timer) {
			[timer invalidate];
			timer=nil;
			[dicShapeTimer removeObjectForKey:[NSString stringWithFormat:@"%i",shape.tag]];
		}
	}
	
	if(shape == btnAnimationRunning){
		NSLog(@"Match");
		NSString *position = [NSString stringWithFormat:@"%d",[arrShapesOnScreen indexOfObject:shape]];
		//NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:fruit,@"",position,@"",nil];
		NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:shape, @"btnShape", position,@"position",  nil];
		[NSRunLoop cancelPreviousPerformRequestsWithTarget:self selector:@selector(putShapeOnScreenInMainThread:) object:dict];
		[NSRunLoop cancelPreviousPerformRequestsWithTarget:self selector:@selector(putShapeAtOriginPositionInMainThread:) object:dict];
	}
	
	
	[[shape layer] removeAllAnimations];
	UITouch *touch = [[event allTouches] anyObject];
	if (touch.phase == UITouchPhaseMoved) {
		if (!isMoving) {
			dragPlayer = [self playSoundDragEffect:@"DragLetter.mp3" withRepeatCount:-1];
		}
		isMoving = TRUE;
		CGPoint touchDownPoint = [touch locationInView:shape.superview];
		shape.center = touchDownPoint;
	}
}
- (void)shape:(UIButton *)shape didEndDrag:(UIEvent *)event
{
	[[shape layer] removeAllAnimations];
	if ([dicShapeTimer count]>0) {
		NSTimer *timer = [dicShapeTimer valueForKey:[NSString stringWithFormat:@"%i",shape.tag]];
		if (timer) {
			[timer invalidate];
			timer=nil;
			[dicShapeTimer removeObjectForKey:[NSString stringWithFormat:@"%i",shape.tag]];
		}
	}
	
	if (isMoving) {
		isMoving = FALSE;
		[self doVolumeFade:dragPlayer];
	}
	else {
		[self shapeClicked:shape];
	}
}

-(void)smallShape:(UIButton*)btnSelected didStartDrag:(UIEvent*)event{
	NSLog(@"did start darg");
	if (dragCount == 0) {
		
		Objects *object = [arrObjects objectAtIndex:btnSelected.tag];
		NSString *strSoundName = [NSString stringWithFormat:[self getShapeSoundName],object.ImageName];
		[self playSound:[NSString stringWithFormat:@"%@.mp3",strSoundName]];
		
		UIImage *image = btnSelected.currentImage;
		if (image==nil) {
			image = btnSelected.currentBackgroundImage;
		}
		
		UIButton *btnBigShape = [UIButton buttonWithType:UIButtonTypeCustom];
		//btnBigShape.enabled = FALSE;
		//btnBigShape.frame = CGRectMake((self.view.frame.size.width- BIG_BUTTON_WIDTH)/2, self.view.frame.size.height , BIG_BUTTON_WIDTH, BIG_BUTTON_HEIGHT);
		btnBigShape.frame = CGRectMake(btnSelected.frame.origin.x-(BUTTON_WIDTH/2), btnSelected.frame.origin.y-BUTTON_HEIGHT-10, BIG_BUTTON_WIDTH, BIG_BUTTON_HEIGHT);
		[btnBigShape addTarget:self action:@selector(shape:didStartDrag:) forControlEvents:UIControlEventTouchDragInside | UIControlEventTouchDragOutside];
		[btnBigShape addTarget:self action:@selector(shape:didEndDrag:) forControlEvents:UIControlEventTouchDragExit|UIControlEventTouchCancel|UIControlEventTouchUpOutside | UIControlEventTouchUpInside];
		
		btnBigShape.tag = btnSelected.tag;
		[appDelegate setImage:image ofButton:btnBigShape];
		
		[self.view addSubview:btnBigShape];
		[arrShapesOnScreen addObject:btnBigShape];
		
		
		
	}
	else {
		UIButton *btn = [arrShapesOnScreen lastObject];
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

-(void)smallShape:(UIButton*)fruiet didEndDrag:(UIEvent*)event{
	NSLog(@"didEnd drag");
	dragCount = 0;
	if (isMoving) {
		isMoving = FALSE;
		//[self doVolumeFade:dragPlayer];
		
	}
	dragCount = 0;
}



#pragma mark -
#pragma mark GET NAMES ACCORDING TO LANGUAGE SELECTION
-(NSString *)getShapesTitleSoundName
{
	NSString *soundName = NSLocalizedString(@"appShapesTitleSoundName",nil);
	@try {
		int value = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] intValue];
		switch (value) {
			case 0:
				soundName = NSLocalizedString(@"appShapesTitleSoundName",nil);
				break;
			case 1:
				soundName = @"shapestitle";
				break;
			case 2:
				soundName = @"shapestitle_spanish";
				break;
			case 3:
				soundName = @"shapestitle_french";
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
-(NSString *)getShapeSoundName
{
	NSString *soundName = NSLocalizedString(@"appShapeSoundName",nil);
	@try {
		int value = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] intValue];
		switch (value) {
			case 0:
				soundName = NSLocalizedString(@"appShapeSoundName",nil);
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
-(NSString *)getShapeGraphicName
{
	NSString *graphicName = NSLocalizedString(@"appShapeGraphicName",nil);
	@try {
		int value = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] intValue];
		switch (value) {
			case 0:
				graphicName = NSLocalizedString(@"appShapeGraphicName",nil);
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
-(NSString *)getShapesTitleGraphicName
{
	NSString *graphicName = NSLocalizedString(@"appShapesTitleGraphicName",nil);
	@try {
		int value = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] intValue];
		switch (value) {
			case 0:
				graphicName = NSLocalizedString(@"appShapesTitleGraphicName",nil);
				break;
			case 1:
				graphicName = @"shapestitle";
				break;
			case 2:
				graphicName = @"shapestitle_spanish";
				break;
			case 3:
				graphicName = @"shapestitle_french";
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
#pragma mark AUDIO PLAYER DELEGATE EVENTS
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)avPlayer successfully:(BOOL)flag
{
	NSLog(@"audioPlayerDidFinishPlaying");
	NSObject *object = [dicPlayers objectForKey:[avPlayer description]];
	if (object) {
		NSLog(@"release player");
		[dicPlayers removeObjectForKey:[avPlayer description]];
		[avPlayer release];
	}
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

#pragma mark -
#pragma mark VIEW ACTIONS

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	resourcePath = [[[NSBundle mainBundle] resourcePath] retain];
	arrViews = [[NSMutableArray alloc]init];
	arrShapesOnScreen = [[NSMutableArray alloc]init];
	arrTimers = [[NSMutableArray alloc]init];
	dicPlayers = [[NSMutableDictionary alloc]init];
	dicShapeTimer = [[NSMutableDictionary alloc] init];
	dicCenterPoint = [[NSMutableDictionary alloc] init];
	dicShapeTimer = [[NSMutableDictionary alloc] init];
	dicCenterPoint = [[NSMutableDictionary alloc] init];
    [super viewDidLoad];
}


-(void)viewWillAppear:(BOOL)animated
{
	@try {
		[appDelegate playSound:@"Shapes.mp3"];
		NSString *strShapesTitleName = [NSString stringWithFormat:@"%@.png",[self getShapesTitleGraphicName]];
		[appDelegate setImage:[UIImage thumbnailImage:strShapesTitleName] ofButton:btnShapesTitle];
		NSString *strSoundName = [NSString stringWithFormat:@"%@.mp3",[self getShapesTitleSoundName]];
		[self playSound:strSoundName];
		if([arrViews count]==0)
		{
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
	for (int i=0; i<[arrViews count]; i++) {
		UIView *v = [arrViews objectAtIndex:i];
		[v removeFromSuperview];
	}
	[arrViews removeAllObjects];
}

 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
     return (interfaceOrientation == UIInterfaceOrientationPortrait ||
             interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
 }


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
	
	[self removeAllShapesOnScreen];
	[UIImage clearThumbnailCache];
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark DYNAMIC CODE
-(void)dynamicallyLoadImages
{	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
	for (int i=0; i<[arrViews count]; i++) {
		UIButton *btnImage = [arrViews objectAtIndex:i];
		[btnImage removeFromSuperview];
	}
	[arrViews removeAllObjects];
	int startX = START_SHAPE_X, startY=START_SHAPE_Y;
	for (int i=0; i<[arrObjects count]; i++) {
		Objects *object = [arrObjects objectAtIndex:i];
		CGRect frame =  CGRectMake(startX, startY, BUTTON_WIDTH, BUTTON_HEIGHT);
		UIButton *btnImage = [UIButton buttonWithType:UIButtonTypeCustom];
		NSString *strImageName = [NSString stringWithFormat:[self getShapeGraphicName],object.ImageName];
		[appDelegate setImage:[UIImage thumbnailImage:[NSString stringWithFormat:@"%@.png",strImageName]] ofButton:btnImage];
		[btnImage addTarget:self action:@selector(smallShapeClicked:) forControlEvents:UIControlEventTouchUpInside];
		[btnImage addTarget:self action:@selector(smallShape:didStartDrag:) forControlEvents:UIControlEventTouchDragInside|UIControlEventTouchDragOutside];
		[btnImage addTarget:self action:@selector(smallShape:didEndDrag:) forControlEvents:UIControlEventTouchUpOutside|UIControlEventEditingDidEndOnExit|UIControlEventTouchUpInside];
		btnImage.imageView.contentMode = UIViewContentModeScaleAspectFit;
		btnImage.frame =frame;
		btnImage.tag = i;
		[self.view addSubview:btnImage];
		startX = (startX + BUTTON_WIDTH + SHAPE_HORIZONTAL_SPACE);
		if((startX+BUTTON_WIDTH)> self.view.frame.size.width)
		{
			startX = START_SHAPE_X;
			startY = startY + BUTTON_HEIGHT + SHAPE_VERTICAL_SPACE;
		}
		[arrViews addObject:btnImage];
	}
	[pool release];
}

- (void)dealloc {
	[dicCenterPoint release];
	[dicShapeTimer release];
	[resourcePath release];
	[arrViews removeAllObjects];
	[arrViews release];
	[arrShapesOnScreen removeAllObjects];
	[arrShapesOnScreen release];
	[arrObjects removeAllObjects];
	[arrObjects release];
	[arrTimers removeAllObjects];
	[arrTimers release];
	[dicPlayers removeAllObjects];
	[dicPlayers release];
	
	[btnShapesTitle release];
	[imgBlockView release];
	
    [super dealloc];
}


@end
