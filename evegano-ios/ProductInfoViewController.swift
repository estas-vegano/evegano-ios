//
//  ViewController.swift
//  evegano-ios
//
//  Created by alexander on 12.12.15.
//  Copyright © 2015 nazavrik. All rights reserved.
//

import UIKit

class ProductInfoViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let api: EV_ApiRequest = EV_ApiRequest()
        api.requestCheckProduct("161", type: "barcode") {
            (result: EV_ProductModel) in
            print(result)
            if let imageUrl = result.photo {
                api.requestLoadImage(imageUrl, completionHandler: { (result) -> Void in
                    self.photoImageView.image = result
                })
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

