//
//  AppDelegate_iPad.h
//  PreSchool
//
//  Created by Acai on 30/11/10.
//  Copyright 2010 Aca Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate_Shared.h"
#import "Category.h"

#define IDLE_TIME 15.0f

@interface AppDelegate_iPad : AppDelegate_Shared {
	IBOutlet UINavigationController *navigationController;
}
@property(nonatomic, retain)UINavigationController *navigationController;
- (void) CreateDatabaseIfNeeded;
-(NSMutableArray *)getAllCategories;
-(NSMutableArray *)getAllObjects;
-(NSMutableArray *)getObjectsByCategoryID:(int)ID;

@end

