//
//  KBLProductCardAssembly.m
//  Korablik
//
//  Created by Kirill Shalankin on 16/08/2017.
//  Copyright © 2017 Kirill Shalankin. All rights reserved.
//

#import "KBLProductCardAssembly.h"
#import "KBLProductCardViewController.h"
#import "KBLProductCardDataManager.h"
#import "KBLProductCardInteractor.h"
#import "KBLProductCardPresenter.h"
#import "KBLProductCardRouter.h"

@implementation KBLProductCardAssembly

- (KBLProductCardViewController *)viewProductCardModule {
    return [TyphoonDefinition withClass:[KBLProductCardViewController class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(output)
                                                    with:[self presenterProductCardModule]];
                              [definition injectProperty:@selector(dataManager)
                                                    with:[self ProductCardDataManager]];
                          }];
}

- (KBLProductCardInteractor *)interactorProductCardModule {
    return [TyphoonDefinition withClass:[KBLProductCardInteractor class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(output)
                                                    with:[self presenterProductCardModule]];
                          }];
}

- (KBLProductCardPresenter *)presenterProductCardModule {
    return [TyphoonDefinition withClass:[KBLProductCardPresenter class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(view)
                                                    with:[self viewProductCardModule]];
                              [definition injectProperty:@selector(interactor)
                                                    with:[self interactorProductCardModule]];
                              [definition injectProperty:@selector(router)
                                                    with:[self routerProductCardModule]];
                          }];
}

- (KBLProductCardRouter *)routerProductCardModule {
    return [TyphoonDefinition withClass:[KBLProductCardRouter class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(viewController)
                                                    with:[self viewProductCardModule]];
                          }];
}

- (KBLProductCardDataManager *)ProductCardDataManager {
    return [TyphoonDefinition withClass:[KBLProductCardDataManager class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(view)
                                                    with:[self viewProductCardModule]];
                          }];
}

@end
