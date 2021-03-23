//
//  CameraViewController.swift
//  StartLens
//
//  Created by 中野　裕太 on 2020/06/18.
//  Copyright © 2020 Nakano Yuta. All rights reserved.
//

import UIKit
import AVFoundation
import TensorFlowLite
import Accelerate
import Alamofire
import SwiftyJSON
import VideoToolbox

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate  {

    @IBOutlet weak var drawView: UIView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var circularProgress: UIActivityIndicatorView!
    @IBOutlet weak var picturePreview: UIImageView!
    
    var token = String()
    var spotId = Int()
    var exhibits = [Exhibit]()
    var inferredExhibits = [Exhibit]()

    var captureSession = AVCaptureSession()
    var mainCamera: AVCaptureDevice?
    var innerCamera: AVCaptureDevice?
    var currentDevice: AVCaptureDevice?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var photoOutput: AVCapturePhotoOutput?

    let BATCH_SIZE = 1
    let INPUT_CHANNELS = 3
    let INPUT_WIDTH = 224
    let INPUT_HEIGHT = 224
    let THREAD_COUNT = 1

    var interpreter: Interpreter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initial settings
        guard let savedToken = UserDefaults.standard.string(forKey: "token") else {
            // if cannot get a token, move to login screen
            print("Action: ViewDidLoad, Message: No token Error")
            return
        }
        token = savedToken
        
        // UI settings
        setupUI()
        
        // Camera settings
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        // Start capture session
        captureSession.startRunning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        do {
            print("Action: viewDidAppear, Message: Load tensorflow model")
            // To be changed depends on learning
            let modelPath = Bundle.main.path(forResource: "embedding_20210210_051144", ofType: "tflite")!
            var options = Interpreter.Options()
            options.threadCount = THREAD_COUNT
            // Generate interpreter
            interpreter = try Interpreter(modelPath: modelPath, options: options)
            try interpreter.allocateTensors()
        } catch let error{
            print("Action: viewDidAppear, Message: Generate interpreter error, Error: \(error.localizedDescription)")
        }
    }
    
    override func viewDidLayoutSubviews() {
        //previewLayer.frame = self.drawView.bounds
        print("drawView in viewdidlayoutsubview: \(self.drawView.bounds)")
    }
    
    func setupUI() {
        circularProgress.isHidden = true
        cameraButton.layer.borderColor = UIColor.white.cgColor
        cameraButton.layer.borderWidth = 5
        cameraButton.clipsToBounds = true
        cameraButton.layer.cornerRadius = 30.0
    }

    @IBAction func cameraButtonAction(_ sender: Any) {
        print("Action: cameraButonAction, Message: button is tapped")
        // Output data setting
        let pixelFormatType = kCVPixelFormatType_32BGRA
        guard (self.photoOutput?.availablePhotoPixelFormatTypes.contains(pixelFormatType))! else {return}
        let settings = AVCapturePhotoSettings(format: [kCVPixelBufferPixelFormatTypeKey as String : pixelFormatType])
        // Flash setting
        settings.flashMode = .auto
        settings.isAutoStillImageStabilizationEnabled = true
        // Handle a taken picture
        self.photoOutput?.capturePhoto(with: settings, delegate: self as AVCapturePhotoCaptureDelegate)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupCaptureSession() {
        // Camera image quality settings
        captureSession.sessionPreset = AVCaptureSession.Preset.medium
    }
    
    func setupDevice() {
        // Capture devise settings
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        // Get camera devices that meet the property conditions
        let devices = deviceDiscoverySession.devices
        
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                mainCamera = device
            } else if device.position == AVCaptureDevice.Position.front {
                innerCamera = device
            }
        }
        // Set camera position at activating
        currentDevice = mainCamera
    }
    
    func setupInputOutput() {
        // Input and Output settings
        do {
            // Initialize input device data
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentDevice!)
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            // photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
        } catch {
            print("Action: setupInputOutput, Message: AVCaptureDeviceInput error \(error)")
        }
    }
    
    func setupPreviewLayer() {
        // Preview layer settings
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.previewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        self.previewLayer?.frame = self.drawView.frame
        print("Action: setupPreviewLayer, drawView: \(self.drawView.frame)")
        self.view.layer.insertSublayer(self.previewLayer!, at: 2)
    }

    func predict(_ pixelBuffer: CVPixelBuffer) {
        /**
         - Parameters
            pixelBuffer: captured picture in the format of CVPIxelBuffer
         */
        // Convert CMSampleBuffer to CVPixelBuffer
        // let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!

        // Confirm pixel format
        let sourcePixelFormat = CVPixelBufferGetPixelFormatType(pixelBuffer)
        print("Action: predict, sourcePixelFormat: \(sourcePixelFormat)")
        assert(sourcePixelFormat == kCVPixelFormatType_32ARGB ||
            sourcePixelFormat == kCVPixelFormatType_32BGRA ||
            sourcePixelFormat == kCVPixelFormatType_32RGBA)

        // Crop and Scale image
        let scaledSize = CGSize(width: INPUT_WIDTH, height: INPUT_HEIGHT)
        guard let cropPixelBuffer = pixelBuffer.centerThumbnail(ofSize: scaledSize) else {
            return
        }
        
        let outputTensor: Tensor
        do {
            // Generate RGB data
            let inputTensor = try interpreter.input(at: 0)
            print("Action: predict, inputTensor data type: \(inputTensor.dataType)")
            let rgbData = buffer2rgbData(
                cropPixelBuffer,
                byteCount: BATCH_SIZE * INPUT_WIDTH * INPUT_HEIGHT * INPUT_CHANNELS, isModelQuantized: inputTensor.dataType == .uInt8)
            // Execute interpretation
            print("Action: predict, rgbData: \(rgbData!)")
            print("Action: predict, rgbData count: \(rgbData!.count)")
            try interpreter.copy(rgbData!, toInputAt: 0)
            try interpreter.invoke()
            outputTensor = try interpreter.output(at: 0)
        } catch let error {
            print("Action: predict, Message: Error occured. \(error.localizedDescription)")
            return
        }
        
        var results: [Float] = []
        // Quantized model
        if outputTensor.dataType == .uInt8 {
            let quantization = outputTensor.quantizationParameters!
            let quantizedResults = [UInt8](outputTensor.data)
            results = quantizedResults.map{
                quantization.scale * Float(Int($0) - quantization.zeroPoint)}
        }
        // Float model
        else if outputTensor.dataType == .float32 {
            results = [Float32](unsafeData: outputTensor.data) ?? []
        }
        
        print("Action: predict, results: \(results)")
        // Send 50 dim vector data to API server
        fetchData(result: results)
    }
    
    // Convert PixelBuffer to rgbData
    private func buffer2rgbData(_ buffer: CVPixelBuffer, byteCount: Int, isModelQuantized: Bool) -> Data? {
        // from PixelBuffer to bufferData
        CVPixelBufferLockBaseAddress(buffer, .readOnly)
        defer { CVPixelBufferUnlockBaseAddress(buffer, .readOnly) }
        guard let mutableRawPointer = CVPixelBufferGetBaseAddress(buffer) else {
          return nil
        }
        let count = CVPixelBufferGetDataSize(buffer)
        let bufferData = Data(bytesNoCopy: mutableRawPointer,
            count: count, deallocator: .none)

        // from bufferData to rgbBytes
        var bgrBytes = [UInt8](repeating: 0, count: byteCount)
        var index = 0
        for component in bufferData.enumerated() {
          let offset = component.offset
          let isAlphaComponent = (offset % 4) == 3
          guard !isAlphaComponent else {continue}
          bgrBytes[index] = component.element
          index += 1
        }
        print("Action: buffer2rgbData, bgrBytes: \(bgrBytes[0...100])")
        print("Action: buffer2rgbData, length of bgrBytes: \(bgrBytes.count)")
        // BGRからRGBへ変換
        let rgbBytes: [UInt8] = convertBgr2Rgb(bgrBytes: bgrBytes)
        print("Action: buffer2rgbData, rgbBytes: \(rgbBytes[0...100])")
        // from rgbBytes to rgbData
        if isModelQuantized {
            print("Action: buffer2rgbData, Message: quantized model data")
            return Data(bytes: rgbBytes)
        }
        print("Action: buffer2rgbData, Message: float model data")
        return Data(copyingBufferOf: rgbBytes.map{Float($0)/1.0})
    }
    
    // Convert UIImage to CVPixelBUffer
    func buffer(from image: UIImage) -> CVPixelBuffer? {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(image.size.width), Int(image.size.height), kCVPixelFormatType_32BGRA, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return nil
        }
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        context?.translateBy(x: 0, y: image.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        UIGraphicsPushContext(context!)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        return pixelBuffer
    }
    
    func convertBgr2Rgb(bgrBytes: [UInt8]) -> [UInt8] {
        var rgbBytes = [UInt8]()
        for i in stride(from: 0, to: bgrBytes.count, by: 3) {
            rgbBytes.append(bgrBytes[i + 2])
            rgbBytes.append(bgrBytes[i + 1])
            rgbBytes.append(bgrBytes[i])
        }
        return rgbBytes
    }
    
    func fetchData(result: [Float]) {
        let url = Constants.learningURL + Constants.inferenceURL
        print("Action: fetchData, url: \(url)")
        let parameters = ["spotId": self.spotId, "data": result] as [String : Any]
        print("Action: fetchData, parameters: \(parameters)")

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
            case .success:
                let json:JSON = JSON(response.data as Any)
                let isError: Bool? = json["error"].bool

                if let isError = isError, !isError {
                    // Succeeded to fetch inferred results
                    var results = [Int]()
                    if let items = json["result"].array {
                        for item in items {
                            results.append(item.int!)
                        }
                    }
                    print("Action: fetchData, result: \(results)")
                    // Filter Exhibits
                    self.inferredExhibits = self.exhibits.filter({ exhibit in results.contains(exhibit.id) })
                    self.performSegue(withIdentifier: "exhibitResult", sender: nil)
                } else {
                    // TODO: move to isError is true
                    print("Action: fetchData, Message: Error occured")
                    self.performSegue(withIdentifier: "exhibitResult", sender: nil)
                }
            case .failure(let error):
                print("Action: fetchData, Message: Error occured. \(error)")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let exhibitResultVC = segue.destination as! ExhibitResultViewController
        exhibitResultVC.exhibits = self.inferredExhibits
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    // delegate method that called when picture is taken
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        print("Action: photoOutput, Message: AVCapturePhotoCaptureDelegate is called")
        if let imageData = photo.pixelBuffer {
            // Set picture preview
            let uiImage = UIImage(pixelBuffer: imageData)?.rotatedBy(degree: 90)
            self.picturePreview.image = uiImage
            // Conver to CVPixelBuffer
            let pixelBufferImage = buffer(from: uiImage!)
            
            // TODO: test case
            // let picturePath = Bundle.main.path(forResource: "04a16fec-645a-4e9a-99b8-126098f90f75", ofType: "jpg")!
            // let uiImage = UIImage(contentsOfFile: picturePath)
            // let pixelBufferImage = buffer(from: uiImage!)

            // Predict image data
            predict(pixelBufferImage!)
        }
    }
}

// Augument CVPixelBuffer
extension CVPixelBuffer {
   // Trim and scale image
   func centerThumbnail(ofSize size: CGSize ) -> CVPixelBuffer? {
       let imageWidth = CVPixelBufferGetWidth(self)
       let imageHeight = CVPixelBufferGetHeight(self)
       let pixelBufferType = CVPixelBufferGetPixelFormatType(self)
       // assert(pixelBufferType == kCVPixelFormatType_32BGRA)
       let inputImageRowBytes = CVPixelBufferGetBytesPerRow(self)
       let imageChannels = 4
       let thumbnailSize = min(imageWidth, imageHeight)
       CVPixelBufferLockBaseAddress(self, CVPixelBufferLockFlags(rawValue: 0))
       var originX = 0
       var originY = 0
       if imageWidth > imageHeight {
         originX = (imageWidth - imageHeight) / 2
       }
       else {
         originY = (imageHeight - imageWidth) / 2
       }
       
       // Find out a maximum size square in PixelBuffer
       guard let inputBaseAddress = CVPixelBufferGetBaseAddress(self)?.advanced(
           by: originY * inputImageRowBytes + originX * imageChannels) else {
         return nil
       }
       
       // Get image buffer from input image
       var inputVImageBuffer = vImage_Buffer(
           data: inputBaseAddress, height: UInt(thumbnailSize), width: UInt(thumbnailSize),
           rowBytes: inputImageRowBytes)
       let thumbnailRowBytes = Int(size.width) * imageChannels
       guard  let thumbnailBytes = malloc(Int(size.height) * thumbnailRowBytes) else {
         return nil
       }
       
       // Allocate vImage buffer for thumbnail images
       var thumbnailVImageBuffer = vImage_Buffer(data: thumbnailBytes,
           height: UInt(size.height), width: UInt(size.width), rowBytes: thumbnailRowBytes)
       
       // Perform a scale operation in the input image buffer and save it in the thumbnail image buffer
       let scaleError = vImageScale_ARGB8888(&inputVImageBuffer, &thumbnailVImageBuffer, nil, vImage_Flags(0))
       CVPixelBufferUnlockBaseAddress(self, CVPixelBufferLockFlags(rawValue: 0))
       guard scaleError == kvImageNoError else {
         return nil
       }
       let releaseCallBack: CVPixelBufferReleaseBytesCallback = {mutablePointer, pointer in
           if let pointer = pointer {
               free(UnsafeMutableRawPointer(mutating: pointer))
           }
       }
       // Convert vImage buffer to CVPixelBuffer
       var thumbnailPixelBuffer: CVPixelBuffer?
       let conversionStatus = CVPixelBufferCreateWithBytes(
           nil, Int(size.width), Int(size.height), pixelBufferType, thumbnailBytes,
           thumbnailRowBytes, releaseCallBack, nil, nil, &thumbnailPixelBuffer)
       guard conversionStatus == kCVReturnSuccess else {
         free(thumbnailBytes)
         return nil
       }
       return thumbnailPixelBuffer
   }
}

// Augument Data
extension Data {
   // Convert float array to byte array(4 times length)
   init<T>(copyingBufferOf array: [T]) {
       self = array.withUnsafeBufferPointer(Data.init)
   }
}

// Augument Array
extension Array {
   // Convert byte array to float array(1/4 times length)
   init?(unsafeData: Data) {
       guard unsafeData.count % MemoryLayout<Element>.stride == 0 else { return nil }
       #if swift(>=5.0)
       self = unsafeData.withUnsafeBytes { .init($0.bindMemory(to: Element.self)) }
       #else
       self = unsafeData.withUnsafeBytes {
           .init(UnsafeBufferPointer<Element>(
               start: $0,
               count: unsafeData.count / MemoryLayout<Element>.stride
           ))
       }
       #endif  // swift(>=5.0)
   }
}

// Augument UIImage
extension UIImage {
    // Convert from type of CVPixelBuffer to UIImage through CGImage in order to render a picture
    public convenience init?(pixelBuffer: CVPixelBuffer) {
        var cgImage: CGImage?
        VTCreateCGImageFromCVPixelBuffer(pixelBuffer, options: nil, imageOut: &cgImage)
        
        if let cgImage = cgImage {
            self.init(cgImage: cgImage)
        } else {
            return nil
        }
    }
    
    // Rotate UIImage by designated degree
    func rotatedBy(degree: CGFloat) -> UIImage {
        let radian = -degree * CGFloat.pi / 180
        UIGraphicsBeginImageContext(self.size)
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: self.size.width / 2, y: self.size.height / 2)
        context.scaleBy(x: 1.0, y: -1.0)
        context.rotate(by: radian)
        context.draw(self.cgImage!, in: CGRect(x: -(self.size.width / 2), y: -(self.size.height / 2), width: self.size.width, height: self.size.height))
        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return rotatedImage
    }
}
