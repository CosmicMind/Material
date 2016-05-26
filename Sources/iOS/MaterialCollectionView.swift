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

@IBDesignable
public class MaterialCollectionView : UICollectionView {
	/// A property that accesses the layer.frame.origin.x property.
	@IBInspectable public var x: CGFloat {
		get {
			return layer.frame.origin.x
		}
		set(value) {
			layer.frame.origin.x = value
		}
	}
	
	/// A property that accesses the layer.frame.origin.y property.
	@IBInspectable public var y: CGFloat {
		get {
			return layer.frame.origin.y
		}
		set(value) {
			layer.frame.origin.y = value
		}
	}
	
	/// A property that accesses the layer.frame.size.width property.
	@IBInspectable public var width: CGFloat {
		get {
			return layer.frame.size.width
		}
		set(value) {
			layer.frame.size.width = value
		}
	}
	
	/// A property that accesses the layer.frame.size.height property.
	@IBInspectable public var height: CGFloat {
		get {
			return layer.frame.size.height
		}
		set(value) {
			layer.frame.size.height = value
		}
	}
	
	/// A preset wrapper around contentInset.
	public var contentInsetPreset: MaterialEdgeInset {
		get {
			return (collectionViewLayout as? MaterialCollectionViewLayout)!.contentInsetPreset
		}
		set(value) {
			(collectionViewLayout as? MaterialCollectionViewLayout)!.contentInsetPreset = value
		}
	}
	
	public override var contentInset: UIEdgeInsets {
		get {
			return (collectionViewLayout as? MaterialCollectionViewLayout)!.contentInset
		}
		set(value) {
			(collectionViewLayout as? MaterialCollectionViewLayout)!.contentInset = value
		}
	}
	
	/// Scroll direction.
	public var scrollDirection: UICollectionViewScrollDirection {
		get {
			return (collectionViewLayout as? MaterialCollectionViewLayout)!.scrollDirection
		}
		set(value) {
			(collectionViewLayout as? MaterialCollectionViewLayout)!.scrollDirection = value
		}
	}
	
	/// A preset wrapper around spacing.
	public var spacingPreset: MaterialSpacing = .None {
		didSet {
			spacing = MaterialSpacingToValue(spacingPreset)
		}
	}
	
	/// Spacing between items.
	@IBInspectable public var spacing: CGFloat {
		get {
			return (collectionViewLayout as? MaterialCollectionViewLayout)!.spacing
		}
		set(value) {
			(collectionViewLayout as? MaterialCollectionViewLayout)!.spacing = value
		}
	}
	
	/**
	An initializer that initializes the object with a NSCoder object.
	- Parameter aDecoder: A NSCoder instance.
	*/
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	/**
	An initializer that initializes the object.
	- Parameter frame: A CGRect defining the view's frame.
	- Parameter collectionViewLayout: A UICollectionViewLayout reference.
	*/
	public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
		super.init(frame: frame, collectionViewLayout: layout)
		prepareView()
	}
	
	/**
	An initializer that initializes the object.
	- Parameter frame: A CGRect defining the view's frame.
	*/
	public init(frame: CGRect) {
		super.init(frame: frame, collectionViewLayout: MaterialCollectionViewLayout())
		prepareView()
	}
	
	/// A convenience initializer that initializes the object.
	public convenience init() {
		self.init(frame: CGRectZero)
	}
	
	/**
	Prepares the view instance when intialized. When subclassing,
	it is recommended to override the prepareView method
	to initialize property values and other setup operations.
	The super.prepareView method should always be called immediately
	when subclassing.
	*/
	public func prepareView() {
		contentScaleFactor = MaterialDevice.scale
		backgroundColor = MaterialColor.clear
		contentInset = UIEdgeInsetsZero
	}
}