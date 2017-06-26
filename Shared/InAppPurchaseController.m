//
//  InAppPurchaseController.m
//  KIDPedia
//
//  Created by Acai on 04/02/11.
//  Copyright 2011 Aca Technologies. All rights reserved.
//

#import "InAppPurchaseController.h"


@implementation InAppPurchaseController
@synthesize strPurchaseId_;
@synthesize delegate_;

- (id) init
{
	if(self = [super init])
		
	{
		[ [SKPaymentQueue defaultQueue] addTransactionObserver: self];
	}
	return self;	
}

- (void) loadProductsInfo
{
	request = [ [SKProductsRequest alloc] initWithProductIdentifiers: [NSSet setWithObject: strPurchaseId_]];
	[request setDelegate: self];
	[request start];
}

- (void) makePurchase: (SKProduct *) product
{
	if(![SKPaymentQueue canMakePayments])
	{
		if (delegate_) {
			[delegate_ purchaseController: self didFailPaymentTransactionWithError: [NSError errorWithDomain: @"payMentDomain" code: 123 userInfo: [NSDictionary dictionaryWithObject: @"can not make paiments" forKey: NSLocalizedDescriptionKey]]];
		}
	}
	SKPayment *payment = [SKPayment paymentWithProductIdentifier: product.productIdentifier];	
	[ [SKPaymentQueue defaultQueue] addPayment: payment];
}

- (BOOL) isPresentNonFinishedTransaction
{
	NSArray *arrTransactions = [ [SKPaymentQueue defaultQueue] transactions];
	for(SKPaymentTransaction *transaction in arrTransactions)
	{
		if([transaction.payment.productIdentifier isEqualToString: strPurchaseId_])
		{
			if(transaction.transactionState == SKPaymentTransactionStatePurchasing)
			{
				return YES;
			}
			else if(transaction.transactionState == SKPaymentTransactionStateFailed)
			{
				[ [SKPaymentQueue defaultQueue] finishTransaction: transaction];
			}
		}
	}
	return NO;
}
#pragma mark ---------------request delegate-----------------

- (void)requestDidFinish:(SKRequest *)request
{
}
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
	if (delegate_) {
		[delegate_ purchaseController: self didFailLoadProductInfo: error];

	}
}
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
	NSArray *invalidIdentifiers = [response invalidProductIdentifiers];
	NSArray *products = [response products];
	for(SKProduct *product in products)
	{
		NSString *strId = product.productIdentifier;
		if([strId isEqualToString: strPurchaseId_])
		{
			if (delegate_) {
				[delegate_ purchaseController: self didLoadInfo: product];
			}
			return;
		}
	}
	if([invalidIdentifiers count])
	{
		if (delegate_) {
			[delegate_ purchaseController: self didFailLoadProductInfo: [NSError errorWithDomain: @"purchaseDomain" code: 143 userInfo: [NSDictionary dictionaryWithObject: @"No Products found" forKey: NSLocalizedDescriptionKey]]];
		}
	}
}
#pragma mark -------------------transaction observer-------------------
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
	for(SKPaymentTransaction *transaction in transactions)
	{
		SKPayment *payment = [transaction payment];
		if([payment.productIdentifier isEqualToString: strPurchaseId_])
		{
			if(transaction.transactionState == SKPaymentTransactionStatePurchasing)
			{
			}
			else if(transaction.transactionState == SKPaymentTransactionStatePurchased)
			{
				if (delegate_) {
					[delegate_ purchaseController: self didFinishPaymentTransaction: transaction];
				}
				[queue finishTransaction: transaction];
			}
			else if(transaction.transactionState == SKPaymentTransactionStateFailed)
			{
				if (delegate_) {
					[delegate_ purchaseController: self didFailPaymentTransactionWithError: [NSError errorWithDomain: @"purchaseDomain" code: 1542 userInfo: nil]];
				}
				[queue finishTransaction: transaction];
			}
			else if(transaction.transactionState == SKPaymentTransactionStateRestored)
			{
			}
		}
	}
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error{
}

// Sent when all transactions from the user's purchase history have successfully been added back to the queue.
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
}
- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
}
- (void) dealloc
{
	delegate_ =nil;
	[request cancel];
	[request release];
	[strPurchaseId_ release];
	[ [SKPaymentQueue defaultQueue] removeTransactionObserver: self];
	[super dealloc];
}
@end
