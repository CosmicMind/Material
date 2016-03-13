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

/**
Gets the Obj-C reference for the Grid object within the UIView extension.
- Parameter base: Base object.
- Parameter key: Memory key pointer.
- Parameter initializer: Object initializer.
- Returns: The associated reference for the initializer object.
*/
public func MaterialAssociatedObject<T: AnyObject>(base: AnyObject, key: UnsafePointer<UInt8>, initializer: () -> T) -> T {
	if let v: T = objc_getAssociatedObject(base, key) as? T {
		return v
	}
	
	let v: T = initializer()
	objc_setAssociatedObject(base, key, v, .OBJC_ASSOCIATION_RETAIN)
	return v
}

/**
Sets the Obj-C reference for the Grid object within the UIView extension.
- Parameter base: Base object.
- Parameter key: Memory key pointer.
- Parameter value: The object instance to set for the associated object.
- Returns: The associated reference for the initializer object.
*/
public func MaterialAssociateObject<T: AnyObject>(base: AnyObject, key: UnsafePointer<UInt8>, value: T) {
	objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_RETAIN)
}