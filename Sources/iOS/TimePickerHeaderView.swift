//
//  TimePickerHeaderView.swift
//  Material
//
//  Created by Orkhan Alikhanov on 2/6/18.
//  Copyright © 2018 CosmicMind, Inc. All rights reserved.
//

import UIKit

open class TimePickerHeaderView: UIControl {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
    }
    
    open var textColor = Color.lightText.secondary
    open var highlightedTextColor = Color.lightText.primary
    
    open let hourLabel = UILabel()
    open let minuteLabel = UILabel()
    open let colonLabel = UILabel()
    open let amLabel = UILabel()
    open let pmLabel = UILabel()
    
    
    open var colonCenter: CGPoint {
        get {
            guard let s = superview else { return .zero }
            return convert(colonLabel.center, to: s)
        }
        set {
            let dx = center.x - colonCenter.x
            let dy = center.y - colonCenter.y
            center = newValue.translate(dx, dy: dy)
        }
    }
    
    var isLandscape = false {
        didSet {
            updateUI()
        }
    }
    
    open var is24Hours = false {
        didSet {
            updateUI()
        }
    }
    
    open var time = (hour: 12, minute: 0) {
        didSet {
            updateUI()
        }
    }
    
    open var isAm: Bool {
        get {
            return amLabel.isHighlighted
        }
        set {
            amLabel.isHighlighted = newValue
            pmLabel.isHighlighted = !newValue
        }
    }
    
    open var isShowingMinutes = false {
        didSet {
            updateUI()
        }
    }
    
    private lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
    
    @objc
    private func didTap(_ tap: UITapGestureRecognizer) {
        let loc = tap.location(in: self)
        guard let v = hitTest(loc, with: nil) else { return }
        
        if v == hourLabel || v == minuteLabel {
            isShowingMinutes = v == minuteLabel
            sendActions(for: .valueChanged)
        } else if v == amLabel || v == pmLabel {
            isAm = v == amLabel
        }
    }
    
    private func updateUI() {
        func padding(_ i: Int) -> String {
            if i < 10 { return "0\(i)" }
            return String(i)
        }
        hourLabel.text = is24Hours ? padding(time.hour) : String(time.hour)
        hourLabel.isHighlighted = !isShowingMinutes
        
        minuteLabel.text = padding(time.minute)
        minuteLabel.isHighlighted = isShowingMinutes
        
        amLabel.isHidden = is24Hours
        pmLabel.isHidden = is24Hours
        [amLabel, pmLabel].forEach {
            $0.font = isLandscape ? Constants.amPm.fontLandscape : Constants.amPm.font
        }

    }
    
    open func prepare() {
        addSubview(hourLabel)
        addSubview(minuteLabel)
        addSubview(colonLabel)
        addSubview(amLabel)
        addSubview(pmLabel)
    
        labels.forEach {
            $0.font = RobotoFont.regular(with: 45)
            $0.textColor = textColor
            $0.highlightedTextColor = highlightedTextColor
            $0.isUserInteractionEnabled = true // tap gesture
        }
        
        colonLabel.text = ":"
        pmLabel.text = "PM"
        amLabel.text = "AM"
        isAm = true
        
        addGestureRecognizer(tapGestureRecognizer)
//        backgroundColor = .red
    }
    
    private var labels: [UILabel] {
        return subviews.flatMap { $0 as? UILabel }
    }
    
    open override var intrinsicContentSize: CGSize {
        var h = minuteLabel.intrinsicContentSize.height
        var w = hourLabel.intrinsicContentSize.width +
            colonLabel.intrinsicContentSize.width +
            minuteLabel.intrinsicContentSize.width
        
        if !is24Hours {
            if isLandscape {
                h += Constants.amPm.marginLandscape +
                    amLabel.intrinsicContentSize.height +
                    pmLabel.intrinsicContentSize.height
            } else {
                w += amLabel.intrinsicContentSize.height + Constants.amPm.margin
            }
        }
        
        return CGSize(width: w, height: h)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        labels.forEach { $0.sizeToFit() }
        
        hourLabel.frame.origin = .zero
        colonLabel.frame.origin.x = hourLabel.frame.maxX
        minuteLabel.frame.origin.x = colonLabel.frame.maxX
        
        guard !is24Hours else { return }
        
        if isLandscape {
            amLabel.center.x = colonLabel.center.x
            pmLabel.center.x = colonLabel.center.x
            
            amLabel.frame.origin.y = colonLabel.frame.maxY + Constants.amPm.marginLandscape
            pmLabel.frame.origin.y = amLabel.frame.maxY

        } else {
            amLabel.frame.origin.x = minuteLabel.frame.maxX + Constants.amPm.margin
            amLabel.toplineY = minuteLabel.toplineY
            
            pmLabel.frame.origin.x = amLabel.frame.origin.x
            pmLabel.baselineY = minuteLabel.baselineY
        }
    }
    
    private struct Constants {
        struct amPm {
            static let margin: CGFloat = 10
            static let font = RobotoFont.regular(with: 13)
            
            static let marginLandscape: CGFloat = 10
            static let fontLandscape = RobotoFont.regular(with: 20)
        }
    }
}

private extension UILabel {
    var baselineY: CGFloat {
        get {
            return frame.maxY + font.descender
        }
        set {
            frame.origin.y = newValue - frame.height - font.descender
        }
    }
    
    var toplineY: CGFloat {
        get {
            return frame.minY + (font.ascender - font.capHeight)
        }
        set {
            frame.origin.y = newValue - (font.ascender - font.capHeight)
        }
    }
}

