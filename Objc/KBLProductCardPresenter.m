//
//  KBLProductCardPresenter.m
//  Korablik
//
//  Created by Kirill Shalankin on 16/08/2017.
//  Copyright © 2017 Kirill Shalankin. All rights reserved.
//

#import "KBLProductCardPresenter.h"
#import "KBLAlertView.h"
#import "KBLCityService.h"
#import "KBLTrackingService.h"

@interface KBLProductCardPresenter ()

@property (strong, nonatomic) NSString *productCardID;

/*
 Нам не нужно обновлять блоки товаров, если был показан модуль логина, перед добавлением в избранное
 */
@property (assign, nonatomic) BOOL noNeededUpdateBlocks;

@property (strong, nonatomic) NSString *size;
@property (strong, nonatomic) NSString *cityID;

@end

@implementation KBLProductCardPresenter

- (instancetype)init {
    self = [super init];
    if (self) {
        _cityID = [[KBLCityService sharedInstance] getDefaultCityID];
    }
    return self;
}

#pragma mark - KBLProductCardModuleConfiguration

- (void)configureWithProductCardID:(NSString *)productCardID title:(NSString *)title {
    self.productCardID = productCardID;
    [self.view setupTitle:title];
}

- (void)configureWithProductCardID:(NSString *)productCardID size:(NSString *)size title:(NSString *)title {
    [self configureWithProductCardID:productCardID title:title];
    self.size = size;
}

- (void)configureWithProductCardID:(NSString *)productCardID title:(NSString *)title cityID:(NSString *)cityID {
    [self configureWithProductCardID:productCardID title:title];
    if (cityID.length) {
        self.cityID = cityID;
    }
}

#pragma mark - KBLProductCardViewOutput

- (void)viewDidReady {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.interactor downloadProductCard:self.productCardID cityID:self.cityID];
    });
}

- (void)reviewsCellDidTapped:(NSArray *)reviews averageRating:(CGFloat)rating {
    [self.router showReviews:reviews averageRating:rating productID:self.productCardID];
}

- (void)pickupDidTappedWithOfferID:(NSString *)offerID {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.interactor downloadStoresWithOfferID:offerID cityID:self.cityID];
    });
}

- (void)deliveryDidTapped {
    [self.router showDeliveryModuleWithCityID:[self getCityID]];
}

- (void)descriptionDidTapped:(id)model {
    [self.router showDescriptionWithModel:model];
}

- (void)cartDidTapped {
    [self.router showCartModule];
}

- (void)quickOrderDidTappedWithPoduct:(id)product isDelivery:(BOOL)isDelivery {
    [self.router showQuickOrderModuleWithProduct:product type:isDelivery? KBLQuickOrderModuleTypeDelivery: KBLQuickOrderModuleTypePickup];
}

- (void)quickOrderDidTappedPVZWithPoduct:(id)product {
    [self.router showQuickOrderModuleWithProduct:product type:KBLQuickOrderModuleTypePVZ];
}

- (void)extendedCategoryDidTappedWithType:(NSString *)groupType groupID:(NSString *)groupID name:(NSString *)name {
    [self.router showCatalogListWithType:groupType groupID:groupID name:name];
}

- (void)colorWasChanged:(NSString *)productID {
    self.productCardID = productID;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.interactor downloadProductCard:self.productCardID cityID:self.cityID];
    });
}

- (NSString *)getCityName {
    return [self.interactor getCityNameByCityID:self.cityID];
}

- (NSString *)getCityID {
    return self.cityID;
}

- (void)packageDidTappedWithProductID:(NSString *)productID {
    self.productCardID = productID;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.interactor downloadProductCard:self.productCardID cityID:self.cityID];
    });
}

#pragma mark - KBLCollectionViewOutput

- (void)productCellDidTapped:(NSString *)productID title:(NSString *)title {
    [self.router showProductCardWithID:productID title:title];
}

- (void)allProductsDidTappedIsSale:(BOOL)isSale title:(NSString *)title {
    [self.router showProductListWithCatID:[self.interactor getCatalogID] title:title];
}

- (void)favouritesDidTapped:(id)product {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.interactor favouritesAction:product];
    });
}

- (void)alertDidTapped {
    [self.router showCartModule];
}

- (void)videoClipsDidTappedWithURLs:(NSArray *)videoURLs {
    [self.router showVideoClipsModuleWithURLs:videoURLs];
}

- (void)promoDidTapped:(NSString *)promoID promoName:(NSString *)name {
    [self.router showPromoCardWithID:promoID promoName:name];
}

- (void)pvzDidTapped {
    [self.router showPVZModuleWithCityID:[self getCityID]];
}

- (void)documentsDidTappedWithURL:(NSURL *)docURL {
    [self.router showDocumentWithURL:docURL];
}

#pragma mark - KBLProductCardInteractorOutput

- (void)productCardWasDownloaded:(id)productCardModel {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view configureWithData:productCardModel];
    });
    
    [[KBLTrackingService new] firebaseOpenProductCardEventWith:productCardModel];
}

- (void)productReviewsWasDownloaded:(NSArray *)productReviews {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view updateReviewsCount:productReviews];
    });
}

- (void)productsBlockWasDownloaded:(NSArray *)products {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view configureProductsBlock:products];
    });
}

- (void)accessoriesProductsWasDownloaded:(NSArray *)products {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view configureAccessoriesProducts:products];
    });
}

- (void)favouritesActionDidFinishedWithMessage:(NSString *)message product:(id)product {
    if (self.noNeededUpdateBlocks) {
        self.noNeededUpdateBlocks = NO;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[KBLAlertView sharedInstance] showWithText:message];
        [self.view reloadCellWichContainsProduct:product];
    });
}

- (void)needLoginFirst {
    self.noNeededUpdateBlocks = YES;
    [self.router showLoginModuleWithDelegate:self];
}

- (void)storesWasDownloaded:(NSArray *)stores offerID:(NSString *)offerID {
    [self.router showShopListWithStores:stores offerID:offerID cityID:self.cityID];
}

- (NSString *)getSize {
    return self.size;
}

#pragma mark - KBLLoginModuleDelegate

- (void)loginOperationWasSuccessful {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.interactor loginWasSuccessful];
    });
}

@end
