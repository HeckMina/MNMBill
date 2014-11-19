//
//  MNMBill.h
//  crazyquad
//
//  Created by Heck on 14/11/13.
//  Copyright (c) 2014年 minamivision. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
@interface MNMBill : NSObject<SKProductsRequestDelegate,SKPaymentTransactionObserver>
+(MNMBill*)sharedInstance;
+(BOOL)canPay;
-(void)makePaymentWithProductID:(NSString*)productID;
@end
