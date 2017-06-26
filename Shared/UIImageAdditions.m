//
//  UIImageAdditions.m
//  KIDPedia
//
//  Created by Acai on 02/02/11.
//  Copyright 2011 Aca Technologies. All rights reserved.
//

#import "UIImageAdditions.h"

@implementation  UIImage(Extended)
NSMutableDictionary *thumbnailCache;
+(UIImage*)thumbnailImage:(NSString*)fileName
{
	if (!thumbnailCache) {
		thumbnailCache = [[NSMutableDictionary alloc]init];
	}
	UIImage *thumbnail = [thumbnailCache objectForKey:fileName];
	NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
	if([systemVersion isEqualToString:@"3.1.2"] ||
	   [systemVersion isEqualToString:@"3.1.3"] )
	{
		fileName = [NSString stringWithFormat:@"2G%@",fileName];
	}
	if (nil == thumbnail)
	{
		NSString *thumbnailFile = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], fileName];
		thumbnail =  [UIImage imageWithContentsOfFile:thumbnailFile];
		[thumbnailCache setObject:thumbnail forKey:fileName];
	}
	return thumbnail;
}
+(void)clearThumbnailCache
{
	if ([thumbnailCache count]>0) {
		[thumbnailCache removeAllObjects];
	}
}
@end
