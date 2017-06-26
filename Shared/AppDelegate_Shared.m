//
//  AppDelegate_Shared.m
//  PreSchool
//
//  Created by Acai on 30/11/10.
//  Copyright 2010 Aca Technologies. All rights reserved.
//

#import "AppDelegate_Shared.h"

@implementation AppDelegate_Shared

@synthesize window;
@synthesize arrCurrentObjects;
@synthesize bChangedLanguage;
@synthesize bFirstTimeLoaded;

-(BOOL)isConnectedToNetwork
{
	// Create zero addy 
	struct sockaddr zeroAddress; 
	bzero(&zeroAddress, sizeof(zeroAddress)); 
	zeroAddress.sa_len = sizeof(zeroAddress); 
	zeroAddress.sa_family = AF_INET; 
	// Recover reachability flags 
	SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress); 
	SCNetworkReachabilityFlags flags; 
	BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags); 
	CFRelease(defaultRouteReachability); 
	if (!didRetrieveFlags) 
	{ 
		printf("Error. Could not recover network reachability flags\n"); 
		return 0; 
	} 
	BOOL isReachable = flags & kSCNetworkFlagsReachable; 
	BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired; 
	return (isReachable && !needsConnection) ? YES : NO; 
}
#pragma mark -
#pragma mark SET IMAGE OF BUTTON
-(void)setImage:(UIImage *)image ofButton:(UIButton *)button
{
	NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
	if([systemVersion isEqualToString:@"3.1.2"] ||
	   [systemVersion isEqualToString:@"3.1.3"]  ||
	   [systemVersion isEqualToString:@"3.2"])
	{
		[button setImage:nil forState:UIControlStateNormal];
		[button setImage:nil forState:UIControlStateHighlighted];
		[button setImage:nil forState:UIControlStateSelected];
		[button setImage:nil forState:UIControlStateDisabled];
		
		[button setBackgroundImage:image forState:UIControlStateNormal];
		[button setBackgroundImage:image forState:UIControlStateHighlighted];
		[button setBackgroundImage:image forState:UIControlStateSelected];
		[button setBackgroundImage:image forState:UIControlStateDisabled];
	}
	else {
		[button setImage:image forState:UIControlStateNormal];
		[button setImage:image forState:UIControlStateHighlighted];
		[button setImage:image forState:UIControlStateSelected];
		[button setImage:image forState:UIControlStateDisabled];
		
		[button setBackgroundImage:nil forState:UIControlStateNormal];
		[button setBackgroundImage:nil forState:UIControlStateHighlighted];
		[button setBackgroundImage:nil forState:UIControlStateSelected];
		[button setBackgroundImage:nil forState:UIControlStateDisabled];
	}
}
#pragma mark -
#pragma mark AUDIO PLAYER DELEGATE EVENTS
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
}
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)avPlayer{
}
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)avPlayer{
	if (player && ![player isPlaying]) {
		[player play];
	}
}
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)avPlayer error:(NSError *)error{
}
#pragma mark -
#pragma mark DATABASE CREATION 

-(void)resetGraphicsToOriginalPosition
{
	for (int i=0; i<[arrCurrentObjects count]; i++) {
		Objects *object = [arrCurrentObjects objectAtIndex:i];
		object.strFrame = nil;
	}
}
-(void)stopSound
{
	//Initialize our player pointing to the path to our resource
	if(player!=nil && [player isPlaying])
	{
		[player stop];
		[player release];
		player = nil;
	}
}
-(void)playSound:(NSString *)soundFileName
{
	NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.0f target:self selector:@selector(playAudioPlayer:) 
													userInfo:[NSDictionary dictionaryWithObjectsAndKeys:soundFileName,@"SoundName",nil]
													 repeats:NO];
	[[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
	
}
-(void)playAudioPlayer:(NSTimer *)timer{
	NSString *soundFileName = [[timer userInfo] objectForKey:@"SoundName"];
	@try {
		NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
		resourcePath = [resourcePath stringByAppendingPathComponent:soundFileName];
		//NSLog(@"Path to play: %@", resourcePath);
		NSError* err;
		
		//Initialize our player pointing to the path to our resource
		if(player!=nil && [player isPlaying])
		{
			[player stop];
			[player release];
			player = nil;
		}
		
		player = [[AVAudioPlayer alloc] initWithContentsOfURL:
				  [NSURL fileURLWithPath:resourcePath] error:&err];
		
		if( err ){
			//bail!
			NSLog(@"Failed with reason: %@", [err localizedDescription]);
		}
		else{
			//set our delegate and begin playback
			player.delegate = self;
			player.numberOfLoops = -1;
			[player play];
		}
	}
	@catch (NSException * e) {
	}
	@finally {
	}
}
- (void) CreateDatabaseIfNeeded
{
	@try {
		BOOL success = NO;
		NSError *pError;
		
		NSFileManager *pFileManager = [NSFileManager defaultManager];
		
		NSArray *pUsrDocPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		
		NSString *pDocsDir = [pUsrDocPath objectAtIndex:0];
		
		NSString *pDbPath = [pDocsDir stringByAppendingPathComponent:NSLocalizedString(@"appNewDatabaseName",nil)];
		
		NSString *pOldDbPath = [pDocsDir stringByAppendingPathComponent:NSLocalizedString(@"appOldDatabaseName",nil)];
		
		success = [pFileManager fileExistsAtPath:pOldDbPath];
		if(success){
			[pFileManager removeItemAtPath:pOldDbPath error:nil];
		}
		
		success = [pFileManager fileExistsAtPath:pDbPath];
		
		if(success){
			if(sqlite3_open([pDbPath UTF8String], &database)!=SQLITE_OK)
				sqlite3_close(database);
			return;
		}
		
		NSString *pDatabasePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:NSLocalizedString(@"appNewDatabaseName",nil)];
		
		success = [pFileManager copyItemAtPath: pDatabasePath toPath: pDbPath error:&pError];
		
		if(!success)
			NSAssert1(0, @"Failed to copy the database. Errror: %@.", [pError localizedDescription]);
		else{
			if(sqlite3_open([pDbPath UTF8String], &database)!=SQLITE_OK)
				sqlite3_close(database);
		}
	}
	@catch (NSException * e) {
		UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Database Error" message:[e description] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	@finally {
	}
	
}

#pragma mark -
#pragma mark Application lifecycle

/**
 Save changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
	if (player && ![player isPlaying]) {
		[player play];
	}
}
- (void)applicationWillResignActive:(UIApplication *)application{
	[self resetGraphicsToOriginalPosition];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	[self resetGraphicsToOriginalPosition];
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

const unsigned char *sqlite3_column_text_check(sqlite3_stmt* stmt, int iCol){
	const unsigned char *val = sqlite3_column_text(stmt,iCol);
	if(val==nil)
		return (unsigned char *)"";
	else
		return val;
}

-(void)activeAllCategories{
	sqlite3_stmt *updateStatement = nil;
	const char *sql = "update Category set Approved=1";
	int returnValue = sqlite3_prepare_v2(database, sql, -1, &updateStatement, NULL);
	if(returnValue == SQLITE_OK)
	{
		if(sqlite3_step(updateStatement)==SQLITE_DONE)
		{
			//Data;
		}
	}
	sqlite3_finalize(updateStatement);
}

-(NSMutableArray *)getAllCategories
{
	NSMutableArray *arrCategories = nil;
	sqlite3_stmt *selectStatement = nil;
	const char *sql = "select ID,SOUNDFILENAME,IMAGENAME,SPANISHTITLE,FRENCHTITLE,ENGLISHTITLE FROM Category where Approved=1";
	int returnValue = sqlite3_prepare_v2(database, sql , -1, &selectStatement, NULL);
	if(returnValue == SQLITE_OK)
	{
		arrCategories=[[NSMutableArray alloc] init];
		
		//sqlite3_bind_int(selectStatement, 1, iListingID);
		
		while(sqlite3_step(selectStatement)==SQLITE_ROW)
		{
			Category *category = [[Category alloc]init];
			
			category.ID = sqlite3_column_int(selectStatement, 0);
			category.SoundFileName = [NSString stringWithCString:(char  *)sqlite3_column_text_check(selectStatement, 1) encoding:NSUTF8StringEncoding];
			category.ImageName = [NSString stringWithCString:(char  *)sqlite3_column_text_check(selectStatement, 2) encoding:NSUTF8StringEncoding];
			category.SpanishTitle = [NSString stringWithCString:(char  *)sqlite3_column_text_check(selectStatement, 3) encoding:NSUTF8StringEncoding];
			category.FrenchTitle = [NSString stringWithCString:(char  *)sqlite3_column_text_check(selectStatement, 4) encoding:NSUTF8StringEncoding];
			category.EnglishTitle = [NSString stringWithCString:(char  *)sqlite3_column_text_check(selectStatement, 5) encoding:NSUTF8StringEncoding];
			
			[arrCategories addObject:category];
			[category release];
		}
	}
	sqlite3_finalize(selectStatement);
	
	return [arrCategories autorelease];
}

-(NSMutableArray *)getObjectsByCategoryID:(int)ID
{
	NSMutableArray *arrObjects = nil;
	sqlite3_stmt *selectStatement = nil;
	const char *sql = "select ID,SOUNDFILENAME,IMAGENAME,SPANISHTITLE,FRENCHTITLE,ENGLISHTITLE FROM Objects where CategoryID=?";
	int returnValue = sqlite3_prepare_v2(database, sql , -1, &selectStatement, NULL);
	if(returnValue == SQLITE_OK)
	{
		arrObjects=[[NSMutableArray alloc] init];
		
		sqlite3_bind_int(selectStatement, 1, ID);
		
		while(sqlite3_step(selectStatement)==SQLITE_ROW)
		{
			Objects *object = [[Objects alloc]init];
			
			object.ID = sqlite3_column_int(selectStatement, 0);
			object.SoundFileName = [NSString stringWithCString:(char  *)sqlite3_column_text_check(selectStatement, 1) encoding:NSUTF8StringEncoding];
			object.ImageName = [NSString stringWithCString:(char  *)sqlite3_column_text_check(selectStatement, 2) encoding:NSUTF8StringEncoding];
			object.SpanishTitle = [NSString stringWithCString:(char  *)sqlite3_column_text_check(selectStatement, 3) encoding:NSUTF8StringEncoding];
			object.FrenchTitle = [NSString stringWithCString:(char  *)sqlite3_column_text_check(selectStatement, 4) encoding:NSUTF8StringEncoding];
			object.EnglishTitle = [NSString stringWithCString:(char  *)sqlite3_column_text_check(selectStatement, 5) encoding:NSUTF8StringEncoding];
			object.categoryID = ID;
			[arrObjects addObject:object];
			[object release];
		}
	}
	sqlite3_finalize(selectStatement);
	return [arrObjects autorelease];
}
-(NSMutableArray *)getAllObjects
{
	NSMutableArray *arrObjects = nil;
	sqlite3_stmt *selectStatement = nil;
	const char *sql = "select ID,SOUNDFILENAME,IMAGENAME,SPANISHTITLE,FRENCHTITLE,ENGLISHTITLE,CategoryID FROM Objects";
	int returnValue = sqlite3_prepare_v2(database, sql , -1, &selectStatement, NULL);
	if(returnValue == SQLITE_OK)
	{
		arrObjects=[[NSMutableArray alloc] init];
		
		while(sqlite3_step(selectStatement)==SQLITE_ROW)
		{
			Objects *object = [[Objects alloc]init];
			
			object.ID = sqlite3_column_int(selectStatement, 0);
			object.SoundFileName = [NSString stringWithCString:(char  *)sqlite3_column_text_check(selectStatement, 1) encoding:NSUTF8StringEncoding];
			object.ImageName = [NSString stringWithCString:(char  *)sqlite3_column_text_check(selectStatement, 2) encoding:NSUTF8StringEncoding];
			object.SpanishTitle = [NSString stringWithCString:(char  *)sqlite3_column_text_check(selectStatement, 3) encoding:NSUTF8StringEncoding];
			object.FrenchTitle = [NSString stringWithCString:(char  *)sqlite3_column_text_check(selectStatement, 4) encoding:NSUTF8StringEncoding];
			object.EnglishTitle = [NSString stringWithCString:(char  *)sqlite3_column_text_check(selectStatement, 5) encoding:NSUTF8StringEncoding];
			object.categoryID = sqlite3_column_int(selectStatement, 6);
			[arrObjects addObject:object];
			[object release];
		}
	}
	sqlite3_finalize(selectStatement);
	
	return [arrObjects autorelease];
}
#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
	[UIImage clearThumbnailCache];
}


- (void)dealloc {
    
    [window release];
    [super dealloc];
}


@end

