//
//  AppProductViewModel.swift
//  evegano-ios
//
//  Created by alexander on 05.06.16.
//  Copyright © 2016 nazavrik. All rights reserved.
//

import Foundation
import RxSwift

class AppProductViewModel {
    var disposeBag = DisposeBag()
    var productProducer = PublishSubject<UITextField?>()
    
}