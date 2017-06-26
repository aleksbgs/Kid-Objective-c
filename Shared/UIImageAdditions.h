//
//  UIImageAdditions.h
//  KIDPedia
//
//  Created by Acai on 02/02/11.
//  Copyright 2011 Aca Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIImage(Extended)
+ (UIImage*)thumbnailImage:(NSString*)fileName;
+(void)clearThumbnailCache;
@end
