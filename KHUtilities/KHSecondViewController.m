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
    
    [self initAdBannerWithSize:kGADAdSizeBanner];
    [self initAdBannerAutoRefreshTimer:10];
}
- (void) btnDoneSelected:(id) sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
