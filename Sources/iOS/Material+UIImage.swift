/*
 * Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
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
 *	*	Neither the name of CosmicMind nor the names of its
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

@objc(ImageFormat)
public enum ImageFormat: Int {
	case png
	case jpeg
}

extension UIImage {
    /// Width of the UIImage.
    open var width: CGFloat {
        return size.width
    }
    
    /// Height of the UIImage.
    open var height: CGFloat {
        return size.height
    }
}

extension UIImage {
    /**
     Resizes an image based on a given width.
     - Parameter toWidth w: A width value.
     - Returns: An optional UIImage.
     */
    open func resize(toWidth w: CGFloat) -> UIImage? {
        return internalResize(toWidth: w)
    }
    
    /**
     Resizes an image based on a given height.
     - Parameter toHeight h: A height value.
     - Returns: An optional UIImage.
     */
    open func resize(toHeight h: CGFloat) -> UIImage? {
        return internalResize(toHeight: h)
    }
    
    /**
     Internally resizes the image.
     - Parameter toWidth tw: A width.
     - Parameter toHeight th: A height.
     - Returns: An optional UIImage.
     */
    private func internalResize(toWidth tw: CGFloat = 0, toHeight th: CGFloat = 0) -> UIImage? {
        var w: CGFloat?
        var h: CGFloat?
        
        if 0 < tw {
            h = height * tw / width
        } else if 0 < th {
            w = width * th / height
        }
        
        let g: UIImage?
        let t: CGRect = CGRect(x: 0, y: 0, width: w ?? tw, height: h ?? th)
        UIGraphicsBeginImageContextWithOptions(t.size, false, Screen.scale)
        draw(in: t, blendMode: .normal, alpha: 1)
        g = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return g
    }
}

extension UIImage {
    /**
     Creates a new image with the passed in color.
     - Parameter color: The UIColor to create the image from.
     - Returns: A UIImage that is the color passed in.
     */
    open func tint(with color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, Screen.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        context.scaleBy(x: 1.0, y: -1.0)
        context.translateBy(x: 0.0, y: -size.height)
        
        context.setBlendMode(.multiply)
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context.clip(to: rect, mask: cgImage!)
        color.setFill()
        context.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image?.withRenderingMode(.alwaysOriginal)
    }
}

extension UIImage {
    /**
     Creates an Image that is a color.
     - Parameter color: The UIColor to create the image from.
     - Parameter size: The size of the image to create.
     - Returns: A UIImage that is the color passed in.
     */
    open class func image(with color: UIColor, size: CGSize) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image?.withRenderingMode(.alwaysOriginal)
    }
}

extension UIImage {
    /**
     Crops an image to a specified width and height.
     - Parameter toWidth tw: A specified width.
     - Parameter toHeight th: A specified height.
     - Returns: An optional UIImage.
     */
    open func crop(toWidth tw: CGFloat, toHeight th: CGFloat) -> UIImage? {
        let g: UIImage?
        let b: Bool = width > height
        let s: CGFloat = b ? th / height : tw / width
        let t: CGSize = CGSize(width: tw, height: th)
        
        let w = width * s
        let h = height * s
        
        UIGraphicsBeginImageContext(t)
        draw(in: b ? CGRect(x: -1 * (w - t.width) / 2, y: 0, width: w, height: h) : CGRect(x: 0, y: -1 * (h - t.height) / 2, width: w, height: h), blendMode: .normal, alpha: 1)
        g = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return g
    }
}

extension UIImage {
    /**
     Creates an clear image.
     - Returns: A UIImage that is clear.
     */
    open class func clear(size: CGSize = CGSize(width: 16, height: 16)) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIImage {
    /**
     Asynchronously load images with a completion block.
     - Parameter URL: A URL destination to fetch the image from.
     - Parameter completion: A completion block that is executed once the image
     has been retrieved.
     */
    open class func contentsOfURL(url: URL, completion: @escaping ((UIImage?, Error?) -> Void)) {
        URLSession.shared.dataTask(with: URLRequest(url: url)) { [completion = completion] (data: Data?, response: URLResponse?, error: Error?) in
            DispatchQueue.main.async {
                if let v = error {
                    completion(nil, v)
                } else if let v = data {
                    completion(UIImage(data: v), nil)
                }
            }
        }.resume()
    }
}

extension UIImage {
    /**
     Adjusts the orientation of the image from the capture orientation.
     This is an issue when taking images, the capture orientation is not set correctly
     when using Portrait.
     - Returns: An optional UIImage if successful.
     */
    open func adjustOrientation() -> UIImage? {
        guard .up != imageOrientation else {
            return self
        }
        
        var transform: CGAffineTransform = .identity
        
        // Rotate if Left, Right, or Down.
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat(M_PI))
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat(M_PI_2))
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: -CGFloat(M_PI_2))
        default:break
        }
        
        // Flip if mirrored.
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:break
        }
        
        // Draw the underlying cgImage with the calculated transform.
        guard let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage!.bitsPerComponent, bytesPerRow: 0, space: cgImage!.colorSpace!, bitmapInfo: cgImage!.bitmapInfo.rawValue) else {
            return nil
        }
        
        context.concatenate(transform)
        
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            context.draw(cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            context.draw(cgImage!, in: CGRect(origin: .zero, size: size))
        }
        
        guard let cgImage = context.makeImage() else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
}

/**
 Creates an effect buffer for images that already have effects.
 - Parameter context: A CGContext.
 - Returns: vImage_Buffer.
 */
fileprivate func createEffectBuffer(context: CGContext) -> vImage_Buffer {
    let data = context.data
    let width = vImagePixelCount(context.width)
    let height = vImagePixelCount(context.height)
    let rowBytes = context.bytesPerRow
    return vImage_Buffer(data: data, height: height, width: width, rowBytes: rowBytes)
}

extension UIImage {
    /**
     Applies a blur effect to a UIImage.
     - Parameter radius: The radius of the blur effect.
     - Parameter tintColor: The color used for the blur effect (optional).
     - Parameter saturationDeltaFactor: The delta factor for the saturation of the blur effect.
     - Returns: a UIImage.
     */
    open func blur(radius: CGFloat = 0, tintColor: UIColor? = nil, saturationDeltaFactor: CGFloat = 0) -> UIImage? {
        var effectImage = self
        
        let screenScale = Screen.scale
        let imageRect = CGRect(origin: .zero, size: size)
        let hasBlur = radius > CGFloat(FLT_EPSILON)
        let hasSaturationChange = fabs(saturationDeltaFactor - 1.0) > CGFloat(FLT_EPSILON)
        
        if hasBlur || hasSaturationChange {
            UIGraphicsBeginImageContextWithOptions(size, false, screenScale)
            let inContext = UIGraphicsGetCurrentContext()!
            inContext.scaleBy(x: 1.0, y: -1.0)
            inContext.translateBy(x: 0, y: -size.height)
            
            inContext.draw(cgImage!, in: imageRect)
            
            var inBuffer = createEffectBuffer(context: inContext)
            
            UIGraphicsBeginImageContextWithOptions(size, false, screenScale)
            
            let outContext = UIGraphicsGetCurrentContext()!
            var outBuffer = createEffectBuffer(context: outContext)
            
            if hasBlur {
                let a = sqrt(2 * M_PI)
                let b = CGFloat(a) / 4
                let c = radius * screenScale
                let d = c * 3.0 * b

                var e = UInt32(floor(d + 0.5))
                
                if 1 != e % 2 {
                    e += 1 // force radius to be odd so that the three box-blur methodology works.
                }
                
                let imageEdgeExtendFlags = vImage_Flags(kvImageEdgeExtend)
                
                vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, nil, 0, 0, e, e, nil, imageEdgeExtendFlags)
                vImageBoxConvolve_ARGB8888(&outBuffer, &inBuffer, nil, 0, 0, e, e, nil, imageEdgeExtendFlags)
                vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, nil, 0, 0, e, e, nil, imageEdgeExtendFlags)
            }
            
            var effectImageBuffersAreSwapped = false
            
            if hasSaturationChange {
                let s = saturationDeltaFactor
                
                let floatingPointSaturationMatrix: [CGFloat] = [
                    0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                    0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                    0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                    0,                    0,                    0,                    1
                ]
                
                let divisor: CGFloat = 256
                let matrixSize = floatingPointSaturationMatrix.count
                var saturationMatrix = [Int16](repeating: 0, count: matrixSize)
                
                for i in 0..<matrixSize {
                    saturationMatrix[i] = Int16(round(floatingPointSaturationMatrix[i] * divisor))
                }
                
                if hasBlur {
                    vImageMatrixMultiply_ARGB8888(&outBuffer, &inBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
                    effectImageBuffersAreSwapped = true
                } else {
                    vImageMatrixMultiply_ARGB8888(&inBuffer, &outBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
                }
            }
            
            if !effectImageBuffersAreSwapped {
                effectImage = UIGraphicsGetImageFromCurrentImageContext()!
            }
            
            UIGraphicsEndImageContext()
            
            if effectImageBuffersAreSwapped {
                effectImage = UIGraphicsGetImageFromCurrentImageContext()!
            }
            
            UIGraphicsEndImageContext()
        }
        
        // Set up output context.
        UIGraphicsBeginImageContextWithOptions(size, false, screenScale)
        let outputContext = UIGraphicsGetCurrentContext()!
        outputContext.scaleBy(x: 1.0, y: -1.0)
        outputContext.translateBy(x: 0, y: -size.height)
        
        // Draw base image.
        outputContext.draw(cgImage!, in: imageRect)
        
        // Draw effect image.
        if hasBlur {
            outputContext.saveGState()
            outputContext.draw(effectImage.cgImage!, in: imageRect)
            outputContext.restoreGState()
        }
        
        // Add in color tint.
        if let v = tintColor {
            outputContext.saveGState()
            outputContext.setFillColor(v.cgColor)
            outputContext.fill(imageRect)
            outputContext.restoreGState()
        }
        
        // Output image is ready.
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return outputImage
    }
}
