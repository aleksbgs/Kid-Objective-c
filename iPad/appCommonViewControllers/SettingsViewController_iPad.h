//
//  SettingsViewController_iPad.h
//  PreSchool
//
//  Created by Acai on 23/12/10.
//  Copyright 2010 Aca Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate_iPad.h"
#import "InAppPurchaseController.h"

@interface SettingsViewController_iPad : UIViewController<InAppPurchaseControllerDelegate> {
	IBOutlet UITableView *tableView;
	IBOutlet UIBarButtonItem *btnDone;
	IBOutlet UIView *footerView;
	IBOutlet UILabel *lblTitle;
	IBOutlet UILabel *lblDescription;
	IBOutlet UIActivityIndicatorView *loadingIndicator;
	IBOutlet UIButton *btnBuy;
	AppDelegate_iPad *appDelegate;
	NSIndexPath *prevPath;
	NSMutableArray *arrLanguages;
	InAppPurchaseController *inAppController;
	SKProduct *product;
	BOOL bConnectedToNetwork;
}
-(IBAction)done:(id)sender;
-(IBAction)buy:(id)sender;
@end
