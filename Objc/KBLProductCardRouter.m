
//
//  KBLProductCardRouter.m
//  Korablik
//
//  Created by Kirill Shalankin on 16/08/2017.
//  Copyright © 2017 Kirill Shalankin. All rights reserved.
//

#import "KBLProductCardRouter.h"
#import "KBLProductReviewViewController.h"
#import "KBLProductReviewPresenter.h"
#import "KBLProductCardPresenter.h"
#import "KBLCatalogProductListViewController.h"
#import "KBLCatalogProductListPresenter.h"
#import "KBLLoginViewController.h"
#import "KBLShopsViewController.h"
#import "KBLShopsPresenter.h"
#import "KBLDeliveryPresenter.h"
#import "KBLProductReviewController.h"
#import "KBLBasketViewController.h"
#import "KBLVideoClipsViewController.h"
#import "KBLStoryboardManager.h"
#import "KBLPromoCardViewController.h"
#import "KBLPromoCardPresenter.h"
#import "KBLPVZViewController.h"
#import "KBLWebViewController.h"

@implementation KBLProductCardRouter

- (void)showReviews:(NSArray *)reviews averageRating:(CGFloat)rating productID:(NSString *)productID {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[KBLStoryboardConstants getMainStoryboardName]
                                                         bundle:nil];
    
    KBLProductReviewViewController *productReviewVC = [storyboard instantiateViewControllerWithIdentifier:
                                                       [KBLStoryboardConstants getProductReviewStoryboardID]];
    KBLProductReviewPresenter *presenter = (KBLProductReviewPresenter *)productReviewVC.output;
    [presenter configureWithReviews:reviews averageRating:rating productID:productID];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.viewController.navigationController pushViewController:productReviewVC animated:YES];
    });
}

- (void)showProductCardWithID:(NSString *)productCardID title:(NSString *)title {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[KBLStoryboardConstants getMainStoryboardName]
                                                         bundle:nil];
    
    KBLProductCardViewController *productCardVC = [storyboard instantiateViewControllerWithIdentifier:
                                                   [KBLStoryboardConstants getProductCardStoryboardID]];
    KBLProductCardPresenter *presenter = (KBLProductCardPresenter *)productCardVC.output;
    [presenter configureWithProductCardID:productCardID title:title];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.viewController.navigationController pushViewController:productCardVC animated:YES];
    });
}

- (void)showProductListWithCatID:(NSString *)catID title:(NSString *)title {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[KBLStoryboardConstants getMainStoryboardName]
                                                         bundle:nil];
    
    KBLCatalogProductListViewController *catalogVC = [storyboard instantiateViewControllerWithIdentifier:
                                                      [KBLStoryboardConstants getCatalogProductListStoryboardID]];
    
    KBLCatalogProductListPresenter *presenter = (KBLCatalogProductListPresenter *)catalogVC.output;
    [presenter configureWithProductID:catID title:title];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.viewController.navigationController pushViewController:catalogVC animated:YES];
    });
}

- (void)showLoginModuleWithDelegate:(id <KBLLoginModuleDelegate>)delegate {
    KBLLoginViewController *loginVC = (KBLLoginViewController *)[KBLStoryboardManager getLoginViewController];
    KBLLoginPresenter *presenter = (KBLLoginPresenter *)loginVC.output;
    presenter.delegate = delegate;
    
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.viewController.navigationController presentViewController:navVC animated:YES completion:nil];
    });
}

- (void)showShopListWithStores:(NSArray *)stores offerID:(NSString *)offerID cityID:(NSString *)cityID {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[KBLStoryboardConstants getMainStoryboardName]
                                                         bundle:nil];
    
    KBLShopsViewController *view = [storyboard instantiateViewControllerWithIdentifier:
                                    [KBLStoryboardConstants getShopsStoryboardID]];
    KBLShopsPresenter *presenter = (KBLShopsPresenter *)view.output;
    KBLProductOffer *offer = [KBLProductOffer new];
    offer.offerID = [offerID integerValue];
    offer.quantum = 1;
    [presenter configureWithOffers:@[offer] shops:stores cityID:cityID output:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.viewController.navigationController pushViewController:view animated:YES];
    });
}

- (void)showDeliveryModuleWithCityID:(NSString *)cityID {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[KBLStoryboardConstants getMainStoryboardName]
                                                         bundle:nil];
    
    KBLDeliveryViewController *view = [storyboard instantiateViewControllerWithIdentifier:
                                       [KBLStoryboardConstants getDeliveryStoryboardID]];
    KBLDeliveryPresenter *presenter = (KBLDeliveryPresenter *)view.output;
    [presenter configureWithCityID:cityID];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.viewController.navigationController pushViewController:view animated:YES];
    });
}

- (void)showDescriptionWithModel:(id)model {
    KBLProductReviewController *reviewVC = [[KBLProductReviewController alloc] init];
    [reviewVC configureWithModel:model];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.viewController.navigationController pushViewController:reviewVC animated:YES];
    });
}

- (void)showCartModule {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[KBLStoryboardConstants getBasketStoryboardName]
                                                         bundle:nil];
    
    KBLBasketViewController *basketVC = [storyboard instantiateViewControllerWithIdentifier:
                                         [KBLStoryboardConstants getBasketStoryboardID]];
    
    if (@available(iOS 13.0, *)) {
        basketVC.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.viewController.navigationController presentViewController:basketVC animated:YES completion:nil];
    });
}

- (void)showQuickOrderModuleWithProduct:(id)product type:(KBLQuickOrderModuleType)type {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[KBLStoryboardConstants getBasketStoryboardName]
                                                         bundle:nil];
    
    KBLQuickOrderViewController *orderVC = [storyboard instantiateViewControllerWithIdentifier:
                                         [KBLStoryboardConstants getQuickOrderStoryboardID]];
    KBLQuickOrderPresenter *presenter = (KBLQuickOrderPresenter *)orderVC.output;
    [presenter configureWithProduct:product type:type];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:orderVC];
    
    if (@available(iOS 13.0, *)) {
        navVC.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.viewController.navigationController presentViewController:navVC animated:YES completion:nil];
    });
}

- (void)showVideoClipsModuleWithURLs:(NSArray *)urls {
    KBLVideoClipsViewController *clipsVC = [[KBLVideoClipsViewController alloc] initWithDataSource:urls];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.viewController.navigationController pushViewController:clipsVC animated:YES];
    });
}

- (void)showCatalogListWithType:(NSString *)groupType groupID:(NSString *)groupID name:(NSString *)name {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[KBLStoryboardConstants getMainStoryboardName]
                                                         bundle:nil];
    
    KBLCatalogProductListViewController *catalogVC = [storyboard instantiateViewControllerWithIdentifier:
                                                      [KBLStoryboardConstants getCatalogProductListStoryboardID]];
    
    KBLCatalogProductListPresenter *presenter = (KBLCatalogProductListPresenter *)catalogVC.output;
    
    if ([groupType isEqualToString:@"brands_type"]) {
        [presenter configureWithBrandID:groupID title:name];
        
    } else if ([groupType isEqualToString:@"promo_type"]) {
        [presenter configureWithSearchByTag:@[groupID] title:name];
        
    } else {
        [presenter configureWithProductID:groupID title:name];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.viewController.navigationController pushViewController:catalogVC animated:YES];
    });
}

- (void)showPromoCardWithID:(NSString *)promoID promoName:(NSString *)name {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[KBLStoryboardConstants getMainStoryboardName]
                                                         bundle:nil];
    
    KBLPromoCardViewController *promoVC = [storyboard instantiateViewControllerWithIdentifier:
                                                       [KBLStoryboardConstants getPromoCardStoryboardID]];
    KBLPromoCardPresenter *presenter = (KBLPromoCardPresenter *)promoVC.output;
    [presenter configureWithID:promoID];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.viewController.navigationController pushViewController:promoVC animated:YES];
    });
}

- (void)showPVZModuleWithCityID:(NSString *)cityID {
    KBLPVZViewController *view = (KBLPVZViewController *)[KBLStoryboardManager getPVZViewController];
    KBLPVZPresenter *presenter = (KBLPVZPresenter *)view.output;
    [presenter configureWithCityID:cityID];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.viewController.navigationController pushViewController:view animated:YES];
    });
}

- (void)showDocumentWithURL:(NSURL *)docURL {
    KBLWebViewController *webVC = [[KBLWebViewController alloc] init];
    [webVC setupWithLink:docURL.absoluteString];
    webVC.title = @"Инструкция";
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:webVC];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.viewController.navigationController presentViewController:navVC animated:YES completion:nil];
    });
}

@end
