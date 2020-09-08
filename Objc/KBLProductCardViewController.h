//
//  KBLProductCardViewController.h
//  Korablik
//
//  Created by Kirill Shalankin on 16/08/2017.
//  Copyright © 2017 Kirill Shalankin. All rights reserved.
//

#import "KBLBaseViewController.h"

#import "KBLProductCardDataManager.h"
#import "KBLCollectionView.h"
#import "KBLTableView.h"

@protocol KBLProductCardViewOutput <KBLCollectionViewOutput>

- (void)viewDidReady;
- (void)reviewsCellDidTapped:(NSArray *)reviews averageRating:(CGFloat)rating;
- (void)favouritesDidTapped:(id)product;
- (void)pickupDidTappedWithOfferID:(NSString *)offerID;
- (void)deliveryDidTapped;
- (void)descriptionDidTapped:(id)model;
- (void)cartDidTapped;
- (void)quickOrderDidTappedWithPoduct:(id)product isDelivery:(BOOL)isDelivery;
- (void)quickOrderDidTappedPVZWithPoduct:(id)product;
- (void)videoClipsDidTappedWithURLs:(NSArray *)videoURLs;
- (void)extendedCategoryDidTappedWithType:(NSString *)groupType groupID:(NSString *)groupID name:(NSString *)name;
- (void)promoDidTapped:(NSString *)promoID promoName:(NSString *)name;
- (void)pvzDidTapped;
- (void)colorWasChanged:(NSString *)productID;
- (NSString *)getCityName;
- (NSString *)getCityID;
- (void)documentsDidTappedWithURL:(NSURL *)docURL;
- (void)packageDidTappedWithProductID:(NSString *)productID;

@end

@protocol KBLProductCardViewInput <NSObject>

- (void)setupTitle:(NSString *)title;
- (void)configureWithData:(id)data;
- (void)configureAccessoriesProducts:(NSArray *)products;
- (void)updateReviewsCount:(NSArray *)reviews;
- (void)configureProductsBlock:(NSArray *)products;
- (void)reloadCellWichContainsProduct:(id)product;

@end

@class KBLProductCardDataManager;

@interface KBLProductCardViewController : KBLBaseViewController <KBLProductCardViewInput>

@property (nonatomic, strong) id <KBLProductCardViewOutput> output;
@property (nonatomic, strong) KBLProductCardDataManager *dataManager;
@property (weak, nonatomic) IBOutlet KBLTableView *tableView;

- (void)priceViewNeedToHide:(BOOL)hide;

@end
