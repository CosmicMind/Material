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

import Foundation

open class JSON: Equatable, CustomStringConvertible {
    /**
     :name:	description
     */
    open var description: String {
        return JSON.stringify(object) ?? "{}"
    }
    
    /**
     :name:	object
     */
    open private(set) var object: Any
    
    /**
     :name:	asArray
     */
    open var asArray: [Any]? {
        return object as? [Any]
    }
    
    /**
     :name:	asDictionary
     */
    open var asDictionary: [String: Any]? {
        return object as? [String: Any]
    }
    
    /**
     :name:	asString
     */
    open var asString: String? {
        return object as? String
    }
    
    /**
     :name:	asInt
     */
    open var asInt: Int? {
        return object as? Int
    }
    
    /**
     :name:	asDouble
     */
    open var asDouble: Double? {
        return object as? Double
    }
    
    /**
     :name:	asFloat
     */
    open var asFloat: Float? {
        return object as? Float
    }
    
    /**
     :name:	asBool
     */
    open var asBool: Bool? {
        return object as? Bool
    }
    
    /**
     :name:	asNSData
     */
    open var asNSData: Data? {
        return JSON.serialize(object: object)
    }
    
    /**
     :name:	parse
     */
    open class func parse(_ data: Data, options: JSONSerialization.ReadingOptions = .allowFragments) -> JSON? {
        if let object = try? JSONSerialization.jsonObject(with: data, options: options) {
            return JSON(object)
        }
        return nil
    }
    
    /**
     :name:	parse
     */
    open class func parse(_ json: String) -> JSON? {
        guard let data = json.data(using: String.Encoding.utf8) else {
            return nil
        }
        return parse(data)
    }
    
    /**
     :name:	serialize
     */
    open class func serialize(object: Any) -> Data? {
        return try? JSONSerialization.data(withJSONObject: object, options: [])
    }
    
    /**
     :name:	stringify
     */
    open class func stringify(_ object: Any) -> String? {
        if let o = object as? JSON {
            return stringify(o.object)
        } else if let data = JSON.serialize(object: object) {
            if let o = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as? String {
                return o
            }
        }
        return nil
    }
    
    /**
     :name:	init
     */
    public required init(_ object: Any) {
        if let o = object as? JSON {
            self.object = o.object
        } else {
            self.object = object
        }
    }
    
    /**
     :name:	operator [0...count - 1]
     */
    open subscript(index: Int) -> JSON? {
        if let item = asArray {
            return JSON(item[index])
        }
        return nil
    }
    
    /**
     :name:	operator [key 1...key n]
     */
    open subscript(key: String) -> JSON? {
        if let item = asDictionary {
            if nil != item[key] {
                return JSON(item[key]!)
            }
        }
        return nil
    }
}

public func ==(lhs: JSON, rhs: JSON) -> Bool {
    return JSON.stringify(lhs.object) == JSON.stringify(rhs.object)
}
