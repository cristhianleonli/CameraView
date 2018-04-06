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
    
    private var cameraPosition: CameraViewPosition = .back
    
    private var frame: CGRect = .zero
    
    public init(delegate: CameraViewDelegate,
                position: CameraViewPosition,
                frame: CGRect) {
        super.init()
        self.delegate = delegate
        self.cameraPosition = position
        self.frame = frame
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
        
        view.frame = frame
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = frame
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
