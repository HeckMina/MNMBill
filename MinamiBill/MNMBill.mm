//
//  MNMBill.m
//  crazyquad
//
//  Created by Heck on 14/11/13.
//  Copyright (c) 2014年 minamivision. All rights reserved.
//

#import "MNMBill.h"
MNMBill* g_Instance=nil;

@implementation MNMBill
+(MNMBill*)sharedInstance
{
    if (nil==g_Instance)
    {
        g_Instance=[[[MNMBill alloc]init]retain];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:g_Instance];
    }
    return g_Instance;
}

+(BOOL)canPay
{
    return [SKPaymentQueue canMakePayments];
}

-(void)makePaymentWithProductID:(NSString *)productID
{
    NSArray *products=[[NSArray alloc]initWithObjects:productID,nil];
    NSSet * set=[NSSet setWithArray:products];
    SKProductsRequest * req=[[SKProductsRequest alloc]initWithProductIdentifiers:set];
    req.delegate=self;
    [req start];
    [products release];
}

#pragma skrequest delegate
-(void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    //reset charge state to not in charging
    NSLog(@"request did fail with error %@",error);
}

-(void)requestDidFinish:(SKRequest *)request
{
    //one bill have finished
    NSLog(@"request did finished");
}

#pragma sk product request delegate
-(void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
    NSLog(@"remove transaction from queue");
}

-(void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    NSLog(@"restore complete transaction fail with error %@",error);
}

-(void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray *)downloads
{
    NSLog(@"update downloads");
}

-(void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"payment restore complete transaction finished");
}

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSLog(@"try to get products from itunes store");
    if (response.products.count<=0) {
        NSLog(@"cannot get product info from itune store");
        return;
    }
    else
    {
        NSLog(@"get the product and begin to pay the bill");
        SKPayment*payment=[SKPayment paymentWithProduct:[response products][0]];
        [[SKPaymentQueue defaultQueue]addPayment:payment];
        [request autorelease];
    }
}

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    NSLog(@"updated transactions");
    for (SKPaymentTransaction*transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"purchasing...");
                break;
            case SKPaymentTransactionStatePurchased:
                NSLog(@"purchased..");
                [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"faild");
                [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"restored");
                break;
            case SKPaymentTransactionStateDeferred:
                NSLog(@"deferred");
                break;
            default:
                break;
        }
    }
}
@end