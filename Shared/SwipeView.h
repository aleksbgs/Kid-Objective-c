//
//  SwipeView.h
//  PreSchool
//
//  Created by Acai on 06/12/10.
//  Copyright 2010 Aca Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#define HORIZ_SWIPE_DRAG_MIN 12 
#define VERT_SWIPE_DRAG_MAX 4

@protocol SwipeViewDelegate <NSObject>
@optional 
/* audioPlayerDidFinishPlaying:successfully: is called when a sound has finished playing. This method is NOT called if the player is stopped due to an interruption. */
- (void)didSwipe:(int)currentPage;
- (void)willSwipeLeft:(int)currentPage;
- (void)willSwipeRight:(int)currentPage;
@end

@protocol SwipeViewDatasource <NSObject>
@optional 
/* audioPlayerDidFinishPlaying:successfully: is called when a sound has finished playing. This method is NOT called if the player is stopped due to an interruption. */
- (int)noOfPagesToSwipe;
@end

@interface SwipeView : UIScrollView<UIScrollViewDelegate> {
	id<SwipeViewDelegate> swipedelegate;
	id<SwipeViewDatasource> swipedatasource;
	int maxPages;
	int currentPage;
}
@property(nonatomic, retain) id<SwipeViewDelegate> swipedelegate;
@property(nonatomic, retain) id<SwipeViewDatasource> swipedatasource;
@end
