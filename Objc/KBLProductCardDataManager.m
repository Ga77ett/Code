//
//  KBLProductCardDataManager.m
//  Korablik
//
//  Created by Kirill Shalankin on 16/08/2017.
//  Copyright © 2017 Kirill Shalankin. All rights reserved.
//

#import "KBLProductCardDataManager.h"
#import "KBLTitleHeaderView.h"
#import "KBLConstants.h"
#import "KBLAppearance.h"
#import "KBLNewProductCard.h"
#import "KBLHeaderFooterButton.h"
#import "KBLActionSheetViewController.h"
#import "KBLAppearance.h"

typedef NS_ENUM(NSInteger, KBLProductCardCellStyle) {
    KBLProductCardCellStyleCarousel,
    KBLProductCardCellStyleDescription,
    KBLProductCardCellStylePromo,
    KBLProductCardCellStyleColors,
    KBLProductCardCellStyleSizes,
    KBLProductCardCellStyleButtons,
    KBLProductCardCellStyleDeliveryTypeHeader,
    KBLProductCardCellStyleDeliveryPickup,
    KBLProductCardCellStyleDeliveryDelivery,
    KBLProductCardCellStyleDeliveryPVZ,
    KBLProductCardCellStyleExtHeader,
    KBLProductCardCellStyleExtDescription,
    KBLProductCardCellStyleExtReviews,
    KBLProductCardCellStyleExtDocuments,
    KBLProductCardCellStyleExtBrands,
    KBLProductCardCellStyleProductCarouselAccessoriesHeader,
    KBLProductCardCellStyleProductCarouselAccessories,
    KBLProductCardCellStyleProductCarouselSimilarHeader,
    KBLProductCardCellStyleProductCarouselSimilar
};

@interface KBLProductCardDataManager () <KBLProductCarouselCellOutput, KBLOrderButtonsCellOutput, KBLActionSheetDelegate, KBLSizeCellOutput, KBLColorCellOutput>

@property (strong, nonatomic) KBLNewProductCard *model;
@property (strong, nonatomic) NSMutableArray *reviews;
@property (strong, nonatomic) NSMutableArray *similarBlock;
@property (strong, nonatomic) NSMutableArray *accessoriesBlock;

@property (strong, nonatomic) KBLProductPreviewTableViewCell *similarCell;
@property (strong, nonatomic) KBLProductPreviewTableViewCell *accessoriesCell;

@property (strong, nonatomic) KBLActionSheetViewController *actionSheet;

@property (strong, nonatomic) KBLSizeCell *sizeCell;
@property (assign, nonatomic) BOOL sizeWasChanged;
@property (assign, nonatomic) BOOL adjustSizeCellHeight;

@end

@implementation KBLProductCardDataManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _reviews = [@[] mutableCopy];
        _similarBlock = [@[] mutableCopy];
        _accessoriesBlock = [@[] mutableCopy];
    }
    return self;
}

- (void)configureWithData:(id)data {
    self.model = data;
    self.adjustSizeCellHeight = NO;
}

- (void)updateReviews:(NSArray *)reviews {
    [self.reviews addObjectsFromArray:reviews];
}

- (void)setProductsBlock:(NSArray *)products {
    [self.similarBlock addObjectsFromArray:products];
}

- (void)setSimilarProducts:(NSArray *)products {
    [self.accessoriesBlock addObjectsFromArray:products];
}

- (void)reloadCellWithProduct:(id)product {
    if (self.model == product) {
        self.model = product;
        [self.view.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]
                                   withRowAnimation:UITableViewRowAnimationNone];

    } else if ([self.similarBlock containsObject:product]) {
        NSInteger index = [self.similarBlock indexOfObject:product];
        [self.similarBlock removeObjectAtIndex:index];
        [self.similarBlock insertObject:product atIndex:index];
        [self.similarCell reloadCollectionView];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.accessoriesBlock.count) {
        return 19;
        
    } else {
        return 17;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KBLProductOffer *offer = self.model.offers[self.model.currentOfferIndex];
    
    switch ([self modifiedIndexPath:indexPath]) {
        case KBLProductCardCellStyleCarousel: {
            KBLProductCarouselCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                            [KBLProductCarouselCell cellReuseIdentifier] forIndexPath:indexPath];
            
            [cell configureCellWithModel:self.model vc:self.view];
            cell.output = self;
            
            return cell;
        } break;
            
        case KBLProductCardCellStyleDescription: {
            KBLProductDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                               [KBLProductDescriptionCell cellReuseIdentifier] forIndexPath:indexPath];
            [cell layoutIfNeeded];
            [cell configureCellWithModel:self.model];
            cell.separatorInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, CGFLOAT_MAX);
            
            return cell;
        } break;
            
        case KBLProductCardCellStylePromo: {
            KBLProductCardPromoCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                             [KBLProductCardPromoCell cellReuseIdentifier] forIndexPath:indexPath];
            [cell layoutIfNeeded];
            [cell configureWithText:self.model.promoName];
            cell.separatorInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, CGFLOAT_MAX);
            
            return cell;
        } break;
            
        case KBLProductCardCellStyleColors: {
            KBLColorCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                             [KBLColorCell cellReuseIdentifier] forIndexPath:indexPath];
            cell.separatorInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, CGFLOAT_MAX);
            cell.output = self;
            [cell configureWithArray:self.model.container];
            
            return cell;
        } break;
            
        case KBLProductCardCellStyleSizes: {
            KBLSizeCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 [KBLSizeCell cellReuseIdentifier] forIndexPath:indexPath];
            
            if (self.model.sizeIsExist) {
                [cell configureCellWithOffers:self.model.offers selectedOfferIndex:self.model.currentOfferIndex];
                
            } else {
                [cell configureWithPackages:self.model.packages packageName:self.model.packageName modelProductID:self.model.productID];
            }
            
            [cell layoutIfNeeded];
            self.sizeCell = cell;
            cell.output = self;
            
            if (!self.adjustSizeCellHeight) {
                self.adjustSizeCellHeight = YES;
                [tableView reloadData];
            }
            
            return cell;
        } break;
            
        case KBLProductCardCellStyleButtons: {
            KBLOrderButtonsCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                         [KBLOrderButtonsCell cellReuseIdentifier] forIndexPath:indexPath];
            
            [cell configureWithProductModel:self.model sizeWasChanged:self.sizeWasChanged cityID:[self.view.output getCityID]];
            cell.output = self;
            self.addToCartButton = cell.addToCartButton;
            
            return cell;
        } break;
            
        case KBLProductCardCellStyleDeliveryTypeHeader: {
            KBLHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                         [KBLHeaderCell cellReuseIdentifier] forIndexPath:indexPath];
            
            [cell configureWithText:[NSString stringWithFormat:@"СПОСОБЫ ДОСТАВКИ: %@",
                                     [[self.view.output getCityName] uppercaseString]] setupAllLabel:NO];
            return cell;
        } break;
            
        case KBLProductCardCellStyleDeliveryPickup: {
            KBLObtainingCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                      [KBLObtainingCell cellReuseIdentifier] forIndexPath:indexPath];
            [cell configureCellWithType:KBLObtainingCellTypePickup offer:offer];
            return cell;
        } break;
            
        case KBLProductCardCellStyleDeliveryDelivery: {
            KBLObtainingCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                      [KBLObtainingCell cellReuseIdentifier] forIndexPath:indexPath];
            [cell configureCellWithType:KBLObtainingCellTypeDelivery offer:offer];
            return cell;
        } break;
            
        case KBLProductCardCellStyleDeliveryPVZ: {
            KBLObtainingCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                      [KBLObtainingCell cellReuseIdentifier] forIndexPath:indexPath];
            [cell configureCellWithType:KBLObtainingCellTypePVZ offer:offer];
            return cell;
        } break;
            
        case KBLProductCardCellStyleExtHeader: {
            KBLHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                         [KBLHeaderCell cellReuseIdentifier] forIndexPath:indexPath];
            
            [cell configureWithText:@"ДОПОЛНИТЕЛЬНО" setupAllLabel:NO];
            return cell;
        } break;
            
        case KBLProductCardCellStyleExtDescription: {
            KBLDescriptionWithNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                                  [KBLDescriptionWithNumberCell cellReuseIdentifier] forIndexPath:indexPath];
            [cell configureWithText:@"Описание и характеристики" count:0];
            return cell;
        } break;
            
        case KBLProductCardCellStyleExtReviews: {
            KBLDescriptionWithNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                                  [KBLDescriptionWithNumberCell cellReuseIdentifier] forIndexPath:indexPath];
            [cell configureWithText:@"Отзывы" count:self.reviews.count];
            return cell;
        } break;
            
        case KBLProductCardCellStyleExtDocuments: {
            KBLDescriptionWithNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                                  [KBLDescriptionWithNumberCell cellReuseIdentifier] forIndexPath:indexPath];
            [cell configureWithText:@"Инструкция" count:0];
            return cell;
        } break;
            
        case KBLProductCardCellStyleExtBrands: {
            KBLDescriptionWithNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                                  [KBLDescriptionWithNumberCell cellReuseIdentifier] forIndexPath:indexPath];
            
            [cell configureWithAttributedText:[self getBrandString] count:0];
            return cell;
        } break;
            
        case KBLProductCardCellStyleProductCarouselAccessoriesHeader: {
            KBLHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                         [KBLHeaderCell cellReuseIdentifier] forIndexPath:indexPath];
            
            [cell configureWithText:@"С ЭТИМ ТОВАРОМ ПОКУПАЮТ" setupAllLabel:NO];
            cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
            return cell;
        } break;
            
        case KBLProductCardCellStyleProductCarouselAccessories: {
            KBLProductPreviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                                    [KBLProductPreviewTableViewCell cellReuseIdentifier] forIndexPath:indexPath];
            self.accessoriesCell = cell;
            [cell setupWithData:self.accessoriesBlock output:self.view.output isSale:NO isRecentlyWatched:YES];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
            return cell;
        } break;
            
        case KBLProductCardCellStyleProductCarouselSimilarHeader: {
            KBLHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                         [KBLHeaderCell cellReuseIdentifier] forIndexPath:indexPath];
            
            [cell configureWithText:@"ПОХОЖИЕ ТОВАРЫ" setupAllLabel:YES];
            cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
            return cell;
        } break;
            
        case KBLProductCardCellStyleProductCarouselSimilar: {
            KBLProductPreviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                                    [KBLProductPreviewTableViewCell cellReuseIdentifier] forIndexPath:indexPath];
            self.similarCell = cell;
            [cell setupWithData:self.similarBlock output:self.view.output isSale:YES isRecentlyWatched:NO];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
            return cell;
        } break;
            
        default: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
            return cell;
        } break;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch ([self modifiedIndexPath:indexPath]) {
        case KBLProductCardCellStyleCarousel: {
            return [KBLProductCarouselCell cellHeight];
        } break;
            
        case KBLProductCardCellStyleDescription: {
            return [KBLProductDescriptionCell cellHeight];
        } break;
            
        case KBLProductCardCellStylePromo: {
            return UITableViewAutomaticDimension;
        } break;
            
        case KBLProductCardCellStyleColors: {
            return [KBLColorCell cellHeight];
        } break;
            
        case KBLProductCardCellStyleSizes: {
            return [self.sizeCell cellHeight];
        } break;
            
        case KBLProductCardCellStyleButtons: {
            return [KBLOrderButtonsCell cellHeight];
        } break;
            
        case KBLProductCardCellStyleDeliveryTypeHeader: {
            return [KBLHeaderCell cellHeight];
        } break;
            
        case KBLProductCardCellStyleDeliveryPickup: {
            return [KBLObtainingCell cellHeight];
        } break;
            
        case KBLProductCardCellStyleDeliveryDelivery: {
            return [KBLObtainingCell cellHeight];
        } break;
            
        case KBLProductCardCellStyleDeliveryPVZ: {
            return [KBLObtainingCell cellHeight];
        } break;
            
        case KBLProductCardCellStyleExtHeader: {
            return [KBLHeaderCell cellHeight];
        } break;
            
        case KBLProductCardCellStyleExtDescription: {
            return [KBLDescriptionWithNumberCell cellHeight];
        } break;
            
        case KBLProductCardCellStyleExtReviews: {
            return [KBLDescriptionWithNumberCell cellHeight];
        } break;
        
        case KBLProductCardCellStyleExtDocuments: {
            return [KBLDescriptionWithNumberCell cellHeight];
        } break;
            
        case KBLProductCardCellStyleExtBrands: {
            return [KBLDescriptionWithNumberCell cellHeight];
        } break;
            
        case KBLProductCardCellStyleProductCarouselAccessoriesHeader: {
            return [KBLHeaderCell cellHeight];
        } break;
            
        case KBLProductCardCellStyleProductCarouselAccessories: {
            return [KBLProductPreviewTableViewCell cellHeight];
        } break;
            
        case KBLProductCardCellStyleProductCarouselSimilarHeader: {
            return [KBLHeaderCell cellHeight];
        } break;
            
        case KBLProductCardCellStyleProductCarouselSimilar: {
            return [KBLProductPreviewTableViewCell cellHeight];
        } break;
            
        default: {
            return 0.f;
        } break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch ([self modifiedIndexPath:indexPath]) {
        case KBLProductCardCellStyleDeliveryPickup: {
            KBLProductOffer *offer = self.model.offers[self.model.currentOfferIndex];
            [self.view.output pickupDidTappedWithOfferID:
             [NSString stringWithFormat:@"%li", (long)offer.offerID]];
        } break;
            
        case KBLProductCardCellStyleDeliveryDelivery: {
            [self.view.output deliveryDidTapped];
        } break;
            
        case KBLProductCardCellStyleDeliveryPVZ: {
            [self.view.output pvzDidTapped];
        } break;
            
        case KBLProductCardCellStyleExtDescription: {
            [self.view.output descriptionDidTapped:self.model];
        } break;
            
        case KBLProductCardCellStyleExtReviews: {
            [self.view.output reviewsCellDidTapped:self.reviews averageRating:self.model.averageMark];
        } break;
            
        case KBLProductCardCellStyleExtDocuments: {
            [self.view.output documentsDidTappedWithURL:[NSURL URLWithString:self.model.documents.firstObject]];
        } break;
            
        case KBLProductCardCellStyleExtBrands: {
            [self.view.output extendedCategoryDidTappedWithType:@"brands_type"
                                                        groupID:self.model.brandID name:self.model.brandName];
        } break;
            
        case KBLProductCardCellStyleProductCarouselAccessoriesHeader: {
            [self.view.output allProductsDidTappedIsSale:NO title:@"С ЭТИМ ТОВАРОМ ПОКУПАЮТ"];
        } break;
            
        case KBLProductCardCellStyleProductCarouselSimilarHeader: {
            [self.view.output allProductsDidTappedIsSale:YES title:@"Похожие товары"];
        } break;
            
        default: {
            
        } break;
    }
}

#pragma mark - KBLProductCarouselCellOutput

- (void)addToFavouritesDidTapped {
    [self.view.output favouritesDidTapped:self.model];
}

#pragma mark - KBLOrderButtonsCellOutput

- (void)alertDidTapped {
    [self.view.output cartDidTapped];
}

- (void)quickOrderDidTapped {
    self.actionSheet = [[KBLActionSheetViewController alloc] initWithModel:self.model];
    self.actionSheet.delegate = self;
    [self.view.view.window addSubview:self.actionSheet.view];
}

#pragma mark - KBLActionSheetDelegate

- (void)doneDidTappedWithIndex:(NSInteger)index {
    // 0 - самовывоз, 1 - доставка
    
    KBLProductOffer *offer = self.model.offers[self.model.currentOfferIndex];
    
    switch (index) {
        case 0: {
            if (offer.countOfStores) {
                [self.view.output quickOrderDidTappedWithPoduct:self.model isDelivery:NO];
            }
    
        } break;
            
        case 1: {
            if (offer.deliveryIsAvailable) {
                [self.view.output quickOrderDidTappedWithPoduct:self.model isDelivery:YES];
            }
        } break;
            
        default: {
            if (offer.pvzIsAvailable) {
                [self.view.output quickOrderDidTappedPVZWithPoduct:self.model];
            }
        } break;
    }
}

#pragma mark - Helper

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect cellRect = [self.view.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    BOOL completelyVisible = CGRectContainsRect(self.view.tableView.bounds, cellRect);
    BOOL offset = scrollView.contentOffset.y > 300 ? YES: NO;
    BOOL showView = offset && !completelyVisible? YES: NO;
    
    [self.view priceViewNeedToHide:!showView];
}

- (NSString *)getProductURLString {
    return self.model.productURLString;
}

- (NSAttributedString *)getBrandString {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                                   initWithString:[NSString stringWithFormat:@"Товары бренда: %@", self.model.brandName]
                                                   attributes:@{NSFontAttributeName:
                                                                    [UIFont systemFontOfSize:17.0f weight:UIFontWeightRegular],
                                                                NSForegroundColorAttributeName: [UIColor blackColor],
                                                                NSKernAttributeName: @(-0.41)}];
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f weight:UIFontWeightRegular],
                                      NSForegroundColorAttributeName:[KBLAppearance ki_bluishColor]
                                      } range:NSMakeRange(15, self.model.brandName.length)];
    return attributedString;
}

#pragma mark - KBLSizeCellOutput

- (void)sizeDidSelectedWithIndex:(NSInteger)index {
    if (self.model.sizeIsExist) {
        self.sizeWasChanged = YES;
        self.model.currentOfferIndex = index;
        
        [self.view.tableView reloadData];
        
    } else {
        KBLPackageModel *pack = self.model.packages[index];
        [self.view.output packageDidTappedWithProductID:pack.productID];
    }
}

#pragma mark - KBLColorCellOutput

- (void)colorDidTappedWithIndex:(NSInteger)index {
    KBLProductPropertyContainer *container = self.model.container[index];
    [self.view.output colorWasChanged:container.productID];
}

#pragma mark - Helper

- (NSInteger)modifiedIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.row;
    
    if (index >= KBLProductCardCellStylePromo && !self.model.promoName.length) {
        index++;
    }
    
    if (index >= KBLProductCardCellStyleColors && !self.model.container.count) {
        index++;
    }
    
    if (index >= KBLProductCardCellStyleSizes && !self.model.sizeIsExist && !self.model.packages.count) {
        index++;
    }
    
    if (index >= KBLProductCardCellStyleProductCarouselAccessoriesHeader && !self.accessoriesBlock.count) {
        index++;
    }
    
    if (index >= KBLProductCardCellStyleProductCarouselAccessories && !self.accessoriesBlock.count) {
        index++;
    }
    
    if (index >= KBLProductCardCellStyleExtDocuments && !self.model.documents.count) {
        index++;
    }
    
    return index;
}

@end
