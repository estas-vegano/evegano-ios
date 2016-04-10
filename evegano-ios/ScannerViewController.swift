//
//  ScannerViewController.swift
//  evegano-ios
//
//  Created by alexander on 09.04.16.
//  Copyright © 2016 nazavrik. All rights reserved.
//

import UIKit
import AVFoundation

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    //MARK: IBOutlet
    @IBOutlet weak var informationTextLabel: UILabel!
    @IBOutlet weak var codeInformationLabel: UILabel!
    @IBOutlet weak var borderView: CameraBorderView!
    @IBOutlet weak var cameraView: UIView!
    //MARK: Properties
    let captureSession = AVCaptureSession()
    var captureDevice: AVCaptureDevice?
    var captureLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.informationTextLabel.text = "Наведите камеру\nна штрих код";
        self.setupCaptureSession()
    }
    //MARK: Session Startup
    private func setupCaptureSession() {
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
            if let decodedData:AVMetadataMachineReadableCodeObject = metaData as? AVMetadataMachineReadableCodeObject {
                self.informationTextLabel.text = "Штрих код считан.\nИдет проверка продукта.\nЖдите...";
                let spiner = LoaderView(loaderType: .LoaderTypeBigAtTop, view: self.view)
                spiner.startAnimating()
                
                self.codeInformationLabel.hidden = false
                self.codeInformationLabel.text = "Type: " + decodedData.type + "\nID: " + decodedData.stringValue
            }
        }
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
    
    @IBAction func backButtonDown(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}
