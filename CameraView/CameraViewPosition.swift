//
//  CameraViewPosition.swift
//  CameraView
//
//  Created by Cristhian León on 5/11/18.
//  Copyright © 2018 Cristhian León. All rights reserved.
//

import AVFoundation

public enum CameraViewPosition {
    /// the camera in front of device
    case front
    
    /// the camera in the back of device
    case back
    
    var asCaptureDevice: AVCaptureDevice.Position {
        switch self {
        case .front:
            return .front
        case .back:
            return .back
        }
    }
}
