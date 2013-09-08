//
//  KHUtilities.h
//  KHUtilities
//
//  Created by Huy Le on 8/9/13.
//  Copyright (c) 2013 Indygo Media. All rights reserved.
//

#import <Foundation/Foundation.h>

// http://www.saturngod.net/uicolor-macro-for-objc
#define rgb(R,G,B) [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1.0]
#define rgba(R,G,B,A) [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:A]

@interface KHUtilities : NSObject

// Copyright (c) 2013 Ben Gordon
+ (UIColor *) colorFromHex:(NSString *)hexString;

@end
