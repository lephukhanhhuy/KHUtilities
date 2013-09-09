//
//  KHSecondViewController.m
//  KHUtilities
//
//  Created by Huy Le on 9/9/13.
//  Copyright (c) 2013 Indygo Media. All rights reserved.
//

#import "KHSecondViewController.h"

@interface KHSecondViewController ()

@end

@implementation KHSecondViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem* barItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(btnDoneSelected:)];
    self.navigationItem.rightBarButtonItem = barItem;
    
    // Test admod
    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeFullBanner];
    bannerView_.adUnitID = @"a1512cd908c0537";
    bannerView_.rootViewController = self;
    [self.view addSubview:bannerView_];
    [bannerView_ loadRequest:[GADRequest request]];
}
- (void) btnDoneSelected:(id) sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
