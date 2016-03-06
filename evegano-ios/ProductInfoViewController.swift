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
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var producerLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var isEthic: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let api: ApiRequest = ApiRequest()
        api.requestCategories { (result:[CategoryItemModel]) -> Void in
            
        }
        
        api.requestCheckProduct("161", type: "barcode") {
            (result: ProductModel) in
            print(result)
            if let imageUrl = result.photo {
                api.requestLoadImage(imageUrl, completionHandler: { (result) -> Void in
                    self.photoImageView.image = result
                })
            }
            self.nameLabel.text = result.title
            self.producerLabel.text = result.producer.title
            self.descriptionLabel.text = result.info
            if let ethical = result.producer.ethical {
                self.isEthic.text = ethical ? "YES" : "NO"
            } else {
                self.isEthic.text = "NO"
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func complainButtonDown(sender: UIButton) {
        let alertView: UIAlertView = UIAlertView(title: "Fu-u-u-u", message: "Ябеда!", delegate: nil, cancelButtonTitle: "Ok")
        alertView.show()
    }
    
}

