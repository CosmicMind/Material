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

public extension UIImage {
	/**
		:name:	internalResize
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
		let t: CGRect = CGRectMake(0, 0, w ?? tw, h ?? th)
		UIGraphicsBeginImageContextWithOptions(t.size, false, MaterialDevice.scale)
		drawInRect(t, blendMode: .Normal, alpha: 1)
		g = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return g
	}
	
	/**
		:name:	resize
	*/
	public func resize(toWidth w: CGFloat) -> UIImage? {
		return internalResize(toWidth: w)
	}
	
	/**
		:name:	resize
	*/
	public func resize(toHeight h: CGFloat) -> UIImage? {
		return internalResize(toHeight: h)
	}
}
