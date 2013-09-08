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

@interface KHViewController ()
@property (retain) SKProduct* product;
@end

@implementation KHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[KHIAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest* request,SKProductsResponse* response)
     {
         NSLog(@"%d - %@",[KHIAPShare sharedHelper].iap.products.count,[KHIAPShare sharedHelper].iap.products);
         self.product = [[KHIAPShare sharedHelper].iap.products lastObject];
         UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
         [button setTitle:@"Buy" forState:UIControlStateNormal];
         button.frame = CGRectMake(10, 10, 300, 70);
         
         [button addTarget:self action:@selector(btnBuy:) forControlEvents:UIControlEventTouchUpInside];
         [self.view addSubview:button];
     }];
}
- (void) checkReceipt:(NSData*) receipt
{
    [[KHIAPShare sharedHelper].iap checkReceipt:receipt onCompletion:^(NSString *response, NSError *error) {
        NSDictionary* rec = [response toJSON];
        if([rec[@"status"] integerValue]==0)
        {
            [[KHIAPShare sharedHelper].iap provideContent:self.product.productIdentifier];
            NSLog(@"SUCCESS %@",response);
            NSLog(@"Pruchases %@",[KHIAPShare sharedHelper].iap.purchasedProducts);
        }
        else
        {
            NSLog(@"FAIL %@",response);
        }
    }];
}

- (void) btnBuy:(id) sender
{
    [[KHIAPShare sharedHelper].iap buyProduct:self.product onCompletion:^(SKPaymentTransaction *transaction) {
        if (transaction.error) {
             NSLog(@"Fail %@",[transaction.error localizedDescription]);
        }
        else if (transaction.transactionState == SKPaymentTransactionStatePurchased)
        {
            [self checkReceipt:transaction.transactionReceipt];
        }
        else if(transaction.transactionState == SKPaymentTransactionStateFailed) {
            NSLog(@"Fail");
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
