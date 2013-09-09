//
//  KHAdsViewController.m
//  KHUtilities
//
//  Created by Huy Le on 9/9/13.
//  Copyright (c) 2013 Indygo Media. All rights reserved.
//

#import "KHAdsViewController.h"

@implementation KHAdsViewController

- (void) initAdBannerWithSize:(GADAdSize) size
{
    bannerView_ = [[GADBannerView alloc] initWithAdSize:size];
    bannerView_.adUnitID = kAdmodId;
    bannerView_.rootViewController = self;
    [self.view addSubview:bannerView_];
    
    // Load first request
    [bannerView_ loadRequest:[GADRequest request]];
}

- (void)dealloc
{
    bannerView_ = nil;
}

@end
