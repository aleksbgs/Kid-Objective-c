//
//  BeachBall.m
//  PreSchool
//
//  Created by Acai on 22/12/10.
//  Copyright 2010 Aca Technologies. All rights reserved.
//

#import "BeachBall.h"


@implementation BeachBall
@synthesize position;
@synthesize velocity;
@synthesize radius;
@synthesize minY;
@synthesize maxY;
- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}
- (BOOL)update {
    position.x += velocity.x;
    position.y += velocity.y;
	
    if(position.x + radius > (self.superview.window.frame.size.width + self.frame.size.width)) {
		return FALSE;
	
    }
    else if(position.x - radius < (0.0-self.frame.size.width)) {
		return FALSE;
    }
	
    if(position.y + radius > maxY) {
        position.y = maxY - radius;
        velocity.y *= -1.0;
		if ((minY+5.0f)<=maxY) {
			minY+=5.0f;
			velocity.y-=0.05;
		}
    }
    else if(position.y - radius < minY) {
        position.y = minY+radius;
        velocity.y *= -1.0;
    }
	[self setCenter:position];
	if (self.tag==0) {
		self.transform = CGAffineTransformRotate(self.transform, -M_PI/60.0f);
	}
	else {
		self.transform = CGAffineTransformRotate(self.transform, M_PI/60.0f);
	}

	//NSLog(@"data");
	return TRUE;
    //NSLog([[NSString alloc] initWithFormat:@"x: %f, y:%f", position.x, position.y]);
}
- (void)dealloc {
    [super dealloc];
}
@end
