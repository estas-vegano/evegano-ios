//
//  AddProductViewModel.swift
//  evegano-ios
//
//  Created by alexander on 05.06.16.
//  Copyright © 2016 nazavrik. All rights reserved.
//

import Foundation
import RxSwift

class AddProductViewModel {
    //MARK: UI
//    var productType = PublishSubject<String?>()
//    var productName = PublishSubject<String?>()
//    var productProducer = PublishSubject<String?>()
//    var productCategory = PublishSubject<String?>()
//    var productSubcategory = PublishSubject<String?>()
    let validatedType: Observable<Bool>
    let validatedTitle: Observable<Bool>
    
    let addButtonEnabled: Observable<Bool>
    
    init(input: (
        type: Observable<String>,
        title: Observable<String>)
        ) {
        validatedType = input.type
            .flatMapLatest({ type in
                return Observable.just(type.characters.count > 0)
                    .concat(Observable.never())
                    .throttle(0.4, scheduler: MainScheduler.instance)
                    .take(1)
                    .observeOn(MainScheduler.instance)
                    .catchErrorJustReturn(false)
                })
        validatedTitle = input.title
            .flatMapLatest({ title in
                return Observable.just(title.characters.count > 0)
                    .concat(Observable.never())
                    .throttle(0.4, scheduler: MainScheduler.instance)
                    .take(1)
                    .observeOn(MainScheduler.instance)
                    .catchErrorJustReturn(false)
            })
            
        addButtonEnabled = Observable.combineLatest(
            validatedType,
            validatedTitle
            ) { type, title in
                type && title
            }
            .distinctUntilChanged()
    }
}