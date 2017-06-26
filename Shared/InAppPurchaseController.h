//
//  InAppPurchaseController.h
//  KIDPedia
//
//  Created by Acai on 04/02/11.
//  Copyright 2011 Aca Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import<StoreKit/StoreKit.h>
@class InAppPurchaseController;

@protocol InAppPurchaseControllerDelegate
- (void) purchaseController: (InAppPurchaseController *) controller didLoadInfo: (SKProduct *) products;
- (void) purchaseController: (InAppPurchaseController *) controller didFailLoadProductInfo: (NSError *) error;
- (void) purchaseController: (InAppPurchaseController *) controller didFinishPaymentTransaction: (SKPaymentTransaction *) transaction;
- (void) purchaseController: (InAppPurchaseController *) controller didFailPaymentTransactionWithError: (NSError *) error;
@end

@interface InAppPurchaseController : NSObject<SKProductsRequestDelegate, SKPaymentTransactionObserver> {
	NSString   *strPurchaseId_;
	SKProductsRequest *request;
	id <InAppPurchaseControllerDelegate>   delegate_;
}
@property(assign) id <InAppPurchaseControllerDelegate> delegate_;
@property(copy)     NSString    *strPurchaseId_;

- (void)    loadProductsInfo;
- (void)    makePurchase: (SKProduct *) product;
- (BOOL) isPresentNonFinishedTransaction;
@end
