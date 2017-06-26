//
//  AnimateObjectView.h
//  PreSchool
//
//  Created by Acai on 17/12/10.
//  Copyright 2010 Aca Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AnimateObjectViewDelegate <NSObject>
@optional 
/* audioPlayerDidFinishPlaying:successfully: is called when a sound has finished playing. This method is NOT called if the player is stopped due to an interruption. */
- (void)didClickFirstTime:(id)animView;
- (void)didClickSecondTime:(id)animView;
@end
@interface AnimateObjectView : UIImageView {
	int ID;
	float duration;
	int clickValue;
	id<AnimateObjectViewDelegate> delegate;
	bool isLeft;
	NSString *imageName;
}


@property(nonatomic,readwrite) int ID;
@property(nonatomic, readwrite) float duration;
@property(nonatomic, retain) id<AnimateObjectViewDelegate> delegate;
@property(nonatomic, readwrite) bool isLeft;
@property(nonatomic, retain) NSString *imageName;
@end
