//
// Copyright (C) 2015 GraphKit, Inc. <http://graphkit.io> and other GraphKit contributors.
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
		:name:	previewLayer
	*/
	public private(set) lazy var previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer()
	
	/**
		:name:	capture
	*/
	public private(set) lazy var captureSession: CaptureSession = CaptureSession()
	
	/**
		:name:	layoutSublayersOfLayer
	*/
	public override func layoutSublayersOfLayer(layer: CALayer) {
		super.layoutSublayersOfLayer(layer)
		if self.layer == layer {
			layoutPreviewLayer()
		}
	}
	
	/**
		:name:	prepareView
	*/
	public override func prepareView() {
		super.prepareView()
		preparePreviewLayer()
	}
	
	/**
		:name:	captureDevicePointOfInterestForPoint
	*/
	public func captureDevicePointOfInterestForPoint(point: CGPoint) -> CGPoint {
		return previewLayer.captureDevicePointOfInterestForPoint(point)
	}
	
	/**
		:name:	pointForCaptureDevicePointOfInterest
	*/
	public func pointForCaptureDevicePointOfInterest(point: CGPoint) -> CGPoint {
		return previewLayer.pointForCaptureDevicePointOfInterest(point)
	}
	
	//
	//	:name:	preparePreviewLayer
	//
	private func preparePreviewLayer() {
		previewLayer.session = captureSession.session
		visualLayer.addSublayer(previewLayer)
	}
	
	//
	//	:name:	layoutPreviewLayer
	//
	internal func layoutPreviewLayer() {
		previewLayer.frame = visualLayer.bounds
		previewLayer.position = CGPointMake(width / 2, height / 2)
		previewLayer.cornerRadius = visualLayer.cornerRadius
	}
}