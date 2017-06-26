//
//  BeachBall.h
//  PreSchool
//
//  Created by Acai on 22/12/10.
//  Copyright 2010 Aca Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimateObjectView.h"

@interface BeachBall : AnimateObjectView {
	CGPoint position;
    CGPoint velocity;
    CGFloat radius;
	CGFloat minY, maxY;
}
@property CGPoint position;
@property CGPoint velocity;
@property CGFloat radius;
@property CGFloat minY;
@property CGFloat maxY;
- (BOOL)update;
@end
