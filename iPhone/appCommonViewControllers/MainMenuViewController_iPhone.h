//
//  MainMenuViewController_iPhone.h
//  PreSchool
//
//  Created by Acai on 21/12/10.
//  Copyright 2010 Aca Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate_iPhone.h"
#import "SettingsViewController_iPhone.h"

#define BUTTON_WIDTH 75
#define BUTTON_HEIGHT 75
#define BUTTON_VERTICAL_SPACE 10
#define SPACE_VERT 9
#define SPACE_HORI 2
#define START_Y 20
@interface MainMenuViewController_iPhone : UIViewController {
	IBOutlet UIImageView *backgroundImageView;
	IBOutlet UIScrollView *scrollView;
	AppDelegate_iPhone *appDelegate;
	//SettingsViewController_iPhone *settingsViewController;
	NSMutableDictionary *dicViewControllers;
	NSMutableArray *arrCategories;
	NSMutableArray *arrButtons;
}
-(IBAction)play:(id)sender;
-(IBAction)settings:(id)sender;

-(NSString *)getIconName;
@end
