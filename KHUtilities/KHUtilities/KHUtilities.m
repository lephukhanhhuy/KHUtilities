//
//  KHUtilities.m
//  KHUtilities
//
//  Created by Huy Le on 8/9/13.
//  Copyright (c) 2013 Indygo Media. All rights reserved.
//

#import "KHUtilities.h"

@implementation KHUtilities

#pragma mark - UIColor from Hex
+ (UIColor *) colorFromHex:(NSString *)hexString {
    unsigned rgbValue = 0;
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end
