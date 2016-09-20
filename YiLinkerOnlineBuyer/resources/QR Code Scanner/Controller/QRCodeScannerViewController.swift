//
//  QRCodeScannerViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 3/4/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit
import AVFoundation

protocol QRCodeScannerViewControllerDelegate {
    func qrCodeScannerViewController(qrCodeScannerViewController: QRCodeScannerViewController, code: String)
}

class QRCodeScannerViewController: UIViewController {
    
    var delegate: QRCodeScannerViewControllerDelegate?

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var flashButton: UIButton!
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    
    var isTorchOn: Bool = false
    
    var scanCount: Int = 0
    var isErrorShown: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // println("Self.bounce is: \(UIScreen.mainScreen().bounds)")
        
        self.flashButton.layer.cornerRadius = self.flashButton.frame.width / 2

        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        // Get an instance of the AVCaptureDeviceInput class using the previous device object.
        var error:NSError?
        let input: AnyObject! = AVCaptureDeviceInput.deviceInputWithDevice(captureDevice, error: &error)
        
        if (error != nil) {
            // If any error occurs, simply log the description of it and don't continue any more.
            println("\(error?.localizedDescription)")
            return
        }
        
        // Initialize the captureSession object.
        captureSession = AVCaptureSession()
        // Set the input device on the capture session.
        captureSession?.addInput(input as! AVCaptureInput)
        
        // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        
        // Set delegate and use the default dispatch queue to execute the call back
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = UIScreen.mainScreen().bounds
        previewView.layer.addSublayer(videoPreviewLayer)
        
        captureSession?.startRunning()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        captureSession?.stopRunning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.scanCount = 0
        self.resultView.layer.cornerRadius = 5
    }
    
    @IBAction func backAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func buttonAction(sender: UIButton) {
        if sender == self.flashButton {
            let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
            if (device.hasTorch) {
                device.lockForConfiguration(nil)
                let torchOn = !device.torchActive
                device.setTorchModeOnWithLevel(1.0, error: nil)
                device.torchMode = torchOn ? AVCaptureTorchMode.On : AVCaptureTorchMode.Off
                torchOn ? self.flashButton.setImage(UIImage(named: "flash_off"), forState: .Normal) : self.flashButton.setImage(UIImage(named: "flash_on"), forState: .Normal)
                device.unlockForConfiguration()
            }
        }
    }
}

extension QRCodeScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            self.resultView.hidden = true
            self.resultLabel.text = "No QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            
            if metadataObj.stringValue.contains("http") {
                self.resultView.hidden = true
                if self.scanCount == 0{
                    if metadataObj.stringValue != nil {
                        self.scanCount++
                        var qrCode: String = metadataObj.stringValue
                        self.dismissViewControllerAnimated(true, completion: nil)
                        self.delegate?.qrCodeScannerViewController(self, code: qrCode)
                    }
                }
            } else {
                self.resultLabel.text = metadataObj.stringValue
                self.resultView.hidden = false
//                if !self.isErrorShown {
//                    Toast.displayToastWithMessage(StringHelper.localizedStringWithKey("INVALID_QR_LOCALIZE_KEY"), duration: 1.5, view: self.view)
//                    self.isErrorShown = true
//                }
//                
//                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
//                dispatch_after(delayTime, dispatch_get_main_queue()) {
//                    self.isErrorShown = false
//                }
            }
        }
    }
}