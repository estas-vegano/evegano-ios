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
        
        
//        api.requestCategories { (result:[CategoryItemModel]) -> Void in
//            
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    func loadData() {
        let spiner = LoaderView(loaderType: .LoaderTypeBigAtTop, view: self.view)
        spiner.startAnimating()
        
        let api: ApiRequest = ApiRequest()
        ApiRequest().requestCheckProduct("161", type: "barcode") {
            (result: ProductModel) in
            spiner.stopAnimating()
            if let imageUrl = result.photo {
                api.requestLoadImage(imageUrl, completionHandler: { (result) -> Void in
                    self.photoImageView.image = result
                })
            }
            self.nameLabel.text = result.title
            self.producerLabel.text = result.producer?.title
            self.descriptionLabel.text = result.info
            if let ethical = result.producer?.ethical {
                self.isEthic.text = ethical ? "YES" : "NO"
            } else {
                self.isEthic.text = "NO"
            }
        }
    }
    
    @IBAction func complainButtonDown(sender: UIButton) {
        let alertView: UIAlertView = UIAlertView(title: "Fu-u-u-u", message: "Ябеда!", delegate: nil, cancelButtonTitle: "Ok")
        alertView.show()
    }
    
}

