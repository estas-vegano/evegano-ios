//
//  AddProductViewController.swift
//  evegano-ios
//
//  Created by alexander on 31.01.16.
//  Copyright © 2016 nazavrik. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AddProductViewController: UIViewController, AddCategoryViewControllerDelegate, StoryboardIdentifierProtocol, ChooseProductTypeViewControllerDelegate, ChooseProductInfoDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: variables
    var delegate: ViewControllerDismissProtocol?
    
    var productModel = Product()
    var isSubcategory = false
    var producerTitle: String?
    var codeType: String?
    
    private var imagePicker: UIImagePickerController!
    private var isProductName = false
    private let disposeBag = DisposeBag()
    //MARK: IBOutlet
    @IBOutlet weak var subcategoryView: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var addPhotoLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var typeValueLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleValueLabel: UILabel!
    @IBOutlet weak var producerLabel: UILabel!
    @IBOutlet weak var producerValueLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryValeLabel: UILabel!
    @IBOutlet weak var subcategoryLabel: UILabel!
    @IBOutlet weak var subcategoryValueLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.typeLabel.text = "Type"
        self.typeValueLabel.text = "Select type"
        self.titleLabel.text = "Title"
        self.titleValueLabel.text = "Enter title"
        self.producerLabel.text = "Producer"
        self.producerValueLabel.text = "Enter producer"
        self.categoryLabel.text = "Category"
        self.categoryValeLabel.text = "Choose category"
        self.subcategoryLabel.text = "Subcategory"
        self.subcategoryValueLabel.text = "Choose subcategory"
        
//        var typeObservable: Observable<String> = Observable.create { (text) -> Disposable in
//            
//        }
        
//        var addProductViewModel = AddProductViewModel(input: (
//            type: typeValueLabel.rx_text.asObserver(),
//            title: titleValueLabel.rx_text
//            ) {
//        
//        }

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    //MARK: UI
    func updateUI() {
        if let category = self.productModel.category {
            self.categoryValeLabel.text = category.title
            self.subcategoryView.hidden = false
        } else {
            self.categoryValeLabel.text = "Выберете категорию"
            self.subcategoryView.hidden = true
        }
        if let subcategory = self.productModel.category?.children {
            self.subcategoryValueLabel.text = subcategory.first?.title
        } else {
            self.subcategoryValueLabel.text = "Выберете подкатегорию"
        }
        if let productType = self.productModel.info {
            self.typeValueLabel.text = productType
        } else {
            self.typeValueLabel.text = "Select type"
        }
        rx_canAddProduct().subscribeNext { [weak self] canAdd -> Void in
            self?.addButton.enabled = canAdd
        }
        .addDisposableTo(disposeBag)
    }
    //MARK: IBActions
    @IBAction func chooseCategoryButtonDown(sender: UIButton) {
        self.isSubcategory = false
        
        let viewController: AddCategoryViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController()
        viewController.modalPresentationStyle = .OverCurrentContext
        viewController.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func chooseSubcategoryButtonDown(sender: UIButton) {
        self.isSubcategory = true
        
        let viewController: AddCategoryViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController()
        viewController.modalPresentationStyle = .OverCurrentContext
        viewController.delegate = self
        viewController.category = self.productModel.category
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func backButtonDown(sender: UIButton) {
        self.delegate?.viewControllerDidDismiss()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func chooseProducerButtonDown(sender: AnyObject) {
        let viewController: ChooseProductTitleViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController()
        viewController.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
        self.isProductName = false
    }
    
    @IBAction func chooseTitleButtonDown(sender: UIButton) {
        let viewController: ChooseProductTitleViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController()
        viewController.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
        self.isProductName = true
    }
    
    @IBAction func addPhotoButtonDown(sender: UIButton) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func chooseTypeAction(sender: UIButton) {
        let viewController: ChooseProductTypeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController()
        viewController.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
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
    
    //MARK: rx
    func rx_canAddProduct() -> Observable<Bool> {
        let hasType = self.typeValueLabel.text?.characters.count > 0
        let hasTitle = self.titleValueLabel.text?.characters.count > 0
        let hasProducer = self.producerValueLabel.text?.characters.count > 0
        let hasCategory = self.categoryValeLabel.text?.characters.count > 0
        let hasSubcategory = self.subcategoryValueLabel.text?.characters.count > 0
        let canAddProduct = hasType && hasTitle && hasProducer && hasCategory && hasSubcategory
        return Observable.create({ (observer) -> Disposable in
            observer.onNext(canAddProduct)
            return AnonymousDisposable {
            }
        })
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        self.photoImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.photoImageView.layer.cornerRadius = 65
        self.addPhotoLabel.hidden = true
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
    //MARK: ChooseProductInfoDelegate
    func productInfoDidSelect(title: String) {
        if self.isProductName {
            self.titleValueLabel.text = title
        } else {
            self.producerValueLabel.text = title
        }
    }
    //MARK: constants
    private static let storyboardId = "AddProductViewControllerId"
    //MARK: Protocol methods
    static func storyboardIdentifier() -> String {
        return storyboardId
    }
}
