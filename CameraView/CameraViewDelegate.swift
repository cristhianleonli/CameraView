//
//  CameraViewDelegate.swift
//  CameraView
//
//  Created by Cristhian León on 5/10/18.
//  Copyright © 2018 Cristhian León. All rights reserved.
//

public protocol CameraViewDelegate {
    func onFrame(withCVImageBuffer buffer: CVPixelBuffer)
}
