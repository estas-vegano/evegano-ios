//
//  MainViewController.swift
//  evegano-ios
//
//  Created by alexander on 16.03.16.
//  Copyright © 2016 nazavrik. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    
    @IBAction func shootButtonDown(sender: UIButton) {
    
    }
    
    @IBAction func addButtonDown(sender: UIButton) {
        let viewController: AddProductViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func showButtonDown(sender: UIButton) {
        let viewController: ProductInfoViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
