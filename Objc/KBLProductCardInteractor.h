//
//  KBLProductCardInteractor.h
//  Korablik
//
//  Created by Kirill Shalankin on 16/08/2017.
//  Copyright © 2017 Kirill Shalankin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KBLProductCardInteractorInput <NSObject>

- (void)downloadProductCard:(NSString *)productCardID cityID:(NSString *)cityID;
- (void)favouritesAction:(id)product;
- (void)loginWasSuccessful;
- (void)downloadStoresWithOfferID:(NSString *)offerID cityID:(NSString *)cityID;
- (NSString *)getCityNameByCityID:(NSString *)cityID;
- (NSString *)getCatalogID;

@end

@protocol KBLProductCardInteractorOutput <NSObject>

- (void)productCardWasDownloaded:(id)productCardModel;
- (void)productReviewsWasDownloaded:(NSArray *)productReviews;
- (void)productsBlockWasDownloaded:(NSArray *)products;
- (void)accessoriesProductsWasDownloaded:(NSArray *)products;
- (void)favouritesActionDidFinishedWithMessage:(NSString *)message product:(id)product;
- (void)needLoginFirst;
- (void)storesWasDownloaded:(NSArray *)stores offerID:(NSString *)offerID;
- (NSString *)getSize;

@end

@interface KBLProductCardInteractor : NSObject <KBLProductCardInteractorInput>

@property (nonatomic, weak) id <KBLProductCardInteractorOutput> output;

@end
