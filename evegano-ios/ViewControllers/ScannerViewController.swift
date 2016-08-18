//
//  ScannerViewController.swift
//  evegano-ios
//
//  Created by alexander on 09.04.16.
//  Copyright © 2016 nazavrik. All rights reserved.
//

import UIKit
import AVFoundation

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, ViewControllerDismissProtocol {
    //MARK: IBOutlet
    @IBOutlet weak var informationTextLabel: UILabel! {
        didSet {
            informationTextLabel.text = "Наведите камеру\nна штрих код";
        }
    }
    @IBOutlet weak var codeInformationLabel: UILabel!
    @IBOutlet weak var borderView: CameraBorderView!
    @IBOutlet weak var cameraView: UIView!
    //MARK: Properties
    let captureSession = AVCaptureSession()
    var captureDevice: AVCaptureDevice?
    var captureLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.setupCaptureSession()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.setupCaptureSession()
    }
    
    //MARK: Session Startup
    private func setupCaptureSession() {
        if self.captureDevice == nil {
            self.captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
            
            do{
                let deviceInput = try AVCaptureDeviceInput(device:self.captureDevice!)
                //Add the input feed to the session and start it
                self.captureSession.addInput(deviceInput)
                self.setupPreviewLayer( {
                    self.captureSession.startRunning()
                    self.addMetaDataCaptureOutToSession()
                })
                self.borderView.hidden = false
            } catch let error as NSError {
                self.showError(error.localizedDescription)
            }
        }
    }
    
    private func setupPreviewLayer(completion:() -> ()) {
        self.captureLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        if let capLayer = self.captureLayer {
            capLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            capLayer.frame = self.cameraView.frame
            self.cameraView.layer.addSublayer(capLayer)

            completion()
        } else {
            self.showError("An error occured beginning video capture.")
        }
        
    }
    
    private func reset() {
        self.informationTextLabel.text = "Наведите камеру\nна штрих код"
        self.codeInformationLabel.hidden = true
        self.codeInformationLabel.text = nil
        self.captureSession.startRunning()
    }
    
    //MARK: Metadata capture
    private func addMetaDataCaptureOutToSession() {
        let metadata = AVCaptureMetadataOutput()
        self.captureSession.addOutput(metadata)
        metadata.metadataObjectTypes = metadata.availableMetadataObjectTypes
        metadata.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
    }
    //MARK: Delegate Methods
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        for metaData in metadataObjects {
            if let decodedData: AVMetadataMachineReadableCodeObject = metaData as? AVMetadataMachineReadableCodeObject {
                self.captureSession.stopRunning()
                
                self.informationTextLabel.text = "Штрих код считан.\nИдет проверка продукта.\nЖдите...";
                let spiner = LoaderView(loaderType: .LoaderTypeBigAtTop, view: self.view)
                spiner.startAnimating()
                
                ApiRequest().requestCheckProduct(decodedData.stringValue, type: decodedData.type, completion: { (result, error) -> Void in
                    spiner.stopAnimating()
                    if let error = error {
                        if error.errorCode == -7 {//Product code not found.                            
                            let alertController = UIAlertController(title: "No product found", message: "Would you like to add it?", preferredStyle: .Alert)
                            let dismiss: UIAlertAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.Destructive, handler:{(alert:UIAlertAction) in
                                alertController.dismissViewControllerAnimated(true, completion: nil)
                                
                                let modalViewController: AddProductViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController()
//                                modalViewController.modalPresentationStyle = .OverCurrentContext
                                modalViewController.productModel.productId = Int(decodedData.stringValue)
                                modalViewController.codeType = decodedData.type
                                modalViewController.delegate = self
                                let navigationController = UINavigationController(rootViewController: modalViewController)
                                navigationController.setNavigationBarHidden(true, animated: false)
                                self.presentViewController(navigationController, animated: true, completion: nil)
                            })
                            alertController.addAction(dismiss)
                            let cancel: UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Destructive, handler:{(alert:UIAlertAction) in
                                self.reset()
                                alertController.dismissViewControllerAnimated(true, completion: nil)
                            })
                            alertController.addAction(cancel)
                            self.presentViewController(alertController, animated: true, completion: nil)
                        }
                    } else {
                        let modalViewController: ProductInfoViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController()
                        modalViewController.modalPresentationStyle = .OverCurrentContext
                        modalViewController.code = result?.codes?.first
                        modalViewController.delegate = self
                        self.presentViewController(modalViewController, animated: true, completion: nil)
                    }
                });
                
                self.codeInformationLabel.hidden = false
                self.codeInformationLabel.text = "Type: " + decodedData.type + "\nID: " + decodedData.stringValue
            }
        }
    }
    
    func viewControllerDidDismiss() {
        self.reset()
    }
    
    //MARK: Utility Functions
    private func showError(error:String)
    {
        let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .Alert)
        let dismiss:UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Destructive, handler:{(alert:UIAlertAction) in
            alertController.dismissViewControllerAnimated(true, completion: nil)
        })
        alertController.addAction(dismiss)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
