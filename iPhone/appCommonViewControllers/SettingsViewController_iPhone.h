//
//  SettingsViewController_iPhone.h
//  PreSchool
//
//  Created by Acai on 23/12/10.
//  Copyright 2010 Aca Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate_iPhone.h"
#import "InAppPurchaseController.h"

@interface SettingsViewController_iPhone : UIViewController<InAppPurchaseControllerDelegate, UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UITableView *tableView;
	IBOutlet UIBarButtonItem *btnDone;
	IBOutlet UIView *footerView;
	IBOutlet UILabel *lblTitle;
	IBOutlet UILabel *lblDescription;
	IBOutlet UIActivityIndicatorView *loadingIndicator;
	IBOutlet UIButton *btnBuy;
	AppDelegate_iPhone *appDelegate;
	NSIndexPath *prevPath;
	NSMutableArray *arrLanguages;
	InAppPurchaseController *inAppController;
	SKProduct *product;
	BOOL bConnectedToNetwork;
}
-(IBAction)done:(id)sender;
-(IBAction)buy:(id)sender;
@end
