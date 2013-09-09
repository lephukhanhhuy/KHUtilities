//
//  KHAdsViewController.h
//  KHUtilities
//
//  Created by Huy Le on 9/9/13.
//  Copyright (c) 2013 Indygo Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"

#define kAdmodId @"a1512cd908c0537"

@interface KHAdsViewController : UIViewController
{
    GADBannerView*  bannerView_;
    
    int             timeRefresh;
    NSTimer*        timerRefresh;
}

- (void) initAdBannerWithSize:(GADAdSize) size;
- (void) initAdBannerAutoRefreshTimer:(int) refreshTime;

@end
