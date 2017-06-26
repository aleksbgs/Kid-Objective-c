//
//  ConfettiView.m
//  KIDPedia
//
//  Created by Acai on 19/02/11.
//  Copyright 2011 Aca Technologies. All rights reserved.
//

#import "ConfettiView.h"


@implementation ConfettiView
@synthesize delegate;

-(void)initAllImages:(CGRect)frame{
	if (!arrViews) {
		arrViews = [[NSMutableArray alloc]init];
	}
	for (int i=0; i<TOTAL_OBJECTS_SHOWN; i++) {
		int x = arc4random() % (int)frame.size.width;
		int y = arc4random() % (int)frame.size.height;
		int number = arc4random() % MAX_OBJECTS;
		NSString *imageName = [NSString stringWithFormat:@"small_%d.png",number];
		UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage thumbnailImage:imageName]];
		imageView.tag = i;
		imageView.frame = CGRectMake(x, y, IMAGE_WIDTH, IMAGE_HEIGHT);
		[self addSubview:imageView];
		[arrViews addObject:imageView];
		[imageView release];
	}
}
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)rotateImage:(UIImageView *)imageView
{
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:ROTATION_ANIMATION] forKey:kCATransactionAnimationDuration];
	
	int randomStartAngle = arc4random() % 180;
	int randomRadius =  arc4random()% 130;
	int randomClockWise = 0;
	int randomEndAngle = arc4random()%180;
	
	if (randomRadius<90) {
		randomRadius = 90;
	}
	CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	if (imageView.tag==0) {
		rotateAnimation.delegate = self;
		[rotateAnimation setValue:@"0" forKey:@"Animation"];
	}
	rotateAnimation.removedOnCompletion = NO;
	rotateAnimation.rotationMode = kCAAnimationRotateAuto;
	
	CGMutablePathRef movePath = CGPathCreateMutable();
	CGPathAddArc(movePath, nil, imageView.center.x, imageView.center.y, randomRadius, randomStartAngle, randomEndAngle, randomClockWise);
	
	rotateAnimation.path = movePath;
	
	//rotateAnimation.calculationMode= kCAAnimationPaced;
	[rotateAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
	
	[imageView.layer addAnimation:rotateAnimation forKey:@"roatateAnimation"];
	
	[CATransaction commit];
	
	CGPathRelease(movePath);
}

-(void)translateImage:(UIImageView *)imageView
{
	imageView.transform = [[imageView.layer presentationLayer] affineTransform];
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:TRANSLATE_ANIMATION] forKey:kCATransactionAnimationDuration];

	CAKeyframeAnimation *translateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	if (imageView.tag==0) {
		translateAnimation.delegate = self;
		[translateAnimation setValue:@"1" forKey:@"Animation"];
	}
	
	CGMutablePathRef positionPath = CGPathCreateMutable();
	CGPathMoveToPoint(positionPath, NULL, imageView.center.x ,  imageView.center.y );
	CGPathAddLineToPoint(positionPath, NULL, imageView.center.x , imageView.center.y + self.frame.size.height+500);
	translateAnimation.path = positionPath;
	CGPathRelease(positionPath);
	
	translateAnimation.fillMode = kCAFillModeForwards;
	translateAnimation.removedOnCompletion= NO;
	[translateAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
	
	[imageView.layer addAnimation:translateAnimation forKey:@"translateAnimation"];
	
	[CATransaction commit];
}

-(void)start{
	@try {
		bStarted = TRUE;
		if ([arrViews count]==0) {
			[self initAllImages:self.frame];
		}

		for (int i=0; i<[self.subviews count]; i++) {
			UIView *view = [self.subviews objectAtIndex:i];
			if ([view isKindOfClass:[UIImageView class]]) {
				UIImageView *imageView = (UIImageView *)view;
				[imageView.layer removeAllAnimations];
				[self performSelectorOnMainThread:@selector(rotateImage:) withObject:imageView waitUntilDone:NO];
			}
		}
	}
	@catch (NSException * e) {
	}
	@finally {
	}
}

-(void)translate{
	bStarted = TRUE;
	for (int i=0; i<[self.subviews count]; i++) {
		UIView *view = [self.subviews objectAtIndex:i];
		if ([view isKindOfClass:[UIImageView class]]) {
			UIImageView *imageView = (UIImageView *)view;
			[self performSelectorOnMainThread:@selector(translateImage:) withObject:imageView waitUntilDone:NO];
		}
	}
}
-(void)stop{
	bStarted = FALSE;
	[self removeAllViews];
}
-(BOOL)isStarted{
	return bStarted;
}

#pragma mark -
#pragma mark ANIMATION STOPPED EVENT
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{	
	bStarted = FALSE;
	NSString *sequence = [anim valueForKey:@"Animation"];
	if (sequence) {
		int animSequence = [sequence intValue];
		switch (animSequence) {
			case 0:
				[self translate];
				break;
			case 1:
				[self removeAllViews];
				[delegate didCompleteAnimation];
				break;
			default:
				break;
		}
	}
}
-(void)removeAllViews
{
	for (int i=0; i<[arrViews count]; i++) {
		UIView *view = [arrViews objectAtIndex:i];
		[view.layer removeAllAnimations];
		[view removeFromSuperview];
	}
	[arrViews removeAllObjects];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	[arrViews removeAllObjects];
	[arrViews release];
    [super dealloc];
}


@end
