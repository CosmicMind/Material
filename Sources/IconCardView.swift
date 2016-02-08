//
//  IconCardView.swift
//  Material
//
//  Created by Anne Cahalan on 2/8/16.
//  Copyright © 2016 CosmicMind, Inc. All rights reserved.
//

import UIKit

public class IconCardView : MaterialPulseView {
    /**
     :name:	dividerLayer
     */
    internal var dividerLayer: CAShapeLayer?
    
    /**
     :name:	dividerColor
     */
    public var dividerColor: UIColor? {
        didSet {
            dividerLayer?.backgroundColor = dividerColor?.CGColor
        }
    }
    
    /**
     :name:	divider
     */
    public var divider: Bool = true {
        didSet {
            reloadView()
        }
    }
    
    /**
     :name:	dividerInsets
     */
    public var dividerInsetPreset: MaterialEdgeInsetPreset = .None {
        didSet {
            dividerInset = MaterialEdgeInsetPresetToValue(dividerInsetPreset)
        }
    }
    
    /**
     :name:	dividerInset
     */
    public var dividerInset: UIEdgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0) {
        didSet {
            reloadView()
        }
    }
    
    /**
     :name:	contentInsets
     */
    public var contentInsetPreset: MaterialEdgeInsetPreset = .None {
        didSet {
            contentInset = MaterialEdgeInsetPresetToValue(contentInsetPreset)
        }
    }
    
    /**
     :name:	contentInset
     */
    public var contentInset: UIEdgeInsets = MaterialEdgeInsetPresetToValue(.Square2) {
        didSet {
            reloadView()
        }
    }
    
    /**
     :name:	titleLabelInsets
     */
    public var titleLabelInsetPreset: MaterialEdgeInsetPreset = .None {
        didSet {
            titleLabelInset = MaterialEdgeInsetPresetToValue(titleLabelInsetPreset)
        }
    }
    
    /**
     :name:	titleLabelInset
     */
    public var titleLabelInset: UIEdgeInsets = MaterialEdgeInsetPresetToValue(.Square2) {
        didSet {
            reloadView()
        }
    }
    
    /**
     :name:	titleLabel
     */
    public var titleLabel: UILabel? {
        didSet {
            titleLabel?.translatesAutoresizingMaskIntoConstraints = false
            reloadView()
        }
    }
    
    /**
     :name:	detailLabelInsets
     */
    public var detailLabelInsetPreset: MaterialEdgeInsetPreset = .None {
        didSet {
            detailLabelInset = MaterialEdgeInsetPresetToValue(detailLabelInsetPreset)
        }
    }
    
    /**
     :name:	detailLabelInset
     */
    public var detailLabelInset: UIEdgeInsets = MaterialEdgeInsetPresetToValue(.Square2) {
        didSet {
            reloadView()
        }
    }
    
    /**
     :name:	detailLabel
     */
    public var detailLabel: UILabel? {
        didSet {
            detailLabel?.translatesAutoresizingMaskIntoConstraints = false
            reloadView()
        }
    }
   
    /**
     :name: leftImages
     */
    public var leftImages: Array<UIImageView>? {
        didSet {
            if let v = leftImages {
                for i in v {
                    i.translatesAutoresizingMaskIntoConstraints = false
                }
            }
            reloadView()
        }
    }
     
     /**
     :name:	leftImagesInsets
     */
    public var leftImagesInsetPreset: MaterialEdgeInsetPreset = .None {
        didSet {
            leftImagesInset = MaterialEdgeInsetPresetToValue(leftImagesInsetPreset)
        }
    }

     /**
     :name:	leftImagesInset
     */
    public var leftImagesInset: UIEdgeInsets = MaterialEdgeInsetPresetToValue(.None) {
        didSet {
            reloadView()
        }
    }
    
    /**
     :name: rightImages
     */
    public var rightImages: Array<UIImageView>? {
        didSet {
            if let v = rightImages {
                for i in v {
                    i.translatesAutoresizingMaskIntoConstraints = false
                }
            }
            reloadView()
        }
    }
    
    /**
     :name:	rightImagesInsets
     */
    public var rightImagesInsetPreset: MaterialEdgeInsetPreset = .None {
        didSet {
            rightImagesInset = MaterialEdgeInsetPresetToValue(rightImagesInsetPreset)
        }
    }
    
    /**
     :name:	rightImagesInset
     */
    public var rightImagesInset: UIEdgeInsets = MaterialEdgeInsetPresetToValue(.None) {
        didSet {
            reloadView()
        }
    }
    
    /**
     :name:	init
     */
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /**
     :name:	init
     */
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    /**
     :name:	init
     */
    public convenience init() {
        self.init(frame: CGRectNull)
    }
    
    /**
     :name:	init
     */
    public convenience init?(image: UIImage? = nil, titleLabel: UILabel? = nil, detailLabel: UILabel? = nil, leftButtons: Array<UIButton>? = nil, rightButtons: Array<UIButton>? = nil) {
        self.init(frame: CGRectNull)
        prepareProperties(image, titleLabel: titleLabel, detailLabel: detailLabel, rightImages: rightImages)
    }
    
    /**
     :name:	reloadView
     */
    public func reloadView() {
        // clear constraints so new ones do not conflict
        removeConstraints(constraints)
        for v in subviews {
            v.removeFromSuperview()
        }
        
        var verticalFormat: String = "V:|"
        var views: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        var metrics: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        
        if nil != titleLabel {
            verticalFormat += "-(insetTop)"
            metrics["insetTop"] = contentInset.top + titleLabelInset.top
        } else if nil != detailLabel {
            verticalFormat += "-(insetTop)"
            metrics["insetTop"] = contentInset.top + detailLabelInset.top
        }
        
        // title
        if let v = titleLabel {
            addSubview(v)
            
            verticalFormat += "-[titleLabel]"
            views["titleLabel"] = v
            
            MaterialLayout.alignToParentHorizontally(self, child: v, left: contentInset.left + titleLabelInset.left, right: contentInset.right + titleLabelInset.right)
        }
        
        // detail
        if let v = detailLabel {
            addSubview(v)
            
            if nil == titleLabel {
                metrics["insetTop"] = (metrics["insetTop"] as! CGFloat) + detailLabelInset.top
            } else {
                verticalFormat += "-(insetB)"
                metrics["insetB"] = titleLabelInset.bottom + detailLabelInset.top
            }
            
            verticalFormat += "-[detailLabel]"
            views["detailLabel"] = v
            
            MaterialLayout.alignToParentHorizontally(self, child: v, left: contentInset.left + detailLabelInset.left, right: contentInset.right + detailLabelInset.right)
        }
        
        // leftImages
        if let v = leftImages {
            if 0 < v.count {
                var h: String = "H:|"
                var d: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
                var i: Int = 0
                for b in v {
                    let k: String = "b\(i)"
                    
                    d[k] = b
                    
                    if 0 == i++ {
                        h += "-(left)-"
                    } else {
                        h += "-(left_right)-"
                    }
                    
                    h += "[\(k)]"
                    
                    addSubview(b)
                    MaterialLayout.alignFromBottom(self, child: b, bottom: contentInset.bottom + leftImagesInset.bottom)
                }
                
                addConstraints(MaterialLayout.constraint(h, options: [], metrics: ["left" : contentInset.left + leftImagesInset.left, "left_right" : leftImagesInset.left + leftImagesInset.right], views: d))
            }
        }
        
        // rightImages
        if let v = rightImages {
            if 0 < v.count {
                var h: String = "H:"
                var d: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
                var i: Int = v.count - 1
                
                for b in v {
                    let k: String = "b\(i)"
                    
                    d[k] = b
                    
                    h += "[\(k)]"
                    
                    if 0 == i-- {
                        h += "-(right)-"
                    } else {
                        h += "-(right_left)-"
                    }
                    
                    addSubview(b)
                    MaterialLayout.alignFromBottom(self, child: b, bottom: contentInset.bottom + rightImagesInset.bottom)
                }
                
                addConstraints(MaterialLayout.constraint(h + "|", options: [], metrics: ["right" : contentInset.right + rightImagesInset.right, "right_left" : rightImagesInset.right + rightImagesInset.left], views: d))
            }
        }
        
        if 0 < leftImages?.count {
            verticalFormat += "-(insetC)-[button]"
            views["button"] = leftImages![0]
            metrics["insetC"] = leftImagesInset.top
            metrics["insetBottom"] = contentInset.bottom + leftImagesInset.bottom
        } else if 0 < rightImages?.count {
            verticalFormat += "-(insetC)-[button]"
            views["button"] = rightImages![0]
            metrics["insetC"] = rightImagesInset.top
            metrics["insetBottom"] = contentInset.bottom + rightImagesInset.bottom
        }
        
        if nil != detailLabel {
            if nil == metrics["insetC"] {
                metrics["insetBottom"] = contentInset.bottom + detailLabelInset.bottom + (divider ? dividerInset.top + dividerInset.bottom : 0)
            } else {
                metrics["insetC"] = (metrics["insetC"] as! CGFloat) + detailLabelInset.bottom + (divider ? dividerInset.top + dividerInset.bottom : 0)
            }
        } else if nil != titleLabel {
            if nil == metrics["insetC"] {
                metrics["insetBottom"] = contentInset.bottom + titleLabelInset.bottom + (divider ? dividerInset.top + dividerInset.bottom : 0)
            } else {
                metrics["insetC"] = (metrics["insetTop"] as! CGFloat) + titleLabelInset.bottom + (divider ? dividerInset.top + dividerInset.bottom : 0)
            }
        } else if nil != metrics["insetC"] {
            metrics["insetC"] = (metrics["insetC"] as! CGFloat) + contentInset.top + (divider ? dividerInset.top + dividerInset.bottom : 0)
        }
        
        
        if 0 < views.count {
            verticalFormat += "-(insetBottom)-|"
            addConstraints(MaterialLayout.constraint(verticalFormat, options: [], metrics: metrics, views: views))
        }
    }
    
    /**
     :name:	prepareView
     */
    public override func prepareView() {
        super.prepareView()
        pulseColor = MaterialColor.blueGrey.lighten4
        depth = .Depth2
        dividerColor = MaterialColor.blueGrey.lighten5
    }
    
    /**
     :name:	prepareProperties
     */
    internal func prepareProperties(image: UIImage?, titleLabel: UILabel?, detailLabel: UILabel?, rightImages: Array<UIImageView>?) {
        self.image = image
        self.titleLabel = titleLabel
        self.detailLabel = detailLabel
        self.rightImages = rightImages
    }
    
}
