//
//  CameraView.swift
//  CameraView
//
//  Created by Cristhian León on 5/10/18.
//  Copyright © 2018 Cristhian León. All rights reserved.
//

import UIKit
import AVFoundation

public class CameraView: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    // MARK: Private properties
    
    private let view: UIView = UIView()
    
    private var videoDataOutput: AVCaptureVideoDataOutput?
    
    private let videoDataOutputQueue = DispatchQueue(label: "VideoDataOutputQueue")
    
    private var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    private var captureSession: AVCaptureSession = AVCaptureSession()
    
    // MARK: Public properties
    
    public var configuration = CameraViewConfiguration()
    
    public weak var delegate: CameraViewDelegate? = nil
    
    public override init() {
    }
}

public extension CameraView {
    /// Read-only view that contains the preview layer
    var cameraContainer: UIView {
        return view
    }
    
    /// Starts recording the camera
    func start() {
        setupIfNeeded()
        captureSession.startRunning()
    }
    
    /// stops recordig the camera
    func stop() {
        captureSession.stopRunning()
    }
    
    /// Not call directly, only called by the buffer delegate
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            delegate?.onError(reason: .pixelBuffer)
            return
        }
        
        delegate?.onFrame(buffer: pixelBuffer)
    }
}

private extension CameraView {
    func setupIfNeeded() {
        let configurationError = inputOutputSetup()
        
        if configurationError != nil {
            delegate?.onError(reason: configurationError!)
            return
        }
        
        setupLayer()
        delegate?.didFinishConfiguration()
    }
    
    func inputOutputSetup() -> CameraViewError? {
        captureSession.stopRunning()
        captureSession = AVCaptureSession()
        
        let position = configuration.cameraPosition.asCaptureDevice
        let captureDevice: AVCaptureDevice? = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position)
        var deviceInput: AVCaptureDeviceInput?
        
        do {
            if let device = captureDevice {
                deviceInput = try AVCaptureDeviceInput(device: device)
            }
        } catch {
            return .captureDevice
        }
        
        captureSession.sessionPreset = AVCaptureSession.Preset.high
        
        videoDataOutput = AVCaptureVideoDataOutput()
        videoDataOutput?.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        videoDataOutput?.alwaysDiscardsLateVideoFrames = true
        videoDataOutput?.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        
        guard
            let input = deviceInput,
            captureSession.canAddInput(input) else {
                return .inputSession
        }
        
        guard
            let output = videoDataOutput,
            captureSession.canAddOutput(output) else {
                return .outputSession
        }
        
        captureSession.addInput(input)
        captureSession.addOutput(output)
        
        return nil
    }
    
    func setupLayer() {
        let rect = configuration.frame
        assert(rect != .zero, "ERROR: frame is zero, configuration needed")
        
        view.frame = rect
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        for layer in (view.layer.sublayers ?? []) {
            layer.removeFromSuperlayer()
        }
        
        view.layer.addSublayer(previewLayer)
    }
}
