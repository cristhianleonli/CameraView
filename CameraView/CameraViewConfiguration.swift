//
//  CameraViewConfiguration.swift
//  CameraView
//
//  Created by Cristhian Leon on 26.03.19.
//  Copyright © 2019 Cristhian León. All rights reserved.
//

import UIKit

public struct CameraViewConfiguration {
    
    public var frame: CGRect = .zero
    
    public var cameraPosition: CameraViewPosition = .back
    
    public init(frame: CGRect, cameraPosition: CameraViewPosition) {
        self.frame = frame
        self.cameraPosition = cameraPosition
    }
    
    public init() {
        self.init(frame: .zero, cameraPosition: .back)
    }
}
