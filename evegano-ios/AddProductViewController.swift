//
//  AddProductViewController.swift
//  evegano-ios
//
//  Created by alexander on 31.01.16.
//  Copyright © 2016 nazavrik. All rights reserved.
//

import UIKit

class AddProductViewController: UIViewController, AddCategoryViewControllerDelegate, StoryboardIdentifierProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //constants
    static let storyboardId = "AddProductViewControllerId"
    //MARK: variables
    var productModel = Product()
    var isSubcategory = false
    
    var imagePicker: UIImagePickerController!
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var subcategoryLabel: UILabel!
    @IBOutlet weak var subcategoryView: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var addPhotoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //UI
    func updateUI() {
        if let category = self.productModel.category {
            self.categoryLabel.text = category.title
            self.subcategoryView.hidden = false
        } else {
            self.categoryLabel.text = "Выберете категорию"
            self.subcategoryView.hidden = true
        }
        if let subcategory = self.productModel.category?.children {
            self.subcategoryLabel.text = subcategory.first?.title
        } else {
            self.subcategoryLabel.text = "Выберете подкатегорию"
        }
    }
    //IBActions
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
        presentViewController(viewController, animated: true) { () -> Void in
            
        }
    }
    
    @IBAction func backButtonDown(sender: UIButton) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func addPhotoButtonDown(sender: UIButton) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    //UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        self.photoImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.photoImageView.layer.cornerRadius = 65
        self.addPhotoLabel.hidden = true
    }
    //AddCategoryViewControllerDelegate
    func categoryDidSelect(category: Category) {
        if self.isSubcategory {
            self.productModel.category?.children = [category]
        } else {
            self.productModel.category = category
        }
        updateUI()
    }
    //Protocol methods
    static func storyboardIdentifier() -> String {
        return storyboardId
    }
}
