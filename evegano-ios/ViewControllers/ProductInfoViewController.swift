//
//  ViewController.swift
//  evegano-ios
//
//  Created by alexander on 12.12.15.
//  Copyright © 2015 nazavrik. All rights reserved.
//

import UIKit
import SwiftHEXColors
import RxSwift

protocol ProductInfoViewControllerDelegate {
    func productInfoViewControllerDidDissmiss()
}

class ProductInfoViewController: UIViewController, StoryboardIdentifierProtocol {
    //MARK: constants
    static let storyboardId = "ProductInfoViewControllerId"
    
    @IBOutlet weak var photoImageView: UIImageView! {
        didSet {
            createImageView()
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var productTypeImageView: UIImageView!
    @IBOutlet weak var productEthicalImageView: UIImageView!
    @IBOutlet weak var productInformationView: UIView!
    
    var delegate: ViewControllerDismissProtocol?
    
    var productInfoViewModel = ProductInfoViewModel()
    let disposeBag = DisposeBag()
    
    var code: Code?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.nameLabel.hidden = true
        self.productInfoViewModel.productName.subscribeNext { name in
            self.nameLabel.hidden = false
            self.nameLabel.text = name
        }
        .addDisposableTo(disposeBag)
        
        self.photoImageView.hidden = true
        self.productInfoViewModel.productImage.subscribeNext { image in
            self.photoImageView.hidden = false
            self.photoImageView.image = image
        }
        .addDisposableTo(disposeBag)
        
        self.productTypeImageView.hidden = true
        self.productInfoViewModel.productInfoImage.subscribeNext { image in
            self.productTypeImageView.hidden = false
            self.productTypeImageView.image = image
        }
        .addDisposableTo(disposeBag)
        
        self.productEthicalImageView.hidden = true
        self.productInformationView.hidden = true
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    func loadData() {
        if let code = self.code {
            let spiner = LoaderView(loaderType: .LoaderTypeBigAtTop, view: self.view)
            spiner.startAnimating()
            ApiRequest().requestCheckProduct(code.code!, type: code.type!) { (result, error) in
                spiner.stopAnimating()
                self.productInfoViewModel.product = result
                self.productInformationView.hidden = false
            }
        }
    }
    //MARK: UI methods
    private func createImageView() {
        let circle: CAShapeLayer = CAShapeLayer()
        let radius: CGFloat = self.photoImageView.frame.size.width / 2.0
        circle.position = CGPointZero
        circle.path = UIBezierPath(roundedRect: self.photoImageView.bounds, cornerRadius: radius).CGPath
        circle.fillColor = UIColor.clearColor().CGColor
        circle.strokeColor = UIColor(hex: 0xFBAA26)!.CGColor
        circle.lineWidth = 6.0
        self.photoImageView.layer.addSublayer(circle)
    }
    //MARK: IBActions
    @IBAction func complainButtonDown(sender: UIButton) {
        let alertView: UIAlertView = UIAlertView(title: "Fu-u-u-u", message: "Ябеда!", delegate: nil, cancelButtonTitle: "Ok")
        alertView.show()
    }
    
    @IBAction func backButtonDown(sender: UIButton) {
        self.delegate?.viewControllerDidDismiss()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    //MARK: Protocol methods
    static func storyboardIdentifier() -> String {
        return storyboardId
    }
    
}

