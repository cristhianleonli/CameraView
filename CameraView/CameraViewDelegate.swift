//
//  CameraViewDelegate.swift
//  CameraView
//
//  Created by Cristhian León on 5/10/18.
//  Copyright © 2018 Cristhian León. All rights reserved.
//

import AVFoundation

public protocol CameraViewDelegate: class {
    /// called at every frame that occurs in the captureOutput
    func onFrame(buffer: CVPixelBuffer)
    
    /// called when any error happen while creating cameraView
    func onError(reason: CameraViewError)
    
    /// called when finished correctly the resources configuration
    func didFinishConfiguration()
}
