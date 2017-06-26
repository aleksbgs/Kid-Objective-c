    //
//  MainMenuViewController_iPhone.m
//  PreSchool
//
//  Created by Acai on 21/12/10.
//  Copyright 2010 Aca Technologies. All rights reserved.
//

#import "MainMenuViewController_iPhone.h"
@interface UIViewController(Extended)
-(void)setCategory:(Category *)category;
@end


@implementation MainMenuViewController_iPhone

#pragma mark -
#pragma mark LOAD DYNAMIC BUTTONS
-(void)loadButtons
{
	for (int i=0; i<[arrButtons count]; i++) {
		UIButton *btnCategory = [arrButtons objectAtIndex:i];
		[btnCategory removeFromSuperview];
	}
	[arrButtons removeAllObjects];
	int x = SPACE_HORI;
	int y = SPACE_VERT;
	for (int i=0; i<[arrCategories count]; i++) {
		Category *category = [arrCategories objectAtIndex:i];
		UIButton *btnCategory = [UIButton buttonWithType:UIButtonTypeCustom];
		btnCategory.tag= i;
		btnCategory.frame = CGRectMake(x, y, BUTTON_WIDTH, BUTTON_HEIGHT);
		[btnCategory addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
		NSString *strImage = [NSString stringWithFormat:[self getIconName],[category.EnglishTitle lowercaseString]];
		@try {
			[appDelegate setImage:[UIImage thumbnailImage:[NSString stringWithFormat:@"%@.png",strImage]] ofButton:btnCategory];
		}
		@catch (NSException * e) {
			UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Image Error" message:[e description] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
			[alert release];
			break;
		}
		@finally {
			
		}
		x=x+BUTTON_WIDTH+SPACE_HORI;
		int k=i+1;
		if (k%3==0) {
			x=SPACE_HORI;
			y=y+BUTTON_HEIGHT+SPACE_VERT;
		}
		[scrollView addSubview:btnCategory];
		[arrButtons addObject:btnCategory];
		
	}
	scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, y);
	backgroundImageView.contentMode = UIViewContentModeScaleToFill;
	if ([arrCategories count]==1) {
		backgroundImageView.image = [UIImage thumbnailImage:@"alphabet_main_bg_iphone.jpg"];
		UIButton *btnCategory = [arrButtons objectAtIndex:0];
		btnCategory.frame = CGRectMake(10, 10, 220, 63);	
		@try {
			[appDelegate setImage:[UIImage thumbnailImage:@"play_learn.png"] ofButton:btnCategory];
		}
		@catch (NSException * e) {
			UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Image Error" message:[e description] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
		@finally {
			
		}
	}
	else {
		backgroundImageView.image = [UIImage thumbnailImage:@"full_main_bg_iphone.jpg"];
	}

}
#pragma mark -
#pragma mark BUTTON ACTIONS
-(IBAction)play:(id)sender
{
	UIButton *btnSelected = sender;
	@try {
		int position = btnSelected.tag;
		Category *category = [arrCategories objectAtIndex:position];
		
		UIViewController *viewController = [dicViewControllers objectForKey:[NSString stringWithFormat:@"%@ViewController_iPhone",[category.EnglishTitle capitalizedString]]];
		if (!viewController) {
			viewController =  [[NSClassFromString([NSString stringWithFormat:@"%@ViewController_iPhone",[category.EnglishTitle capitalizedString]]) alloc] initWithNibName:[NSString stringWithFormat:@"%@View_iPhone",[category.EnglishTitle capitalizedString]] bundle:nil];
			[dicViewControllers setObject:viewController forKey:[NSString stringWithFormat:@"%@ViewController_iPhone",[category.EnglishTitle capitalizedString]]];
		}
		[viewController setCategory:category];
		[self.navigationController pushViewController:viewController animated:YES];
		if (![viewController isKindOfClass:[NSClassFromString(@"AlphabetsViewController_iPhone") class]]) {
			[dicViewControllers removeObjectForKey:[NSString stringWithFormat:@"%@ViewController_iPhone",[category.EnglishTitle capitalizedString]]];
			[viewController release];
		}
	}
	@catch (NSException * e) {
	}
	@finally {
	}
}
-(IBAction)settings:(id)sender
{
	SettingsViewController_iPhone	*settingsViewController = [[SettingsViewController_iPhone alloc]initWithNibName:@"SettingsView_iPhone" bundle:nil];
	[self.navigationController pushViewController:settingsViewController animated:YES];
	[self.navigationController setNavigationBarHidden:NO animated:NO];
	[settingsViewController release];
}
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/
#pragma mark -
#pragma mark GET IMAGES AS PER LANGUAGE
-(NSString *)getIconName
{
	NSString *alphabetImageName = NSLocalizedString(@"appIconsName",nil);
	@try {
		int value = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] intValue];
		switch (value) {
			case 0:
				alphabetImageName = NSLocalizedString(@"appIconsName",nil);
				break;
			case 1:
				alphabetImageName = @"%@_icon";
				break;
			case 2:
				alphabetImageName = @"%@_icon_spanish";
				break;
			case 3:
				alphabetImageName = @"%@_icon_french";
				break;
			default:
				break;
		}
	}
	@catch (NSException * e) {
	}
	@finally {
		return alphabetImageName;
	}
}
#pragma mark -
#pragma mark VIEW ACTIONS
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication]delegate];
	arrButtons = [[NSMutableArray alloc]init];
	dicViewControllers = [[NSMutableDictionary alloc]init];
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
	if ([arrCategories count]>0) {
		[arrCategories removeAllObjects];
	}
	arrCategories= [[appDelegate getAllCategories] retain];
	[self loadButtons];
	[appDelegate playSound:@"MainPageTheme.mp3"];
	[self.navigationController setNavigationBarHidden:YES animated:YES];
	//[loading stopAnimating];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait ||
			interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

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
    [super dealloc];
}


@end
