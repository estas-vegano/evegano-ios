//
//  ChooseProductTitleViewController.swift
//  evegano-ios
//
//  Created by alexander on 12.06.16.
//  Copyright © 2016 nazavrik. All rights reserved.
//

import UIKit

protocol ChooseProductInfoDelegate {
    func productInfoDidSelect(title: String)
}

class ChooseProductTitleViewController: UIViewController, StoryboardIdentifierProtocol, UITextFieldDelegate {
    //MARK: IBOutlet
    @IBOutlet weak var textField: UITextField!
    //MARK: variables
    var delegate: ChooseProductInfoDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITextField.appearance().tintColor = UIColor.whiteColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.textField.becomeFirstResponder()
    }
    
    func goBackAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    //MARK: IBActions
    @IBAction func backButtonDown(sender: UIButton) {
        self.goBackAction()
    }
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let text = textField.text {
            self.delegate?.productInfoDidSelect(text)
        }
        self.goBackAction()
        return true
    }
    //constants
    private static let storyboardId = "ChooseProductTitleViewControllerId"
    //MARK: Protocol methods
    static func storyboardIdentifier() -> String {
        return storyboardId
    }
}
