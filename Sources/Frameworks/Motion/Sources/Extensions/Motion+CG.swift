/*
 * The MIT License (MIT)
 *
 * Copyright (C) 2017, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
 * All rights reserved.
 *
 * Original Inspiration & Author
 * Copyright (c) 2016 Luke Zhao <me@lkzhao.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import MetalKit

public extension CGSize {
    /// THe center point based on width and height.
    var center: CGPoint {
        return CGPoint(x: width / 2, y: height / 2)
    }
    
    /// Top left point based on the size.
    var topLeft: CGPoint {
        return .zero
    }
    
    /// Top right point based on the size.
    var topRight: CGPoint {
        return CGPoint(x: width, y: 0)
    }
    
    /// Bottom left point based on the size.
    var bottomLeftPoint: CGPoint {
        return CGPoint(x: 0, y: height)
    }
    
    /// Bottom right point based on the size.
    var bottomRight: CGPoint {
        return CGPoint(x: width, y: height)
    }
    
    /**
     Retrieves the size based on a given CGAffineTransform.
     - Parameter _ t: A CGAffineTransform.
     - Returns: A CGSize.
     */
    func transform(_ t: CGAffineTransform) -> CGSize {
        return applying(t)
    }
    
    /**
     Retrieves the size based on a given CATransform3D.
     - Parameter _ t: A CGAffineTransform.
     - Returns: A CGSize.
     */
    func transform(_ t: CATransform3D) -> CGSize {
        return applying(CATransform3DGetAffineTransform(t))
    }
}

public extension CGRect {
    /// A center point based on the origin and size values.
    var center: CGPoint {
        return CGPoint(x: origin.x + size.width / 2, y: origin.y + size.height / 2)
    }
    
    /// The bounding box size based from from the frame's rect.
    var bounds: CGRect {
        return CGRect(origin: .zero, size: size)
    }
    
    /**
     An initializer with a given point and size.
     - Parameter center: A CGPoint.
     - Parameter size: A CGSize.
     */
    init(center: CGPoint, size: CGSize) {
        self.init(x: center.x - size.width / 2, y: center.y - size.height / 2, width: size.width, height: size.height)
    }
}

public extension CGFloat {
    /**
     Calculates the limiting position to an area.
     - Parameter _ a: A CGFloat.
     - Parameter _ b: A CGFloat.
     - Returns: A CGFloat.
     */
    func clamp(_ a: CGFloat, _ b: CGFloat) -> CGFloat {
        return self < a ? a : self > b ? b : self
    }
}

public extension CGPoint {
    /**
     Calculates a translation point based on the origin value.
     - Parameter _ dx: A CGFloat.
     - Parameter _ dy: A CGFloat.
     - Returns: A CGPoint.
     */
    func translate(_ dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x + dx, y: y + dy)
    }
    
    /**
     Calculates a transform point based on a given CGAffineTransform.
     - Parameter _ t: CGAffineTransform.
     - Returns: A CGPoint.
     */
    func transform(_ t: CGAffineTransform) -> CGPoint {
        return applying(t)
    }
    
    /**
     Calculates a transform point based on a given CATransform3D.
     - Parameter _ t: CATransform3D.
     - Returns: A CGPoint.
     */
    func transform(_ t: CATransform3D) -> CGPoint {
        return applying(CATransform3DGetAffineTransform(t))
    }
    
    /**
     Calculates the distance between the CGPoint and given CGPoint.
     - Parameter _ b: A CGPoint.
     - Returns: A CGFloat.
     */
    func distance(_ b: CGPoint) -> CGFloat {
        return sqrt(pow(x - b.x, 2) + pow(y - b.y, 2))
    }
}

/**
 A handler for the (+) operator.
 - Parameter left: A CGPoint.
 - Parameter right: A CGPoint.
 - Returns: A CGPoint.
 */
public func +(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

/**
 A handler for the (-) operator.
 - Parameter left: A CGPoint.
 - Parameter right: A CGPoint.
 - Returns: A CGPoint.
 */
public func -(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

/**
 A handler for the (/) operator.
 - Parameter left: A CGPoint.
 - Parameter right: A CGFloat.
 - Returns: A CGPoint.
 */
public func /(left: CGPoint, right: CGFloat) -> CGPoint {
    return CGPoint(x: left.x / right, y: left.y / right)
}

/**
 A handler for the (/) operator.
 - Parameter left: A CGPoint.
 - Parameter right: A CGPoint.
 - Returns: A CGPoint.
 */
public func /(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x / right.x, y: left.y / right.y)
}

/**
 A handler for the (/) operator.
 - Parameter left: A CGSize.
 - Parameter right: A CGSize.
 - Returns: A CGSize.
 */
public func /(left: CGSize, right: CGSize) -> CGSize {
    return CGSize(width: left.width / right.width, height: left.height / right.height)
}

/**
 A handler for the (*) operator.
 - Parameter left: A CGPoint.
 - Parameter right: A CGFloat.
 - Returns: A CGPoint.
 */
public func *(left: CGPoint, right: CGFloat) -> CGPoint {
    return CGPoint(x: left.x * right, y: left.y * right)
}

/**
 A handler for the (*) operator.
 - Parameter left: A CGPoint.
 - Parameter right: A CGSize.
 - Returns: A CGPoint.
 */
public func *(left: CGPoint, right: CGSize) -> CGPoint {
    return CGPoint(x: left.x * right.width, y: left.y * right.width)
}

/**
 A handler for the (*) operator.
 - Parameter left: A CGFloat.
 - Parameter right: A CGPoint.
 - Returns: A CGPoint.
 */
public func *(left: CGFloat, right: CGPoint) -> CGPoint {
    return right * left
}

/**
 A handler for the (*) operator.
 - Parameter left: A CGPoint.
 - Parameter right: A CGPoint.
 - Returns: A CGPoint.
 */
public func *(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x * right.x, y: left.y * right.y)
}

/**
 A handler for the (*) prefix.
 - Parameter left: A CGSize.
 - Parameter right: A CGFloat.
 - Returns: A CGSize.
 */
public func *(left: CGSize, right: CGFloat) -> CGSize {
    return CGSize(width: left.width * right, height: left.height * right)
}

/**
 A handler for the (*) prefix.
 - Parameter left: A CGSize.
 - Parameter right: A CGSize.
 - Returns: A CGSize.
 */
public func *(left: CGSize, right: CGSize) -> CGSize {
    return CGSize(width: left.width * right.width, height: left.height * right.width)
}

/**
 A handler for the (==) operator.
 - Parameter lhs: A CATransform3D.
 - Parameter rhs: A CATransform3D.
 - Returns: A Bool.
 */
public func ==(lhs: CATransform3D, rhs: CATransform3D) -> Bool {
    var lhs = lhs
    var rhs = rhs
    return 0 == memcmp(&lhs, &rhs, MemoryLayout<CATransform3D>.size)
}

/**
 A handler for the (!=) operator.
 - Parameter lhs: A CATransform3D.
 - Parameter rhs: A CATransform3D.
 - Returns: A Bool.
 */
public func !=(lhs: CATransform3D, rhs: CATransform3D) -> Bool {
    return !(lhs == rhs)
}

/**
 A handler for the (-) prefix.
 - Parameter point: A CGPoint.
 - Returns: A CGPoint.
 */
public prefix func -(point: CGPoint) -> CGPoint {
    return CGPoint.zero - point
}

/**
 A handler for the (abs) function.
 - Parameter _ p: A CGPoint.
 - Returns: A CGPoint.
 */
public func abs(_ p: CGPoint) -> CGPoint {
    return CGPoint(x: abs(p.x), y: abs(p.y))
}
