//
//  CameraViewDelegate.swift
//  CameraView
//
//  Created by Cristhian León on 5/10/18.
//  Copyright © 2018 Cristhian León. All rights reserved.
//

public protocol CameraViewDelegate {
    /// called at every frame that occurs in the captureOutput
    func onFrame(withCVImageBuffer buffer: CVPixelBuffer)
    
    /// called when any error happen while creating cameraView
    func onError(reason: CameraViewError)
}
