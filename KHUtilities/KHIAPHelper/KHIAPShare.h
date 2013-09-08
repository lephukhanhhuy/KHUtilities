//
//  KHIAPShare.h
//  KHUtilities
//
//  Created by Huy Le on 8/9/13.
//  Copyright (c) 2013 Indygo Media. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAPHelper.h"

@interface KHIAPShare : NSObject
@property (nonatomic,strong) IAPHelper *iap;

+ (KHIAPShare *) sharedHelper;

@end
