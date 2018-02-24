//
//  TimePickerView.swift
//  Material
//
//  Created by Orkhan Alikhanov on 1/23/18.
//  Copyright © 2018 CosmicMind, Inc. All rights reserved.
//

import UIKit
import Motion

open class TimePickerView: UIControl {
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
        
    open var needleColor = Color.blue.base {
        didSet {
            highlightedLayer.backgroundColor = needleColor.cgColor
        }
    }
    
    open var backgroundCircleColor = Color.grey.lighten3 {
        didSet {
            backgroundLayer.backgroundColor = backgroundCircleColor.cgColor
        }
    }
    
    open var highlightedTextColor = Color.lightText.primary
    open var textColor = Color.darkText.primary
    open var secondaryTextColor = Color.darkText.secondary
    
    open func prepare() {
        backgroundColor = .clear
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(highlightedLayer)
        highlightedLayer.mask = CAShapeLayer()
        highlightedLayer.addSublayer(minuteIndicatorLayer)
        
        needleColor = { needleColor }()
        backgroundCircleColor = { backgroundCircleColor }()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        highlightedLayer.frame = bounds
        backgroundLayer.frame = bounds
        backgroundLayer.cornerRadius = bounds.width / 2
        
        // setting correct frame for needleMaskLayer
        let backupTransform = needleMaskLayer.transform
        needleMaskLayer.transform = CATransform3DIdentity
        needleMaskLayer.frame = bounds
        needleMaskLayer.transform = backupTransform
        
        updateNeedle(animated: false)
    }
    
    open var time = (hour: 12, minute: 00) {
        didSet {
            guard oldValue != time else { return }
            updateNeedle(animated: false)
            sendActions(for: .valueChanged)
        }
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        updateTime(for: touches)
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        updateTime(for: touches)
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let p = touches.first?.location(in: self) else { return }
        guard let _ = nearestTimeValue(for: p) else { return }
        
        // TODO: maybe delay animation a bit?
        isShowingMinutes = true
        setNeedsDisplay()
        Motion.animate(duration: Constants.animationDuration, animations: {
            layer.displayIfNeeded()
            updateNeedle(animated: true)
        })
    }

    open var isAnimating = false
    open func setShowingMinutes(_ showingMinutes: Bool, animated: Bool) {
        guard !isAnimating else { return }
        isShowingMinutes = showingMinutes
        setNeedsDisplay()
        if animated {
            isAnimating = true
            Motion.animate(duration: Constants.animationDuration, animations: {
                layer.displayIfNeeded()
                updateNeedle(animated: true)
            }, completion: {
                self.isAnimating = false
            })
        } else {
            updateNeedle(animated: false)
        }
    }
    
    
    /// needle rotation happens differently
    ///
    ///
    open override func draw(_ rect: CGRect) {
       func draw(isHighlighted: Bool) -> CGImage? {
            UIGraphicsBeginImageContextWithOptions(rect.size, false, Screen.scale)
            defer { UIGraphicsEndImageContext() }
            if isShowingMinutes {
                drawNumbers(.minutes, isHighlighted: isHighlighted)
            } else {
                drawNumbers(.hours, isHighlighted: isHighlighted)
                if is24Hours { drawNumbers(.hours24, isHighlighted: isHighlighted) }
            }
            
            return UIGraphicsGetImageFromCurrentImageContext()?.cgImage
        }

        backgroundLayer.contents = draw(isHighlighted: false)
        highlightedLayer.contents = draw(isHighlighted: true)
    }

    private var highlightedLayer = CALayer()
    private var minuteIndicatorLayer = CALayer()
    private var backgroundLayer = CALayer()
    private var needleMaskLayer: CAShapeLayer { return highlightedLayer.mask as! CAShapeLayer }
    
    open var is24Hours = false
    open var isShowingMinutes = false {
        didSet {
            guard isShowingMinutes != oldValue else { return }
            sendActions(for: .valueChanged)
        }
    }
}

private extension TimePickerView {
    func nearestTimeValue(for point: CGPoint) -> Int? {
        func snapPoint(type: NumberType) -> Int? {
            return circlePoints(for: type, includeAll: true)
                .enumerated()
                .map { (idx: $0 + 1, distance: $1.distance(point)) } // idx, point, distance
                .filter { $0.distance < type.size / 2 } // distance < radius
                .sorted { $0.distance < $1.distance }
                .first?.idx
        }
        
        if isShowingMinutes {
            return snapPoint(type: .minutes)
        }
        
        if is24Hours, let p = snapPoint(type: .hours24) {
            return p + 12
        }

        return snapPoint(type: .hours)
    }

    func moveNeedleHead(to point: CGPoint, headRadius: CGFloat) {
        
        let r = point.distance(localCenter)
        let endPoint = CGPoint(x: localCenter.x + r, y: localCenter.y)
        
        let headCirclePath = UIBezierPath(arcCenter: endPoint,
                                          radius: headRadius,
                                          startAngle: 0,
                                          endAngle: 2 * .pi,
                                          clockwise: true)
        
        let tailCirclePath = UIBezierPath(arcCenter: localCenter,
                                          radius: Constants.tailRadius,
                                          startAngle: 0,
                                          endAngle: 2 * .pi,
                                          clockwise: true)
        
        
        let thickness = Constants.lineThickness
        let lineRect = CGRect(x: localCenter.x, y: localCenter.y - thickness / 2, width: r, height: thickness)
        let linePath = UIBezierPath(rect: lineRect)
        
        let needlePath = UIBezierPath()
        
        needlePath.append(headCirclePath)
        needlePath.append(tailCirclePath)
        needlePath.append(linePath)
        
        needleMaskLayer.path = needlePath.cgPath
        
        let angle = 0.5 * .pi - atan2(point.x - localCenter.x, point.y - localCenter.y)
        
        // rotate
        needleMaskLayer.transform = CATransform3DMakeRotation(angle, 0, 0, 1)
    }
    
    func drawNumbers(_ type: NumberType, isHighlighted: Bool) {
        let font = type == .hours24 ? Constants.numbers.secondary.font : Constants.numbers.primary.font
        let color = isHighlighted ? highlightedTextColor : type == .hours24 ? secondaryTextColor : textColor
        let size = type.size
        
        let attributes: [NSAttributedStringKey: Any] = [.font: font, .foregroundColor: color]
        let points = circlePoints(for: type)
        let numbers = type.numbers
        let options: NSStringDrawingOptions = .usesLineFragmentOrigin
        assert(points.count == numbers.count)
        for (point, number) in zip(points, numbers) {
            let num = number as NSString
            var rect = CGRect(center: point, size: CGSize(width: size, height: size))
            // centering the text both horizontally and vertically
            let textSize = num.boundingRect(with: .zero,
                                            options: options,
                                            attributes: attributes,
                                            context: nil).size
            
            rect.origin.x += (rect.width - textSize.width) / 2
            rect.origin.y += (rect.height - textSize.height) / 2
            
            num.draw(with: rect,
                     options: options,
                     attributes: attributes,
                     context: nil)
        }
    }
    
    func radius(for numberType: NumberType) -> CGFloat {
        switch numberType {
        case .hours, .minutes:
            return bounds.width / 2 * 0.97
        case .hours24:
            return bounds.width / 3 * 0.90
        }
    }
    
    func circlePoints(for numberType: NumberType, includeAll: Bool = false) -> [CGPoint] {
        let count = numberType == .minutes && includeAll ? 60 : 12
        let radius = self.radius(for: numberType) - numberType.size / 2

        return circlePoints(radius: radius, count: count)
    }

    func circlePoints(radius: CGFloat, count: Int) -> [CGPoint] {
        let anglePerPoint = 360 / CGFloat(count) * .pi / 180
        var points: [CGPoint] = []
        
        for i in (1...count) {
            let angle = CGFloat(i) * anglePerPoint
            
            var point = localCenter
            point.x += sin(angle) * radius
            point.y -= cos(angle) * radius
            points.append(point)
        }
        
        return points
    }
    
    func updateNeedle(animated: Bool) {
        let point = getCurrentPoint()
        let size = isShowingMinutes ? NumberType.minutes.size :
            time.hour > 12 || time.hour == 0 ? NumberType.hours24.size : NumberType.hours.size
        
        let oldPath = needleMaskLayer.path
        let oldTransform = needleMaskLayer.transform
        
        Motion.disable { // disabling implicit animations
            moveNeedleHead(to: point, headRadius: size / 2)
            // show highlight circle
            guard isShowingMinutes, time.minute % 5 != 0 else {
                minuteIndicatorLayer.isHidden = true
                return
            }
            
            minuteIndicatorLayer.isHidden = false
            let r = Constants.minuteIndicatorRadius
            minuteIndicatorLayer.frame = CGRect(center: point, size: CGSize(width: 2 * r, height: 2 * r))
            minuteIndicatorLayer.cornerRadius = r
            minuteIndicatorLayer.backgroundColor = UIColor.white.cgColor
        }
        
        guard animated else { return }
        
        // animate shape (eg head size)
        let shapeAnim = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.path))
        shapeAnim.fromValue = oldPath
        
        // animate rotation
        let rotationAnim = CABasicAnimation(keyPath: #keyPath(CALayer.transform))
        rotationAnim.fromValue = oldTransform
        
        // fire animations
        needleMaskLayer.add(shapeAnim, forKey: nil)
        needleMaskLayer.add(rotationAnim, forKey: nil)
    }
    
    func getCurrentPoint() -> CGPoint {
        func fixing(_ num: Int, _ max: Int) -> Int {
            if num == 0 { return max - 1 }
            return num - 1
        }
        
        if isShowingMinutes {
            return circlePoints(for: .minutes, includeAll: true)[fixing(time.minute, 60)]
        }
        
        if is24Hours {
            if time.hour == 0 {
                return circlePoints(for: .hours24)[11]
            } else if time.hour > 12 {
                return circlePoints(for: .hours24)[time.hour - 12 - 1]
            }
        }
        assert(time.hour >= 1 && time.hour <= 12)
        return circlePoints(for: .hours)[time.hour - 1]
    }
    
    func updateTime(for touches: Set<UITouch>) {
        guard let p = touches.first?.location(in: self) else { return }
        guard let i = nearestTimeValue(for: p) else { return }
        // update current time
        if isShowingMinutes {
            time.minute = i % 60
        } else {
            time.hour = i % 24
        }
        
        updateNeedle(animated: false)
    }
}

private struct Constants {
    struct numbers {
        struct primary {
            static let font = RobotoFont.medium
            static let size: CGFloat = 32
        }
        
        struct secondary {
            static let font = RobotoFont.medium(with: 13)
            static let size: CGFloat = 20
        }
    }
    
    static let tailRadius: CGFloat = 2
    static let minuteIndicatorRadius: CGFloat = 2
    static let animationDuration: TimeInterval = 0.5
    static let lineThickness: CGFloat = 2
}

private enum NumberType {
    case hours
    case hours24
    case minutes
    
    var numbers: [String] {
        switch self {
        case .hours:
            return (1...12).map { "\($0)" }
        case .hours24:
            return ((13...23).map { "\($0)"}) + ["00"]
        case .minutes:
            return ["05"] + (2...11).map { "\(5 * $0)" } + ["00"]
        }
    }
    
    var size: CGFloat {
        return self == .hours24 ? Constants.numbers.secondary.size : Constants.numbers.primary.size
    }
}

private extension UIView {
    var localCenter: CGPoint {
        return CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    }
}
