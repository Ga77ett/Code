//
//  KBLProductCardInteractor.m
//  Korablik
//
//  Created by Kirill Shalankin on 16/08/2017.
//  Copyright © 2017 Kirill Shalankin. All rights reserved.
//


#import "KBLProductCardInteractor.h"
#import "KBLGetProductCardNetworkOperation.h"
#import "KBLGetCatalogProductsNetworkOperation.h"
#import "KBLGetProductCardMapping.h"
#import "KBLGetProductReviewsNetworkOperation.h"
#import "KBLGetProductReviewsMapping.h"
#import "KBLGetProductsBlockNetworkOperation.h"
#import "KBLGetCatalogProductsListMapping.h"
#import "KBLAddToFavouritesNetworkOperation.h"
#import "KBLDeleteFavouritesNetworkOperation.h"
#import "KBLGetRemainStatusNetworkOperation.h"
#import "KBLGetRemainStatusMapping.h"
#import "KBLProductPreviewModel.h"
#import "KBLProductCardModel.h"
#import "KBLUserDefaultKeys.h"
#import "KBLRecentlyWatched.h"
#import "KBLGetShopsMapping.h"
#import "KBLTrackingService.h"
#import "KBLBasketService.h"
#import "KBLCityService.h"
#import "KBLKeychanService.h"
#import "KBLNewProductCard.h"
#import "KBLGetDeliveryInfoNetworkOperation.h"
#import "KBLGetShortProductInfoNetworkOperation.h"

@interface KBLProductCardInteractor ()

@property (strong, nonatomic) KBLNewProductCard *tempProduct; // Кандидат на добавление в избранное
@property (strong, nonatomic) NSString *catID; // Текущий каталог, нужен для перехода на похожие товары

@end

@implementation KBLProductCardInteractor

#pragma mark - KBLProductCardInteractorInput

- (void)downloadProductCard:(NSString *)productCardID cityID:(NSString *)cityID {
    [self downloadProductReviews:productCardID];
    
    KBLGetProductCardNetworkOperation *productCardOperation = [[KBLGetProductCardNetworkOperation alloc]
                                                               initWithProductIDs:@[productCardID] cityID:cityID];
    [productCardOperation addOperationWithSuccess:^(NSDictionary *response) {
        if ([response[@"error_code"] integerValue] == 0) {
            [[KBLRecentlyWatched new] productIDJustWatched:productCardID];
            KBLNewProductCard *card = [KBLGetProductCardMapping getNewProductCard:response];
            self.catID = card.catID;
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self downloadProductsBlockWithCatID:card.catID currentProductID:card.productID.integerValue];
                
                if (card.accessories && card.accessories.count) {
                    [self downloadProductsWithIDs:card.accessories];
                }
            });
            
            [self.output productCardWasDownloaded:card];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)downloadProductReviews:(NSString *)productCardID {
    KBLGetProductReviewsNetworkOperation *reviewsOperation = [[KBLGetProductReviewsNetworkOperation alloc]
                                                              initWithProductCardID:productCardID];
    [reviewsOperation addOperationWithSuccess:^(NSDictionary *response) {
        NSArray *reviews = [KBLGetProductReviewsMapping getProductReviews:response];
        if (reviews) {
            [self.output productReviewsWasDownloaded:[KBLGetProductReviewsMapping getProductReviews:response]];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)downloadProductsBlockWithCatID:(NSString *)catID currentProductID:(NSInteger)currentProductID {
    KBLGetCatalogProductsNetworkOperation *getCatalogOperation = [[KBLGetCatalogProductsNetworkOperation alloc]
                                                                  initWithGroupID:catID
                                                                  groupType:@"cats_type"
                                                                  limit:11
                                                                  offset:0
                                                                  sortString:@"rating_desc"
                                                                  filterService:nil
                                                                  catID:nil];

    [getCatalogOperation addOperationWithSuccess:^(NSDictionary *response, NSString *cityID) {
        NSMutableArray *arr = [@[] mutableCopy];
        NSArray *products = [KBLGetCatalogProductsListMapping getNewProducts:response cityID:cityID productTypeString:@"cats_type"];
        for (KBLProductListModel *product in products) {
            if (product.productID != currentProductID) {
                [arr addObject:product];
            }
        }
        
        [self.output productsBlockWasDownloaded:arr];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)downloadProductsWithIDs:(NSArray *)ids {
    KBLGetShortProductInfoNetworkOperation *shortInfoOperation = [[KBLGetShortProductInfoNetworkOperation alloc] initWithIDs:ids];
    [shortInfoOperation addOperationWithSuccess:^(NSDictionary *response) {
        [self.output accessoriesProductsWasDownloaded:[KBLGetProductCardMapping getProductsInfo:response]];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)favouritesAction:(KBLNewProductCard *)product {
    if ([KBLKeychanService userTokenIsExist]) {
        if (product.isFavourite) {
            [self deleteFromFavourites:product];
            
        } else {
            [self addToFavourites:product];
        }
        
    } else {
        self.tempProduct = product;
        [self.output needLoginFirst];
    }
}

- (void)addToFavourites:(KBLNewProductCard *)product {
    KBLProductOffer *offer = product.offers.firstObject;
    [[KBLTrackingService new] productWasAddedToFavouritesWithName:product.productName price:product.currentPrice];
    
    KBLAddToFavouritesNetworkOperation *addOperation = [[KBLAddToFavouritesNetworkOperation alloc]
                                                        initWithOfferID:[NSString stringWithFormat:@"%zd", offer.offerID]];
    [addOperation addOperationWithSuccess:^(NSDictionary *response) {
        if ([response[@"error_code"] integerValue] == 0) {
            product.isFavourite = YES;
            [self.output favouritesActionDidFinishedWithMessage:@"Товар добавлен в избранное" product:product];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)deleteFromFavourites:(KBLNewProductCard *)product {
    KBLProductOffer *offer = product.offers.firstObject;

    KBLDeleteFavouritesNetworkOperation *deleteOperation = [[KBLDeleteFavouritesNetworkOperation alloc]
                                                            initOfferID:[NSString stringWithFormat:@"%zd", offer.offerID]];
    [deleteOperation addOperationWithSuccess:^(NSDictionary *response) {
        if ([response[@"error_code"] integerValue] == 0) {
            product.isFavourite = NO;
            [self.output favouritesActionDidFinishedWithMessage:@"Товар удален из избранного" product:product];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)loginWasSuccessful {
    [self addToFavourites:self.tempProduct];
    self.tempProduct = nil;
}

- (void)downloadStoresWithOfferID:(NSString *)offerID cityID:(NSString *)cityID {
    if (!cityID || cityID.length == 0) {
        NSString *defaultCityID = [[KBLCityService sharedInstance] getDefaultCityID];;
        cityID = defaultCityID;
    }
    
    KBLGetRemainStatusNetworkOperation *remainStatusOperation = [[KBLGetRemainStatusNetworkOperation alloc]
                                                                 initWithOfferID:offerID count:1 cityID:cityID];
    [remainStatusOperation addOperationWithSuccess:^(NSDictionary *response) {
        NSArray *stores = [KBLGetRemainStatusMapping getStoresWithResponse:response];
        [self.output storesWasDownloaded:stores offerID:offerID];
    } failure:^(NSError *error) {
        
    }];
}

- (NSString *)getCityNameByCityID:(NSString *)cityID {
    KBLCityModel *model = cityID? [[KBLCityService sharedInstance] getCityByID:cityID]: [[KBLCityService sharedInstance] getDefaultCity];
    return model.name;
}

- (NSString *)getCatalogID {
    return self.catID;
}

@end
