//
//  CameraView.swift
//  CameraView
//
//  Created by Cristhian León on 5/10/18.
//  Copyright © 2018 Cristhian León. All rights reserved.
//

import Foundation
import AVFoundation

public class CameraView: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    /// the view that contains the camera video
    public let view = UIView()
    
    private weak var delegate: CameraViewDelegate?
    
    private var videoDataOutput: AVCaptureVideoDataOutput?
    
    private let videoDataOutputQueue = DispatchQueue(label: "VideoDataOutputQueue")
    
    private var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    private var captureSession: AVCaptureSession = AVCaptureSession()
    
    /// Physical position of camera
    public var cameraPosition: CameraViewPosition = .back
    
    public init(delegate: CameraViewDelegate) {
        super.init()
        self.delegate = delegate
        captureSetup()
    }
    
    /// Starts recording the camera
    public func start() {
        captureSession.startRunning()
    }
    
    /// stops recordig the camera
    public func stop() {
        captureSession.stopRunning()
    }
    
    private func captureSetup () {
        let position = (cameraPosition == .front) ? AVCaptureDevice.Position.front : AVCaptureDevice.Position.back
        let captureDevice: AVCaptureDevice? = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position)
        var deviceInput: AVCaptureDeviceInput?
        
        do {
            if let device = captureDevice {
                deviceInput = try AVCaptureDeviceInput(device: device)
            }
        } catch {
            delegate?.onError(reason: .captureDevice)
            return
        }
        
        captureSession.sessionPreset = AVCaptureSession.Preset.high
        
        videoDataOutput = AVCaptureVideoDataOutput()
        videoDataOutput?.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        videoDataOutput?.alwaysDiscardsLateVideoFrames = true
        videoDataOutput?.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        
        guard let input = deviceInput,
            let output = videoDataOutput,
            captureSession.canAddInput(input),
            captureSession.canAddOutput(output) else {
                delegate?.onError(reason: .inputOutput)
                return
        }
        
        captureSession.addInput(input)
        captureSession.addOutput(output)
        
        view.frame = UIScreen.main.bounds
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = UIScreen.main.bounds
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        view.layer.addSublayer(previewLayer)
    }
    
    internal func captureOutput(_ output: AVCaptureOutput!,
                       didOutputSampleBuffer sampleBuffer: CMSampleBuffer!,
                       from connection: AVCaptureConnection!) {
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        delegate?.onFrame(withCVImageBuffer: pixelBuffer)
    }
}
