/*
* Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>.
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*
*	*	Redistributions of source code must retain the above copyright notice, this
*		list of conditions and the following disclaimer.
*
*	*	Redistributions in binary form must reproduce the above copyright notice,
*		this list of conditions and the following disclaimer in the documentation
*		and/or other materials provided with the distribution.
*
*	*	Neither the name of Material nor the names of its
*		contributors may be used to endorse or promote products derived from
*		this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
* FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
* DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
* CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
* OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
* OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import UIKit
import Accelerate

/// Creates an effect buffer for images that are already effected.
private func createEffectBuffer(context: CGContext) -> vImage_Buffer {
	let data = CGBitmapContextGetData(context)
	let width = vImagePixelCount(CGBitmapContextGetWidth(context))
	let height = vImagePixelCount(CGBitmapContextGetHeight(context))
	let rowBytes = CGBitmapContextGetBytesPerRow(context)
	return vImage_Buffer(data: data, height: height, width: width, rowBytes: rowBytes)
}

public extension UIImage {
	/**
	Applies a blur effect to a UIImage.
	- Parameter blurRadius: The radius of the blur effect.
	- Parameter tintColor: The color used for the blur effect (optional).
	- Parameter saturationDeltaFactor: The delta factor for the saturation of the blur effect.
	- Returns: a UIImage.
	*/
	func filterBlur(blurRadius: CGFloat = 0, tintColor: UIColor? = nil, saturationDeltaFactor: CGFloat = 0) -> UIImage? {
		var effectImage: UIImage = self
		
		let screenScale: CGFloat = MaterialDevice.scale
		let imageRect: CGRect = CGRect(origin: CGPoint.zero, size: size)
		let hasBlur: Bool = blurRadius > CGFloat(FLT_EPSILON)
		let hasSaturationChange: Bool = fabs(saturationDeltaFactor - 1.0) > CGFloat(FLT_EPSILON)
		
		if hasBlur || hasSaturationChange {
			UIGraphicsBeginImageContextWithOptions(size, false, screenScale)
			let effectInContext: CGContext = UIGraphicsGetCurrentContext()!
			CGContextScaleCTM(effectInContext, 1.0, -1.0)
			CGContextTranslateCTM(effectInContext, 0, -size.height)
			CGContextDrawImage(effectInContext, imageRect, self.CGImage)
			var effectInBuffer: vImage_Buffer = createEffectBuffer(effectInContext)
			
			UIGraphicsBeginImageContextWithOptions(size, false, screenScale)
			let effectOutContext: CGContext = UIGraphicsGetCurrentContext()!
			var effectOutBuffer: vImage_Buffer = createEffectBuffer(effectOutContext)
			
			if hasBlur {
				let inputRadius: CGFloat = blurRadius * screenScale
				var radius: UInt32 = UInt32(floor(inputRadius * 3.0 * CGFloat(sqrt(2 * M_PI)) / 4 + 0.5))
				if 1 != radius % 2 {
					radius += 1 // force radius to be odd so that the three box-blur methodology works.
				}
				
				let imageEdgeExtendFlags: UInt32 = vImage_Flags(kvImageEdgeExtend)
				
				vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
				vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
				vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
			}
			
			var effectImageBuffersAreSwapped: Bool = false
			
			if hasSaturationChange {
				let s: CGFloat = saturationDeltaFactor
				let floatingPointSaturationMatrix: Array<CGFloat> = [
					0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
					0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
					0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
					0,                    0,                    0,                    1
				]
				
				let divisor: CGFloat = 256
				let matrixSize: Int = floatingPointSaturationMatrix.count
				var saturationMatrix: Array<Int16> = Array<Int16>(count: matrixSize, repeatedValue: 0)
				
				for i: Int in 0 ..< matrixSize {
					saturationMatrix[i] = Int16(round(floatingPointSaturationMatrix[i] * divisor))
				}
				
				if hasBlur {
					vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
					effectImageBuffersAreSwapped = true
				} else {
					vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
				}
			}
			
			if !effectImageBuffersAreSwapped {
				effectImage = UIGraphicsGetImageFromCurrentImageContext()
			}
			
			UIGraphicsEndImageContext()
			
			if effectImageBuffersAreSwapped {
				effectImage = UIGraphicsGetImageFromCurrentImageContext()
			}
			
			UIGraphicsEndImageContext()
		}
		
		// Set up output context.
		UIGraphicsBeginImageContextWithOptions(size, false, screenScale)
		let outputContext: CGContext = UIGraphicsGetCurrentContext()!
		CGContextScaleCTM(outputContext, 1.0, -1.0)
		CGContextTranslateCTM(outputContext, 0, -size.height)
		
		// Draw base image.
		CGContextDrawImage(outputContext, imageRect, self.CGImage)
		
		// Draw effect image.
		if hasBlur {
			CGContextSaveGState(outputContext)
			CGContextDrawImage(outputContext, imageRect, effectImage.CGImage)
			CGContextRestoreGState(outputContext)
		}
		
		// Add in color tint.
		if let v: UIColor = tintColor {
			CGContextSaveGState(outputContext)
			CGContextSetFillColorWithColor(outputContext, v.CGColor)
			CGContextFillRect(outputContext, imageRect)
			CGContextRestoreGState(outputContext)
		}
		
		// Output image is ready.
		let outputImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return outputImage
	}
}
