//
//  AddProductViewController.swift
//  evegano-ios
//
//  Created by alexander on 31.01.16.
//  Copyright © 2016 nazavrik. All rights reserved.
//

import UIKit

protocol AddProductViewControllerDelegate {
    func addProductViewControllerDidDissmiss()
}

class AddProductViewController: UIViewController, AddCategoryViewControllerDelegate, StoryboardIdentifierProtocol, ChooseProductTypeViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    //constants
    static let storyboardId = "AddProductViewControllerId"
    //MARK: variables
    var delegate: AddProductViewControllerDelegate?
    
    var productModel = Product()
    var isSubcategory = false
    var producerTitle: String?
    var codeType: String?
    
    var imagePicker: UIImagePickerController!
    
    @IBOutlet weak var subcategoryView: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var addPhotoLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var producerTextField: UITextField!
    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var subcategoryButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    //MARK: UI
    func updateUI() {
        if let category = self.productModel.category {
            self.categoryButton.setTitle(category.title, forState: .Normal)
            self.subcategoryView.hidden = false
        } else {
            self.categoryButton.setTitle("Выберете категорию", forState: .Normal)
            self.subcategoryView.hidden = true
        }
        if let subcategory = self.productModel.category?.children {
            self.subcategoryButton.setTitle(subcategory.first?.title, forState: .Normal)
        } else {
            self.subcategoryButton.setTitle("Выберете подкатегорию", forState: .Normal)
        }
        if let productType = self.productModel.info {
            self.typeButton.setTitle(productType, forState: .Normal)
        } else {
            self.typeButton.setTitle("Выберете тип продукта", forState: .Normal)
        }
    }
    //MARK: IBActions
    @IBAction func chooseCategoryButtonDown(sender: UIButton) {
        self.isSubcategory = false
        
        let viewController: AddCategoryViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController()
        viewController.modalPresentationStyle = .OverCurrentContext
        viewController.delegate = self
        presentViewController(viewController, animated: true) { () -> Void in
            
        }
    }
    
    @IBAction func chooseSubcategoryButtonDown(sender: UIButton) {
        self.isSubcategory = true
        
        let viewController: AddCategoryViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController()
        viewController.modalPresentationStyle = .OverCurrentContext
        viewController.delegate = self
        viewController.category = self.productModel.category
        presentViewController(viewController, animated: true) {
        }
    }
    
    @IBAction func backButtonDown(sender: UIButton) {
        self.delegate?.addProductViewControllerDidDissmiss()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addPhotoButtonDown(sender: UIButton) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func chooseTypeAction(sender: UIButton) {
        let viewController: ChooseProductTypeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController()
        viewController.modalPresentationStyle = .OverCurrentContext
        viewController.delegate = self

        presentViewController(viewController, animated: true) { () -> Void in
            
        }
    }
    
    @IBAction func sendProductAction(sender: UIButton) {
        if let producerTitle = self.producerTitle {
            //Add producer before, get producer id
            ApiRequest().requestAddProducer(producerTitle, ethical: false) { (result, error) -> Void in
                
                if (error == nil || error!.errorCode == -13 ) {
                    var parameters: Dictionary<String, AnyObject> = self.parameters()
                    if let result = result {
                        parameters["producer_id"] = result.producerId
                    }
                    //Add product
                    ApiRequest().requestAddProduct(parameters) { (result) -> Void in
                        
                    }
                }
            }
        }
    }
    
    func parameters() -> Dictionary<String, AnyObject> {
        return ["title": self.productModel.title!,
                "info": self.productModel.info!,
                "code_type": self.codeType!,
                "code": self.productModel.productId!,
//                "producer_id": (self.productModel.producer?.producerId)!,
                "category_id": (self.productModel.category?.children?.first?.categoryId)!]
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        self.photoImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.photoImageView.layer.cornerRadius = 65
        self.addPhotoLabel.hidden = true
    }
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.titleTextField {
            self.productModel.title = self.titleTextField.text
            self.producerTextField.becomeFirstResponder()
        } else {
            self.producerTitle = self.producerTextField.text
            textField.resignFirstResponder()
        }
        return true
    }
    //MARK: AddCategoryViewControllerDelegate
    func categoryDidSelect(category: Category) {
        if self.isSubcategory {
            self.productModel.category?.children = [category]
        } else {
            self.productModel.category = category
        }
        updateUI()
    }
    //MARK: ChooseProductTypeViewControllerDelegate
    func productTypeDidSelect(productType: ProductType) {
        self.productModel.info = productType.rawValue
        updateUI()
    }
    //MARK: Protocol methods
    static func storyboardIdentifier() -> String {
        return storyboardId
    }
}
