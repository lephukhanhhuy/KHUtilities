//
//  KHViewController.m
//  KHUtilities
//
//  Created by Huy Le on 8/9/13.
//  Copyright (c) 2013 Indygo Media. All rights reserved.
//

#import "KHViewController.h"
#import "KHIAPShare.h"
#import "NSString+Base64.h"
#import "KHSecondViewController.h"

@interface KHViewController ()
@property (retain) SKProduct* product;
@end

@implementation KHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Test request iap and buy iap
    [[KHIAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest* request,SKProductsResponse* response)
     {
         NSLog(@"%d - %@",[KHIAPShare sharedHelper].iap.products.count,[KHIAPShare sharedHelper].iap.products);
         self.product = [[KHIAPShare sharedHelper].iap.products lastObject];
         UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
         [button setTitle:@"Buy" forState:UIControlStateNormal];
         button.frame = CGRectMake(10, 300, 300, 70);
         
         [button addTarget:self action:@selector(btnBuy:) forControlEvents:UIControlEventTouchUpInside];
         [self.view addSubview:button];
     }];
    
    [self initAdBannerWithSize:kGADAdSizeMediumRectangle];
    [self initAdBannerAutoRefreshTimer:5];
}
- (void) btnBuy:(id) sender
{
    [[KHIAPShare sharedHelper].iap buyProduct:self.product onCompletion:^(SKPaymentTransaction *transaction) {
        if (transaction.error) {
             NSLog(@"Fail %@",[transaction.error localizedDescription]);
        }
        else if (transaction.transactionState == SKPaymentTransactionStatePurchased)
        {
            [[KHIAPShare sharedHelper].iap checkReceipt:transaction.transactionReceipt onCompletion:^(NSString *response, NSError *error) {
                NSDictionary* rec = [response toJSON];
                if([rec[@"status"] integerValue]==0)
                {
                    [[KHIAPShare sharedHelper].iap provideContent:self.product.productIdentifier];
                    NSLog(@"SUCCESS %@",response);
                }
                else
                {
                    NSLog(@"FAIL %@",response);
                }
            }];
        }
        else if(transaction.transactionState == SKPaymentTransactionStateFailed) {
            NSLog(@"Fail");
        }
    }];
}
- (IBAction)btnPlay:(id)sender {
    KHSecondViewController* vc = [[KHSecondViewController alloc] initWithNibName:@"KHSecondViewController" bundle:nil];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}

@end
