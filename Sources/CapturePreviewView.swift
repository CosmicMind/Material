//
// Copyright (C) 2015 CosmicMind, Inc. <http://cosmicmind.io> and other CosmicMind contributors
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published
// by the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program located at the root of the software package
// in a file called LICENSE.  If not, see <http://www.gnu.org/licenses/>.
//

import UIKit
import AVFoundation

public class CapturePreviewView : MaterialView {
	/**
	:name:	layerClass
	*/
	public override class func layerClass() -> AnyClass {
		return AVCaptureVideoPreviewLayer.self
	}
	
	/**
	:name:	captureDevicePointOfInterestForPoint
	*/
	public func captureDevicePointOfInterestForPoint(point: CGPoint) -> CGPoint {
		return (layer as! AVCaptureVideoPreviewLayer).captureDevicePointOfInterestForPoint(point)
	}
	
	/**
	:name:	pointForCaptureDevicePointOfInterest
	*/
	public func pointForCaptureDevicePointOfInterest(point: CGPoint) -> CGPoint {
		return (layer as! AVCaptureVideoPreviewLayer).pointForCaptureDevicePointOfInterest(point)
	}
	
	/**
	:name:	prepareView
	*/
	public override func prepareView() {
		super.prepareView()
		preparePreviewLayer()
	}
	
	/**
	:name:	preparePreviewLayer
	*/
	private func preparePreviewLayer() {
		layer.backgroundColor = MaterialColor.black.CGColor
		layer.masksToBounds = true
		(layer as! AVCaptureVideoPreviewLayer).videoGravity = AVLayerVideoGravityResizeAspectFill
	}
}