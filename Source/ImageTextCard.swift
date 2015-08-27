//
//  ImageTextCard.swift
//  MaterialKit
//
//  Created by Adam Dahan on 2015-08-26.
//  Copyright (c) 2015 GraphKit Inc. All rights reserved.
//

import UIKit

public class ImageTextCard : MaterialPulseView {
    public lazy var imageView: UIImageView = UIImageView()
    public lazy var titleLabel: UILabel = UILabel()
    public lazy var descriptionContainerView: UIView = UIView()
    public lazy var descriptionLabel: UILabel = UILabel()

    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public required init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    internal override func initialize() {
        prepareImageView()
        prepareTitleLabel()
        prepareDescriptionContainerView()
        prepareDescriptionLabel()
        super.initialize()
    }
    
    internal override func constrainSubviews() {
        super.constrainSubviews()
        addConstraints(Layout.constraint("H:|[imageView]|", options: nil, metrics: nil, views: views))
        imageView.addConstraints(Layout.constraint("H:|-20-[titleLabel]-(20)-|", options: nil, metrics: nil, views: views))
        imageView.addConstraints(Layout.constraint("V:[titleLabel(45)]|", options: nil, metrics: nil, views: views))
        addConstraints(Layout.constraint("H:|[descriptionContainerView]|", options: nil, metrics: nil, views: views))
        descriptionContainerView.addConstraints(Layout.constraint("H:|-20-[descriptionLabel]-(20)-|", options: nil, metrics: nil, views: views))
        descriptionContainerView.addConstraints(Layout.constraint("V:|-(20)-[descriptionLabel]-(20)-|", options: nil, metrics: nil, views: views))
        addConstraints(Layout.constraint("V:|[imageView][descriptionContainerView(120)]|", options: nil, metrics: nil, views: views))
    }
    
    private func prepareImageView() {
        imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        imageView.contentMode = .ScaleAspectFill
        imageView.userInteractionEnabled = false
        imageView.clipsToBounds = true
        addSubview(imageView)
        views["imageView"] = imageView
    }
    
    private func prepareTitleLabel() {
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        titleLabel.font = Roboto.mediumWithSize(18)
        titleLabel.textColor = .whiteColor()
        titleLabel.text = "Card Title"
        titleLabel.layer.shadowOffset = CGSizeMake(1, 1)
        titleLabel.layer.shadowOpacity = 0.4
        titleLabel.layer.shadowRadius = 5.0
        imageView.addSubview(titleLabel)
        views["titleLabel"] = titleLabel
    }
    
    private func prepareDescriptionContainerView() {
        descriptionContainerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        descriptionContainerView.backgroundColor = UIColor.whiteColor()
        addSubview(descriptionContainerView)
        views["descriptionContainerView"] = descriptionContainerView
    }
    
    private func prepareDescriptionLabel() {
        descriptionLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        descriptionLabel.font = Roboto.lightWithSize(14)
        descriptionLabel.textColor = .darkTextColor()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        descriptionLabel.text = "I am a very simple card. I am good at containing small bits of information. I am convenient because I require little markup to use effectively."
        descriptionContainerView.addSubview(descriptionLabel)
        views["descriptionLabel"] = descriptionLabel
    }
}
