//
//  KBLProductCardPresenter.h
//  Korablik
//
//  Created by Kirill Shalankin on 16/08/2017.
//  Copyright © 2017 Kirill Shalankin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KBLProductCardViewController.h"
#import "KBLProductCardInteractor.h"
#import "KBLProductCardRouter.h"
#import "KBLLoginPresenter.h"

@protocol KBLProductCardModuleConfiguration
- (void)configureWithProductCardID:(NSString *)productCardID title:(NSString *)title;
/*
 Если мы передем в карточку из корзины, то может быть ситуация, когда мы отдаем разные id одного товара (разные размеры),
 а в ответе у нас всегда будет размер по умолчанию. Правим эту ситуацию
 */
- (void)configureWithProductCardID:(NSString *)productCardID size:(NSString *)size title:(NSString *)title;

//Передаем cityID, который нужно подставить в запрос на карточку товара
- (void)configureWithProductCardID:(NSString *)productCardID title:(NSString *)title cityID:(NSString *)cityID;
@end

@protocol KBLProductCardViewInput;
@protocol KBLProductCardInteractorInput;

@interface KBLProductCardPresenter : NSObject <KBLProductCardViewOutput, KBLProductCardInteractorOutput,
KBLProductCardModuleConfiguration, KBLLoginModuleDelegate>

@property (nonatomic, weak) id <KBLProductCardViewInput> view;
@property (nonatomic, strong) id <KBLProductCardInteractorInput> interactor;
@property (nonatomic, strong) KBLProductCardRouter *router;

@end
