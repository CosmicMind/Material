/*
 * The MIT License (MIT)
 *
 * Copyright (C) 2017, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
 * All rights reserved.
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

public struct AssociatedObject {
    /**
     Gets the Obj-C reference for the instance object within the UIView extension.
     - Parameter base: Base object.
     - Parameter key: Memory key pointer.
     - Parameter initializer: Object initializer.
     - Returns: The associated reference for the initializer object.
     */
    public static func get<T: Any>(base: Any, key: UnsafePointer<UInt8>, initializer: () -> T) -> T {
        if let v = objc_getAssociatedObject(base, key) as? T {
            return v
        }
        
        let v = initializer()
        objc_setAssociatedObject(base, key, v, .OBJC_ASSOCIATION_RETAIN)
        return v
    }
    
    /**
     Sets the Obj-C reference for the instance object within the UIView extension.
     - Parameter base: Base object.
     - Parameter key: Memory key pointer.
     - Parameter value: The object instance to set for the associated object.
     - Returns: The associated reference for the initializer object.
     */
    public static func set<T: Any>(base: Any, key: UnsafePointer<UInt8>, value: T) {
        objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_RETAIN)
    }
}
