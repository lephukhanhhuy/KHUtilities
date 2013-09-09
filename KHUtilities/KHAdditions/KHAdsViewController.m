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

- (void) initAdBannerAutoRefreshTimer:(int) refreshTime
{
    timeRefresh = refreshTime;
}

- (void) refreshBanner:(id) sender
{
    NSLog(@"Refresh in %@", [self class]);
    [bannerView_ loadRequest:[GADRequest request]];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (timeRefresh > 0) {
        timerRefresh = [NSTimer scheduledTimerWithTimeInterval:timeRefresh target:self selector:@selector(refreshBanner:) userInfo:nil repeats:YES];
    }
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (timerRefresh) {
        [timerRefresh invalidate];
        timerRefresh = nil;
    }
}
- (void)dealloc
{
    bannerView_ = nil;
}

@end
