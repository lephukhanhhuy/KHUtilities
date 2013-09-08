//
//  IAPHelper.h
//
//  Original Created by Ray Wenderlich on 2/28/11.
//  Created by saturngod on 7/9/12.
//  Copyright 2011 Ray Wenderlich. All rights reserved.
//

/*
 Edited by Huy Le on Sept 2013
 - Change block name for inform
 - Update check receipt with detect sanbox or production
 - Ref: http://stackoverflow.com/questions/9677193/ios-storekit-can-i-detect-when-im-in-the-sandbox
 */

#import <Foundation/Foundation.h>
#import "StoreKit/StoreKit.h"


typedef void (^IAPProductsResponseBlock)(SKProductsRequest* request , SKProductsResponse* response);

typedef void (^IAPBuyProductCompleteResponseBlock)(SKPaymentTransaction* transaction);

typedef void (^IAPCheckReceiptCompleteResponseBlock)(NSString* response,NSError* error);

typedef void (^IAPRestoreProductsCompleteResponseBlock) (SKPaymentQueue* payment,NSError* error);

@interface IAPHelper : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (nonatomic,strong) NSSet *productIdentifiers;
@property (nonatomic,strong) NSArray * products;
@property (nonatomic,strong) NSMutableSet *purchasedProducts;
@property (nonatomic,strong) SKProductsRequest *request;
@property (nonatomic) BOOL production;

- (void)requestProductsWithCompletion:(IAPProductsResponseBlock)completion;
- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;

- (void)buyProduct:(SKProduct *)productIdentifier onCompletion:(IAPBuyProductCompleteResponseBlock)completion;

- (void)restoreProductsWithCompletion:(IAPRestoreProductsCompleteResponseBlock)completion;

- (BOOL)isPurchasedProductsIdentifier:(NSString*)productID;

- (void)checkReceipt:(NSData*)receiptData onCompletion:(IAPCheckReceiptCompleteResponseBlock)completion;

- (void)checkReceipt:(NSData*)receiptData AndSharedSecret:(NSString*)secretKey onCompletion:(IAPCheckReceiptCompleteResponseBlock)completion;

- (void)provideContent:(NSString *)productIdentifier;
@end
