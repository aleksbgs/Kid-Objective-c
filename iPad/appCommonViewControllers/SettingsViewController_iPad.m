//
//  SettingsViewController_iPad.m
//  PreSchool
//
//  Created by Acai on 23/12/10.
//  Copyright 2010 Aca Technologies. All rights reserved.
//

#import "SettingsViewController_iPad.h"


@implementation SettingsViewController_iPad


-(IBAction)buy:(id)sender{
	@try {
		if ([appDelegate isConnectedToNetwork]) {
			btnBuy.enabled = FALSE;
			[loadingIndicator startAnimating];
			[inAppController makePurchase:product];
		}
		else {
			UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Connection Failed" message:@"To update KIDPedia Interactive Alphabet requires internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
	}
	@catch (NSException * e) {
	}
	@finally {
	}
	
}
-(IBAction)done:(id)sender
{
	int value = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] intValue];
	if (!appDelegate.bFirstTimeLoaded) {
		if (value!=prevPath.row) {
			[appDelegate resetGraphicsToOriginalPosition];
			appDelegate.bChangedLanguage = TRUE;
		}
		else {
			appDelegate.bChangedLanguage = FALSE;
		}
	}
	
	NSString *strRow = [[NSString alloc] initWithFormat:@"%d",prevPath.row];
	[[NSUserDefaults standardUserDefaults]setObject:strRow forKey:@"SelectedLanguage"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	[strRow release];
	
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark GET IMAGES AS PER LANGUAGE
-(NSString *)getHeader
{
	NSString *inAppTitle = NSLocalizedString(@"appInAppDisplayName",nil);
	@try {
		int value = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] intValue];
		switch (value) {
			case 0:
				inAppTitle = NSLocalizedString(@"appInAppDisplayName",nil);
				break;
			case 1:
				inAppTitle = @"KIDpedia Interactive Learning (English, Spanish and French)";
				break;
			case 2:
				inAppTitle = @"KIDpedia Interactive Learning (English, Spanish and French)";
				break;
			case 3:
				inAppTitle = @"KIDpedia Interactive Learning (English, Spanish and French)";
				break;
			default:
				break;
		}
	}
	@catch (NSException * e) {
	}
	@finally {
		return inAppTitle;
	}
}
-(NSString *)getDescription
{
	NSString *inAppDescription = NSLocalizedString(@"appInAppDescription",nil);
	@try {
		int value = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] intValue];
		switch (value) {
			case 0:
				inAppDescription = NSLocalizedString(@"appInAppDescription",nil);
				break;
			case 1:
				inAppDescription = @"Update to KIDpedia Interactive Learning (English, Spanish and French) from KIDpedia Interactive Alphabet (English, Spanish and French)";
				break;
			case 2:
				inAppDescription = @"Update to KIDpedia Interactive Learning (English, Spanish and French) from KIDpedia Interactive Alphabet (English, Spanish and French)";
				break;
			case 3:
				inAppDescription = @"Update to KIDpedia Interactive Learning (English, Spanish and French) from KIDpedia Interactive Alphabet (English, Spanish and French)";
				break;
			default:
				break;
		}
	}
	@catch (NSException * e) {
	}
	@finally {
		return inAppDescription;
	}
}
#pragma mark -
#pragma mark IN APP PURCHASE DELEGATE METHODS
- (void) purchaseController: (InAppPurchaseController *) controller didLoadInfo: (SKProduct *) products{
	footerView.hidden = FALSE;
	product = [products retain];
	lblTitle.text = product.localizedTitle;
	lblDescription.text = product.localizedDescription;
}
- (void) purchaseController: (InAppPurchaseController *) controller didFailLoadProductInfo: (NSError *) error{
	UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}
- (void) purchaseController: (InAppPurchaseController *) controller didFinishPaymentTransaction: (SKPaymentTransaction *) transaction{
	btnBuy.enabled = TRUE;
	[loadingIndicator stopAnimating];
	[appDelegate activeAllCategories];
}
- (void) purchaseController: (InAppPurchaseController *) controller didFailPaymentTransactionWithError: (NSError *) error{
	btnBuy.enabled = TRUE;
	[loadingIndicator stopAnimating];
}
#pragma mark -
#pragma mark TABLE VIEW DATASOURCE METHODS
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tV{
	return 1;
}
// Default is 1 if not implemented

- (NSString *)tableView:(UITableView *)tV titleForHeaderInSection:(NSInteger)section{
	return [@"Language" autorelease];
}
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
	return [arrLanguages count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tV cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *reuseIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
	if (cell==nil) {
		cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
	}
	cell.textLabel.font = [UIFont boldSystemFontOfSize:17.0];
	cell.textLabel.text = [arrLanguages objectAtIndex:indexPath.row];
	
	NSString *strLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"];
	if (([strLanguage length]==0 && indexPath.row==0)
		|| [strLanguage intValue]==indexPath.row) {
		prevPath = indexPath;
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		cell.textLabel.textColor = [UIColor colorWithRed:0.22f green:0.329f blue:0.529f alpha:1.0f];
	}
	else {
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.textLabel.textColor = [UIColor blackColor];
	}
	return cell;
}

#pragma mark -
#pragma mark TABLE VIEW DELEGATE METHODS
- (void)tableView:(UITableView *)tV didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	UITableViewCell *prevCell = [tableView cellForRowAtIndexPath:prevPath];
	
	if (cell.accessoryType == UITableViewCellAccessoryNone && indexPath!=prevPath) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		cell.textLabel.textColor = [UIColor colorWithRed:0.22f green:0.329f blue:0.529f alpha:1.0f];
		prevCell.accessoryType = UITableViewCellAccessoryNone;
		prevCell.textLabel.textColor = [UIColor blackColor];
	}
	prevPath = indexPath;
	
}


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization.
 tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 480) style:UITableViewStyleGrouped];
 }
 return self;
 }
 */
/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 self.view = tableView;
 // [self.view addSubview:tableView];
 }
 */
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication]delegate];
	self.title = @"Settings";
	arrLanguages = [[NSMutableArray alloc] initWithObjects:@"Selected as per device",
					@"English",
					@"Español",
					@"Français",nil];
	self.navigationItem.rightBarButtonItem = btnDone;
	tableView.tableFooterView = footerView;
	
    [super viewDidLoad];
}


-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	bConnectedToNetwork = [appDelegate isConnectedToNetwork];
	footerView.hidden = TRUE;
	if (bConnectedToNetwork) {
		if (!inAppController) {
			inAppController = [[InAppPurchaseController alloc]init];
			inAppController.strPurchaseId_  = NSLocalizedString(@"appInAppPurchaseID",nil);
			inAppController.delegate_ = self;
		}
		[inAppController loadProductsInfo];
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Connection Failed" message:@"To update KIDPedia Interactive Alphabet requires internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	
	[tableView reloadData];
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
	[UIImage clearThumbnailCache];
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[product release];
	[inAppController release];
	
	[tableView release];
	[footerView release];
	[btnBuy release];
	[lblTitle release];
	[lblDescription release];
	[btnDone release];
	
	[prevPath release];
	[arrLanguages removeAllObjects];
	[arrLanguages release];
	
	[super dealloc];
}


@end
