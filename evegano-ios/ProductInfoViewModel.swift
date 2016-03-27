//
//  ProductInfoViewModel.swift
//  evegano-ios
//
//  Created by alexander on 27.03.16.
//  Copyright © 2016 nazavrik. All rights reserved.
//

import Foundation
import RxSwift

enum ProductInfo: String {
    case Vegan = "vegan"
    case Vegeterian = "vegeterian"
    case Fish = "fish"
    case Meat = "meat"
    case Milk = "milk"
}

class ProductInfoViewModel {
    var disposeBag = DisposeBag()
    //MARK: UI
    var productName = PublishSubject<String?>()
    var productImage = PublishSubject<UIImage?>()
    var productInfoImage = PublishSubject<UIImage?>()
    
    //MARK: Model
    var product: Product? {
        didSet {
            updateModel()
        }
    }
    
    func updateModel() {
        if let name = product?.title {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.productName.onNext(name)
            })
        }
        if let imageUrl = product?.photo {
            ApiRequest().requestLoadImage(imageUrl, completionHandler: { (result) -> Void in
                self.productImage.onNext(result)
            })
        }
        if let productInfo = product?.info {
            self.productInfoImage.onNext(getProductInfoImage(productInfo))
        }
    }
    
    func getProductInfoImage(productInfo: String) -> UIImage {
        return UIImage(named: productInfo+"_icon")!
    }
}