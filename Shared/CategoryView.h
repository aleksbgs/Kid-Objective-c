//
//  CategoryView.h
//  PreSchool
//
//  Created by Acai on 01/12/10.
//  Copyright 2010 Aca Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageAdditions.h"
#define IMAGE_WIDTH 75
#define IMAGE_HEIGHT 75

@interface CategoryView : UIView {
	UIButton *btnImage;
	UILabel *lblTitle;
}
@property(nonatomic, retain) UIButton *btnImage;
@property(nonatomic, retain) UILabel *lblTitle;

-(id)initWithFrame:(CGRect)frame withImageName:(NSString *)imageName withTitle:(NSString *)title withDelegate:(id)delegate;
@end
