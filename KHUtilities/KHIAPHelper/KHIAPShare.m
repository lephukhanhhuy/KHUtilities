//
//  KHIAPShare.m
//  KHUtilities
//
//  Created by Huy Le on 8/9/13.
//  Copyright (c) 2013 Indygo Media. All rights reserved.
//

#import "KHIAPShare.h"

#if ! __has_feature(objc_arc)
#error You need to either convert your project to ARC or add the -fobjc-arc compiler flag to IAPHelper.m.
#endif

@implementation KHIAPShare

static KHIAPShare * _sharedHelper;

+ (KHIAPShare *) sharedHelper {
    
    if (_sharedHelper != nil) {
        return _sharedHelper;
    }
    _sharedHelper = [[KHIAPShare alloc] init];
    _sharedHelper.iap = nil;
    return _sharedHelper;
}

@end
