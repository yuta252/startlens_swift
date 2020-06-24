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

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate  {

    
    @IBOutlet weak var drawView: UIView!
    @IBOutlet weak var cameraButton: UIButton!
    
    
    var apiKey = String()
    var spotId: Int?
    var exhibitItem = [Exhibit]()
    // デバイスからの入力と出力を管理するオブジェクト生成
    var captureSession = AVCaptureSession()
    // プレビュー表示用のレイヤー
    var previewLayer: AVCaptureVideoPreviewLayer!
    // キャプチャーの出力データを受け付けるオブジェクト
    var photoOutput: AVCapturePhotoOutput?
    // パラメータ
    let BATCH_SIZE = 1
    let INPUT_CHANNELS = 3
    let INPUT_WIDTH = 224
    let INPUT_HEIGHT = 224
    let THREAD_COUNT = 1
    
    // 参照
    var interpreter: Interpreter!
    //var labels: [String]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 初期設定
        apiKey = UserDefaults.standard.string(forKey: "apiKey")!
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        do{
            // モデルパス（変更する）
            let modelPath = Bundle.main.path(forResource: "embedding_20200117_123222", ofType: "tflite")!
            var options = Interpreter.Options()
            options.threadCount = THREAD_COUNT
            
            // インタプリタ生成
            interpreter = try Interpreter(modelPath: modelPath, options: options)
            try interpreter.allocateTensors()
            
        } catch let error{
            print(error.localizedDescription)
        }
        
        // カメラキャプチャ開始
        startCapture()
    }
    
    override func viewDidLayoutSubviews() {
        //previewLayer.frame = self.drawView.bounds
        print("drawView in viewdidlayoutsubview: \(self.drawView.bounds)")
    }
    

    @IBAction func cameraButtonAction(_ sender: Any) {
        print("tapped")
              
        // ROW出力データの設定
        let pixelFormatType = kCVPixelFormatType_32BGRA
        guard (self.photoOutput?.availablePhotoPixelFormatTypes.contains(pixelFormatType))! else {return}
        let photoSettings = AVCapturePhotoSettings(format: [kCVPixelBufferPixelFormatTypeKey as String : pixelFormatType])
          
        // フラッシュ設定
        photoSettings.flashMode = .auto
        // カメラの手ぶれ補正
        photoSettings.isAutoStillImageStabilizationEnabled = true
        // 撮影された画像をdelegateメソッドで処理
        self.photoOutput?.capturePhoto(with: photoSettings, delegate: self as AVCapturePhotoCaptureDelegate)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func setupUI(){
        cameraButton.layer.cornerRadius = 40.0
    }
    
    
    func startCapture() {
        // セッションの生成
        // カメラの画質設定
        captureSession.sessionPreset = AVCaptureSession.Preset.photo //プリセット
        let captureDevice: AVCaptureDevice! = self.device(false)
        //コンフィギュレーションの指定
        do {
            try captureDevice.lockForConfiguration()
            captureDevice.activeVideoMinFrameDuration = CMTimeMake(value: 1, timescale: 20) //FPS
            captureDevice.focusMode = .continuousAutoFocus //フォーカス
            captureDevice.exposureMode = .continuousAutoExposure //露出
            captureDevice.whiteBalanceMode = .continuousAutoWhiteBalance //ホワイトバランス
            captureDevice.unlockForConfiguration()
        } catch {
            return
        }

        //入力の生成
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else {return}
        guard captureSession.canAddInput(input) else {return}
        captureSession.addInput(input)

        //出力の生成(カメラ撮影用に変更)
        photoOutput = AVCapturePhotoOutput()
        // jpeg形式で出力
        //photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)

        captureSession.addOutput(photoOutput!)
        
        // 動画でフレームごとに出力データを予測する場合
        //let output: AVCaptureVideoDataOutput = AVCaptureVideoDataOutput()
        //output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "VideoQueue"))
        //output.videoSettings = [String(kCVPixelBufferPixelFormatTypeKey) : kCMPixelFormat_32BGRA] //画像フォーマット
        //output.alwaysDiscardsLateVideoFrames = true //出力の遅延フレームの破棄
        //guard captureSession.canAddOutput(output) else {return}
        //captureSession.addOutput(output)

        //画面の向き
        //let videoConnection = output.connection(with: AVMediaType.video)
        //videoConnection!.videoOrientation = .portrait
    
        //プレビューの指定
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        print("drawView frame in start capture: \(self.drawView.frame)")
        previewLayer.frame = self.drawView.frame
        print("previewlayer in start capture: \(previewLayer.frame)")
        
        self.view.layer.insertSublayer(previewLayer, at: 2)

        //カメラキャプチャの開始
        captureSession.startRunning()
    }

    //デバイスの取得
    func device(_ frontCamera: Bool) -> AVCaptureDevice! {
        //AVCaptureDeviceのリストの取得
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera],
            mediaType: AVMediaType.video,
            position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySession.devices

        //指定したポジションを持つAVCaptureDeviceの検索
        let position: AVCaptureDevice.Position = frontCamera ? .front : .back
        for device in devices {
            if device.position == position {
                return device
            }
        }
        return nil
    }

 
    //予測(引数: CVPixelBuffer）
    func predict(_ pixelBuffer: CVPixelBuffer){
        //CMSampleBufferをCVPixelBufferに変換
        //let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!

        //Pixelフォーマットの確認
        let sourcePixelFormat = CVPixelBufferGetPixelFormatType(pixelBuffer)
        assert(sourcePixelFormat == kCVPixelFormatType_32ARGB ||
            sourcePixelFormat == kCVPixelFormatType_32BGRA ||
            sourcePixelFormat == kCVPixelFormatType_32RGBA)


        //画像のクロップとスケーリング
        let scaledSize = CGSize(width: INPUT_WIDTH, height: INPUT_HEIGHT)
        guard let cropPixelBuffer = pixelBuffer.centerThumbnail(ofSize: scaledSize) else {
            return
        }
        
        print(cropPixelBuffer)
        
        let outputTensor: Tensor
        do {
            // RGBデータの生成
            let inputTensor = try interpreter.input(at: 0)
            print("inputTensor data type: \(inputTensor.dataType)")
            let rgbData = buffer2rgbData(
                cropPixelBuffer,
                byteCount: BATCH_SIZE * INPUT_WIDTH * INPUT_HEIGHT * INPUT_CHANNELS, isModelQuantized: inputTensor.dataType == .uInt8)
            print("rgbData: \(rgbData!)")
            // 推論の実行
            try interpreter.copy(rgbData!, toInputAt: 0)
            try interpreter.invoke()
            outputTensor = try interpreter.output(at: 0)
            
        } catch let error {
            print(error.localizedDescription)
            return
        }
        
        var results: [Float] = []
        
        //量子化モデル
        if outputTensor.dataType == .uInt8 {
            let quantization = outputTensor.quantizationParameters!
            let quantizedResults = [UInt8](outputTensor.data)
            results = quantizedResults.map{
                quantization.scale * Float(Int($0) - quantization.zeroPoint)}
        }
        //浮動少数モデル
        else if outputTensor.dataType == .float32 {
            results = [Float32](unsafeData: outputTensor.data) ?? []
        }
        
        
        print("output")
        print(results)
        
        // データ送信
        fetchData(result: results)
        
    }
    
    // PixelBuffer → rgbDataへの変換処理
    private func buffer2rgbData(_ buffer: CVPixelBuffer, byteCount: Int, isModelQuantized: Bool) -> Data?{
        
        //PixelBuffer→bufferData
        CVPixelBufferLockBaseAddress(buffer, .readOnly)
        defer { CVPixelBufferUnlockBaseAddress(buffer, .readOnly) }
        guard let mutableRawPointer = CVPixelBufferGetBaseAddress(buffer) else {
          return nil
        }
        let count = CVPixelBufferGetDataSize(buffer)
        let bufferData = Data(bytesNoCopy: mutableRawPointer,
            count: count, deallocator: .none)

        //bufferData→rgbBytes
        var rgbBytes = [UInt8](repeating: 0, count: byteCount)
        var index = 0
        for component in bufferData.enumerated() {
          let offset = component.offset
          let isAlphaComponent = (offset % 4) == 3
          guard !isAlphaComponent else {continue}
          rgbBytes[index] = component.element
          index += 1
        }
        print("rgbBytes: \(rgbBytes)")
        print("rgbBytes flaot: \(rgbBytes.map{Float($0)})")
        //rgbBytes→rgbData
        if isModelQuantized {
            print("量子化モデル")
            return Data(bytes: rgbBytes)
        }
        //return Data(copyingBufferOf: rgbBytes.map{Float($0)/255.0})
        return Data(copyingBufferOf: rgbBytes.map{Float($0)/1.0})
    }
    
    func fetchData(result: [Float]){
        // POSTするパラメータ作成
        let parameters = ["apiKey": apiKey, "result": result, "spot": spotId!] as [String : Any]
        print(parameters)
        // メールアドレスとパスワードをJSON形式でサーバーに送信する
        AF.request(Constants.cameraURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            print(response)
            
            switch response.result{
            
            case .success:
                let json:JSON = JSON(response.data as Any)
                
                self.exhibitItem = []
                // レコメンドデータのParse
                if let num = json["info"]["exhibitNum"].int, num != 0{
                    let roopNum = num - 1

                    for i in 0...roopNum{
                        let exhibitId = json["result"][i]["exhibitId"].int
                        let exhibitName = json["result"][i]["exhibitName"].string
                        let exhibitUrl = json["result"][i]["exhibitUrl"].string
                        print("exhibitName: \(exhibitName!), exhibitUrl: \(exhibitUrl!)")
                        let exhibit: Exhibit = Exhibit(exhibitId: exhibitId!, exhibitName: exhibitName!, exhibitImage: exhibitUrl!, exhibitIntro: "like")
                        self.exhibitItem.append(exhibit)
                    }
                    
                    // 結果画面へ遷移
                    self.performSegue(withIdentifier: "exhibitResult", sender: nil)
                }
                print("exhibitItem: \(self.exhibitItem)")
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let exhibitResultVC = segue.destination as! ExhibitResultViewController
        exhibitResultVC.spotId = spotId
        // exhibitDetailVC.exhibitId = exhibitId
        exhibitResultVC.exhibitItem = self.exhibitItem
    }
}

//MARK: AVCapturePhotoCaptureDelegateメソッド
extension CameraViewController: AVCapturePhotoCaptureDelegate{

    // 撮影した画像データが生成されたときに呼び出されるデリゲートメソッド
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        print("avcapturePhotoCaptureDelegate is called")
        if let imageData = photo.pixelBuffer {
            print("imageData: \(imageData)")
            predict(imageData)
        }
    }
}


//CVPixelBufferの拡張
extension CVPixelBuffer {
   //画像のトリミングとスケーリング
   func centerThumbnail(ofSize size: CGSize ) -> CVPixelBuffer? {
       let imageWidth = CVPixelBufferGetWidth(self)
       let imageHeight = CVPixelBufferGetHeight(self)
       let pixelBufferType = CVPixelBufferGetPixelFormatType(self)
       assert(pixelBufferType == kCVPixelFormatType_32BGRA)
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
       
       //PixelBufferで最大の正方形をみつける
       guard let inputBaseAddress = CVPixelBufferGetBaseAddress(self)?.advanced(
           by: originY * inputImageRowBytes + originX * imageChannels) else {
         return nil
       }
       
       //入力画像から画像バッファを取得
       var inputVImageBuffer = vImage_Buffer(
           data: inputBaseAddress, height: UInt(thumbnailSize), width: UInt(thumbnailSize),
           rowBytes: inputImageRowBytes)
       let thumbnailRowBytes = Int(size.width) * imageChannels
       guard  let thumbnailBytes = malloc(Int(size.height) * thumbnailRowBytes) else {
         return nil
       }
       
       //サムネイル画像にvImageバッファを割り当て
       var thumbnailVImageBuffer = vImage_Buffer(data: thumbnailBytes,
           height: UInt(size.height), width: UInt(size.width), rowBytes: thumbnailRowBytes)
       
       //入力画像バッファでスケール操作を実行し、サムネイル画像バッファに保存
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

       //サムネイルのvImageバッファをCVPixelBufferに変換
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

//Dataの拡張
extension Data {
   //float配列→byte配列(長さ4倍)
   init<T>(copyingBufferOf array: [T]) {
       self = array.withUnsafeBufferPointer(Data.init)
   }
}

//Arrayの拡張
extension Array {
   //byte配列→float配列（長さ1/4倍）
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
