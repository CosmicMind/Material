//
//  ImageCard.swift
//  MaterialKit
//
//  Created by Adam Dahan on 2015-08-23.
//  Copyright (c) 2015 GraphKit Inc. All rights reserved.
//

import UIKit

public class ImageCard : PulseView {

    public lazy var imageView: UIImageView = UIImageView()
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public required init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    internal override func initialize() {
        setupImageView()
        super.initialize()
    }
    
    func setupImageView() {
        imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        imageView.contentMode = .ScaleAspectFill
        imageView.userInteractionEnabled = false
        imageView.clipsToBounds = true
        addSubview(imageView)
        views.setObject(imageView, forKey: "imageView")
    }
    
    internal override func constrainSubviews() {
        super.constrainSubviews()
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[imageView]-(0)-|", options: nil, metrics: nil, views: views as [NSObject : AnyObject]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(0)-[imageView]-(0)-|", options: nil, metrics: nil, views: views as [NSObject : AnyObject]))
    }
}
