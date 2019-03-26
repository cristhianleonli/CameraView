//
//  CameraViewError.swift
//  CameraView
//
//  Created by Cristhian León on 5/11/18.
//  Copyright © 2018 Cristhian León. All rights reserved.
//

public enum CameraViewError {
    /// input cannot be added to session
    case inputSession
    
    /// output cannot be added to session
    case outputSession
    
    /// captureDeviceInput can not be created
    case captureDevice
    
    /// pixel buffer cannot be created from sample
    case pixelBuffer
}
