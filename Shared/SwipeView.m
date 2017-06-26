//
//  SwipeView.m
//  PreSchool
//
//  Created by Acai on 06/12/10.
//  Copyright 2010 Aca Technologies. All rights reserved.
//

#import "SwipeView.h"


@implementation SwipeView
@synthesize swipedelegate,swipedatasource;

- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
	self.delegate = self;
	@try {
		maxPages = [swipedatasource noOfPagesToSwipe];
	}
	@catch (NSException * e) {
		NSLog(@"Please implement an event -(int)noOfPagesToSwipe in your datasource");
	}
	@finally {
	}
}
- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		
    }
    return self;
}
- (void)loadScrollViewWithPage:(int)page
{
    if (page < 0)
        return;
    if (page >= maxPages)
        return;
	[swipedelegate didSwipe:page];
    // add the controller's view to the scroll view
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.frame.size.width;
    int page = floor((self.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (page>currentPage) {
		[swipedelegate willSwipeRight:page];
	}
	else if (page<currentPage) {
		[swipedelegate willSwipeLeft:page];
	}
	if (page!=currentPage) {
		[self loadScrollViewWithPage:page];
	}
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
	 // [self loadScrollViewWithPage:page];
	currentPage = page;
    
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	NSLog(@"scrollViewWillBeginDragging");
	int contentOffSet = scrollView.contentOffset.x;
	int viewWidth = self.frame.size.width;
	NSLog(@"content of set is:- %i and width is:- %i",contentOffSet,viewWidth);
	if (contentOffSet%viewWidth!=0) {
		NSLog(@"enter if condition");
		int mod = contentOffSet%viewWidth;
		//scrollView.contentOffset.x = scrollView.contentOffset.x+mod;
		scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x+mod, scrollView.contentOffset.y);
	}
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	NSLog(@"scrollViewDidEndDecelerating");
	int contentOffSet = scrollView.contentOffset.x;
	int viewWidth = self.frame.size.width;
	NSLog(@"content of set is:- %i and width is:- %i",contentOffSet,viewWidth);
	if (contentOffSet%viewWidth!=0) {
		NSLog(@"enter if condition");
		int mod = contentOffSet%viewWidth;
		//scrollView.contentOffset.x = scrollView.contentOffset.x+mod;
		scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x+mod, scrollView.contentOffset.y);
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
    [super dealloc];
}


@end
