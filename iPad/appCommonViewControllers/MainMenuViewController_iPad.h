//
//  MainMenuViewController_iPad.h
//  PreSchool
//
//  Created by Acai on 21/12/10.
//  Copyright 2010 Aca Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate_iPad.h"
#import "SettingsViewController_iPad.h"

#define BUTTON_WIDTH 150
#define BUTTON_HEIGHT 150
#define BUTTON_VERTICAL_SPACE 20
#define SPACE_VERT 40
#define SPACE_HORI 25
#define START_Y 20
@interface MainMenuViewController_iPad : UIViewController {
	IBOutlet UIImageView *backgroundImageView;
	IBOutlet UIScrollView *scrollView;
	AppDelegate_iPad *appDelegate;
	NSMutableDictionary *dicViewControllers;
	NSMutableArray *arrCategories;
	NSMutableArray *arrButtons;
}
-(IBAction)play:(id)sender;
-(IBAction)settings:(id)sender;

-(NSString *)getIconName;
@end
