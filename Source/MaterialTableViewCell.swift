//
// Copyright (C) 2015 GraphKit, Inc. <http://graphkit.io> and other GraphKit contributors.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published
// by the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program located at the root of the software package
// in a file called LICENSE.  If not, see <http://www.gnu.org/licenses/>.
//

import UIKit

public class MaterialTableViewCell: UITableViewCell {
	//
	//	:name:	panRecognizer
	//
	private var panRecognizer: UIPanGestureRecognizer!
	
	//
	//	:name:	originalCenter
	//
	private var originalCenter: CGPoint!
	
	//
	//	:name:	leftView
	//
	public var leftView: UIView? {
		didSet {
			if let v: UIView = leftView {
				contentView.addSubview(v)
			}
		}
	}
	
	//
	//	:name:	rightView
	//
	public var rightView: UIView? {
		didSet {
			if let v: UIView = rightView {
				contentView.addSubview(v)
			}
		}
	}
	
	//
	//	:name:	init
	//
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	//
	//	:name:	init
	//
	public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		prepareView()
	}
	
	//
	//	:name:	layoutSubviews
	//
	public override func layoutSubviews() {
		super.layoutSubviews()
		leftView?.frame = CGRectMake(-bounds.size.width, 0, bounds.size.width, bounds.size.height)
		rightView?.frame = CGRectMake(bounds.size.width, 0, bounds.size.width, bounds.size.height)
	}
	
	//
	//	:name:	gestureRecognizerShouldBegin
	//
	public override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
		if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
			let translation = panGestureRecognizer.translationInView(superview!)
			if fabs(translation.x) > fabs(translation.y) {
				return true
			}
			return false
		}
		return false
	}
	
	//
	//	:name:	handlePanGesture
	//
	internal func handlePanGesture(recognizer: UIPanGestureRecognizer) {
		switch recognizer.state {
		case .Began:
			break
		case .Changed:
			break
		case .Ended:
			break
		default:
			break
		}
	}
	
	//
	//	:name:	prepareView
	//
	private func prepareView() {
		clipsToBounds = true
		selectionStyle = .None
		panRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
		panRecognizer.delegate = self
		addGestureRecognizer(panRecognizer)
	}
}
