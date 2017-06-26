//
//  ConfettiView.h
//  KIDPedia
//
//  Created by Acai on 19/02/11.
//  Copyright 2011 Aca Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UIImageAdditions.h"
#define TOTAL_OBJECTS_SHOWN 150
#define IMAGE_WIDTH 35
#define IMAGE_HEIGHT 45
#define MAX_OBJECTS 9

#define ROTATION_ANIMATION 3.0f
#define TRANSLATE_ANIMATION 2.0f

@protocol ConfettiViewDelegate

-(void)didCompleteAnimation;

@end


@interface ConfettiView : UIView {
	NSMutableArray *arrViews;
	id<ConfettiViewDelegate>delegate;
	BOOL bStarted;
}
@property(nonatomic, retain) id<ConfettiViewDelegate>delegate;

-(void)start;
-(void)stop;
-(BOOL)isStarted;
-(void)removeAllViews;
@end
