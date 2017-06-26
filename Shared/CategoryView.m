//
//  CategoryView.m
//  PreSchool
//
//  Created by Acai on 01/12/10.
//  Copyright 2010 Aca Technologies. All rights reserved.
//

#import "CategoryView.h"


@implementation CategoryView
@synthesize btnImage, lblTitle;

-(id)initWithFrame:(CGRect)frame withImageName:(NSString *)imageName withTitle:(NSString *)title withDelegate:(id)delegate
{
	if ((self = [super initWithFrame:frame])) {
		btnImage = [UIButton buttonWithType:UIButtonTypeCustom];
		btnImage.frame = CGRectMake(0, 0, IMAGE_WIDTH, IMAGE_HEIGHT);
		[btnImage setBackgroundImage:[UIImage thumbnailImage:[NSString stringWithFormat:@"%@.png",imageName]] forState:UIControlStateNormal];
		[btnImage addTarget:delegate action:@selector(categoryClicked:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:btnImage];
		
		lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, IMAGE_HEIGHT, IMAGE_WIDTH, 15)];
		lblTitle.font = [UIFont boldSystemFontOfSize:13.0f];
		lblTitle.textAlignment = UITextAlignmentCenter;
		lblTitle.text = title;
		lblTitle.textColor = [UIColor blackColor];
		lblTitle.backgroundColor = [UIColor clearColor];
		[self addSubview:lblTitle];
	}
	return self;
}
- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		btnImage = [UIButton buttonWithType:UIButtonTypeCustom];
		btnImage.frame = CGRectMake(0, 0, IMAGE_WIDTH, IMAGE_HEIGHT);
		[self addSubview:btnImage];
		
		lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, IMAGE_HEIGHT, IMAGE_WIDTH, 20)];
		lblTitle.font = [UIFont boldSystemFontOfSize:15.0f];
		lblTitle.textColor = [UIColor blackColor];
		lblTitle.backgroundColor = [UIColor clearColor];
		[self addSubview:lblTitle];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
	[btnImage release];
	[lblTitle release];
    [super dealloc];
}


@end
