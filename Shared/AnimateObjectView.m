//
//  AnimateObjectView.m
//  PreSchool
//
//  Created by Acai on 17/12/10.
//  Copyright 2010 Aca Technologies. All rights reserved.
//

#import "AnimateObjectView.h"


@implementation AnimateObjectView
@synthesize delegate;
@synthesize ID;
@synthesize duration;
@synthesize isLeft;
@synthesize imageName;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	
	[super touchesBegan:touches withEvent:event];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	clickValue++;
	if (clickValue==1) {
		[delegate didClickFirstTime:self];
	}
	else if(clickValue==2){
		[delegate didClickSecondTime:self];
		clickValue = 0;
	}
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
	[imageName release];
    [super dealloc];
}


@end
