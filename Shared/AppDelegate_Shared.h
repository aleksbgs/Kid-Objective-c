//
//  AppDelegate_Shared.h
//  PreSchool
//
//  Created by Acai on 30/11/10.
//  Copyright 2010 Aca Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import <AVFoundation/AVFoundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "MainWindow.h"
#import "Category.h"
#import "Objects.h"
#import "UIImageAdditions.h"

@interface AppDelegate_Shared : NSObject <UIApplicationDelegate,AVAudioPlayerDelegate> {
    
    MainWindow *window;
	sqlite3 *database;
	AVAudioPlayer *player;
	NSMutableArray *arrCurrentObjects;
	BOOL bChangedLanguage;
	BOOL bFirstTimeLoaded;
}

@property (nonatomic, retain) IBOutlet MainWindow *window;
@property (nonatomic, retain) NSMutableArray *arrCurrentObjects;
@property (nonatomic, readwrite) BOOL bChangedLanguage;
@property (nonatomic, readwrite) BOOL bFirstTimeLoaded;

- (void) CreateDatabaseIfNeeded;
-(void)activeAllCategories;
-(NSMutableArray *)getAllCategories;
-(NSMutableArray *)getAllObjects;
-(NSMutableArray *)getObjectsByCategoryID:(int)ID;
-(void)playSound:(NSString *)fileName;
-(void)stopSound;

-(BOOL)isConnectedToNetwork;
-(void)resetGraphicsToOriginalPosition;
-(void)setImage:(UIImage *)image ofButton:(UIButton *)button;
@end

