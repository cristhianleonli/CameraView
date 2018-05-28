# CameraView

Plug and Play camera view

## Usage

```swift
import UIKit
import CameraView

class ViewController: UIViewController {
    
    var cameraView: CameraView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraView = CameraView(delegate: self, position: .front,
                                frame: CGRect(x: 50, y: 50, width: 100, height: 100))
        if let v = cameraView?.view {
            view.addSubview(v)
        }
    }
    
    @IBAction func openCamera(_ sender: Any) {
        cameraView?.start()
    }
}

extension ViewController: CameraViewDelegate {
    func onFrame(withCVImageBuffer buffer: CVPixelBuffer) {
        print(#line)
    }
    
    func onError(reason: CameraViewError) {
        print(reason)
    }
}
```
## Setting up with Carthage

Carthage is a decentralized dependency manager that automates the process of adding frameworks to your Cocoa application.

You can install Carthage with Homebrew using the following command:

```sh
$ brew update
$ brew install carthage
```

To integrate DateAgo into your Xcode project using Carthage, specify it in your Cartfile: `github "cristhianleonli/CameraView"`