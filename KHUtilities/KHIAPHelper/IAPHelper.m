//
//  IAPHelper.m
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

#import "IAPHelper.h"
#import "NSString+Base64.h"

#define kProductionStatusFail 21007

#if ! __has_feature(objc_arc)
#error You need to either convert your project to ARC or add the -fobjc-arc compiler flag to IAPHelper.m.
#endif


@interface IAPHelper()
@property (nonatomic,copy) IAPProductsResponseBlock requestProductsBlock;
@property (nonatomic,copy) IAPBuyProductCompleteResponseBlock buyProductCompleteBlock;
@property (nonatomic,copy) IAPRestoreProductsCompleteResponseBlock restoreCompletedBlock;
@property (nonatomic,copy) IAPCheckReceiptCompleteResponseBlock checkReceiptCompleteBlock;

@property (nonatomic) BOOL production;

@property (nonatomic,strong) NSMutableData* receiptRequestData;

// Use for recall receipt method
@property (nonatomic,strong) NSString* secretKey;
@property (nonatomic,strong) NSData* receiptData;
@end

@implementation IAPHelper

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers {
    if ((self = [super init])) {
        
        // Default is production. This be changed to sanbox when get status = kProductionStatusFail
        self.production = YES;
        
        // Store product identifiers
        _productIdentifiers = productIdentifiers;
        
        // Check for previously purchased products
        NSMutableSet * purchasedProducts = [NSMutableSet set];
        for (NSString * productIdentifier in _productIdentifiers) {
            BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
            if (productPurchased) {
                [purchasedProducts addObject:productIdentifier];
                
            }
        }
        
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
        self.purchasedProducts = purchasedProducts;
        
    }
    return self;
}

-(BOOL)isPurchasedProductsIdentifier:(NSString*)productID
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:productID];
}

- (void)requestProductsWithCompletion:(IAPProductsResponseBlock)completion {
    
    self.request = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
    _request.delegate = self;
    self.requestProductsBlock = completion;
    
    [_request start];
    
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    self.products = response.products;
    self.request = nil;
    
    if(_requestProductsBlock) {
        _requestProductsBlock (request,response);
    }
    
}

- (void)recordTransaction:(SKPaymentTransaction *)transaction {
    // TODO: Record the transaction on the server side...
}

- (void)provideContent:(NSString *)productIdentifier {
    
    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [_purchasedProducts addObject:productIdentifier];
    
    
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    
    
    
    [self recordTransaction: transaction];
    
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
    if(_buyProductCompleteBlock)
    {
        _buyProductCompleteBlock(transaction);
    }
    
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    
    
    [self recordTransaction: transaction];
    [self provideContent: transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
    if(_buyProductCompleteBlock!=nil)
    {
        _buyProductCompleteBlock(transaction);
    }
    
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"Transaction error: %@ %d", transaction.error.localizedDescription,transaction.error.code);
    }
    
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    if(_buyProductCompleteBlock) {
        _buyProductCompleteBlock(transaction);
    }
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
}

- (void)buyProduct:(SKProduct *)productIdentifier onCompletion:(IAPBuyProductCompleteResponseBlock)completion {
    
    self.buyProductCompleteBlock = completion;
    
    self.restoreCompletedBlock = nil;
    SKPayment *payment = [SKPayment paymentWithProduct:productIdentifier];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
}

-(void)restoreProductsWithCompletion:(IAPRestoreProductsCompleteResponseBlock)completion {
    
    //clear it
    self.buyProductCompleteBlock = nil;
    
    self.restoreCompletedBlock = completion;
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    
    NSLog(@"Transaction error: %@ %d", error.localizedDescription,error.code);
    if(_restoreCompletedBlock) {
        _restoreCompletedBlock(queue,error);
    }
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    if(_restoreCompletedBlock) {
        _restoreCompletedBlock(queue,nil);
    }
    
}

- (void)checkReceipt:(NSData*)receiptData onCompletion:(IAPCheckReceiptCompleteResponseBlock)completion
{
    [self checkReceipt:receiptData AndSharedSecret:nil onCompletion:completion];
}
- (void)checkReceipt:(NSData*)receiptData AndSharedSecret:(NSString*)secretKey onCompletion:(IAPCheckReceiptCompleteResponseBlock)completion
{
    self.receiptData = receiptData;
    self.secretKey = secretKey;
    
    self.checkReceiptCompleteBlock = completion;
    
    NSError *jsonError = nil;
    NSString *receiptBase64 = [NSString base64StringFromData:receiptData length:[receiptData length]];
    
    
    NSData *jsonData = nil;
    
    if(secretKey !=nil && ![secretKey isEqualToString:@""]) {
        
        jsonData = [NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithObjectsAndKeys:receiptBase64,@"receipt-data",
                                                            secretKey,@"password",
                                                            nil]
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&jsonError];
        
    }
    else {
        jsonData = [NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                            receiptBase64,@"receipt-data",
                                                            nil]
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&jsonError
                    ];
    }
    
    
    //    NSString* jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSURL *requestURL = nil;
    if(_production)
    {
        requestURL = [NSURL URLWithString:@"https://buy.itunes.apple.com/verifyReceipt"];
    }
    else {
        requestURL = [NSURL URLWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"];
    }
    
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:requestURL];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:jsonData];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if(conn) {
        self.receiptRequestData = [[NSMutableData alloc] init];
    } else {
        NSError* error = nil;
        NSMutableDictionary* errorDetail = [[NSMutableDictionary alloc] init];
        [errorDetail setValue:@"Can't create connection" forKey:NSLocalizedDescriptionKey];
        error = [NSError errorWithDomain:@"IAPHelperError" code:100 userInfo:errorDetail];
        if(_checkReceiptCompleteBlock) {
            _checkReceiptCompleteBlock(nil,error);
        }
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Cannot transmit receipt data. %@",[error localizedDescription]);
    
    if(_checkReceiptCompleteBlock) {
        _checkReceiptCompleteBlock(nil,error);
    }
    
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.receiptRequestData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.receiptRequestData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *response = [[NSString alloc] initWithData:self.receiptRequestData encoding:NSUTF8StringEncoding];
    NSDictionary* rec = [response toJSON];
    if([rec[@"status"] integerValue] == kProductionStatusFail)
    {
        NSLog(@"Fail in Production to Sanbox and checkReceipt again");
        self.production = NO;
        [self checkReceipt:self.receiptData AndSharedSecret:self.secretKey onCompletion:_checkReceiptCompleteBlock];
    }
    else
    {
        self.receiptData = nil;
        self.secretKey = nil;
        if(_checkReceiptCompleteBlock) {
            _checkReceiptCompleteBlock(response,nil);
        }
    }
}
- (void)dealloc
{
    self.requestProductsBlock = nil;
    self.buyProductCompleteBlock = nil;
    self.restoreCompletedBlock = nil;
    self.checkReceiptCompleteBlock = nil;
    // Avoid crash
    self.request.delegate = nil;
}
@end
