//
//  KBLProductCardRouter.h
//  Korablik
//
//  Created by Kirill Shalankin on 16/08/2017.
//  Copyright © 2017 Kirill Shalankin. All rights reserved.
//

#import "KBLRouter.h"
#import "KBLLoginPresenter.h"
#import "KBLQuickOrderPresenter.h"

@interface KBLProductCardRouter : KBLRouter

- (void)showReviews:(NSArray *)reviews averageRating:(CGFloat)rating productID:(NSString *)productID;
- (void)showProductCardWithID:(NSString *)productCardID title:(NSString *)title;
- (void)showProductListWithCatID:(NSString *)catID title:(NSString *)title;
- (void)showLoginModuleWithDelegate:(id <KBLLoginModuleDelegate>)delegate;
- (void)showShopListWithStores:(NSArray *)store offerID:(NSString *)offerID cityID:(NSString *)cityID;
- (void)showDeliveryModuleWithCityID:(NSString *)cityID;
- (void)showDescriptionWithModel:(id)model;
- (void)showCartModule;
- (void)showQuickOrderModuleWithProduct:(id)product type:(KBLQuickOrderModuleType)type;
- (void)showVideoClipsModuleWithURLs:(NSArray *)urls;
- (void)showCatalogListWithType:(NSString *)groupType groupID:(NSString *)groupID name:(NSString *)name;
- (void)showPromoCardWithID:(NSString *)promoID promoName:(NSString *)name;
- (void)showPVZModuleWithCityID:(NSString *)cityID;
- (void)showDocumentWithURL:(NSURL *)docURL;

@end
