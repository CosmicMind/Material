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
import Material

class ViewController: UIViewController {

    @IBOutlet weak var cardView: CardView!
    @IBOutlet weak var secondCardView: CardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Examples of using CardView
        prepareCardViewExample()
        prepareCardViewExampleTwo()
    }
    
    /**
     :name:	prepareView
     :description: General preparation statements.
     */
    private func prepareView() {
        view.backgroundColor = MaterialColor.white
    }
    
    /**
     :name:	prepareCardViewExample
     :description:	General usage example.
     */
    func prepareCardViewExample() {
        // Title label.
		let titleLabel: UILabel = UILabel()
		titleLabel.text = "Welcome Back!"
		titleLabel.textColor = MaterialColor.blue.darken1
		titleLabel.font = RobotoFont.mediumWithSize(20)
		cardView.titleLabel = titleLabel
		
		// Detail label.
		let detailLabel: UILabel = UILabel()
		detailLabel.text = "It’s been a while, have you read any new books lately?"
		detailLabel.numberOfLines = 0
		cardView.detailView = detailLabel
		
		// Yes button.
		let btn1: FlatButton = FlatButton()
		btn1.pulseColor = MaterialColor.blue.lighten1
		btn1.pulseScale = false
		btn1.setTitle("YES", forState: .Normal)
		btn1.setTitleColor(MaterialColor.blue.darken1, forState: .Normal)
		
		// No button.
		let btn2: FlatButton = FlatButton()
		btn2.pulseColor = MaterialColor.blue.lighten1
		btn2.pulseScale = false
		btn2.setTitle("NO", forState: .Normal)
		btn2.setTitleColor(MaterialColor.blue.darken1, forState: .Normal)
		
		// Add buttons to left side.
		cardView.leftButtons = [btn1, btn2]
	}
    
    /**
     :name:	prepareCardViewExampleTwo
     :description:	General usage example.
     */
    func prepareCardViewExampleTwo() {
        secondCardView.dividerInset.left = 100
        secondCardView.titleLabelInset.left = 100
        secondCardView.detailViewInset.left = 100
        secondCardView.pulseColor = MaterialColor.teal.lighten4
        
        // Image.
        secondCardView.image = UIImage(named: "Graph")?.resize(toHeight: 100)
        secondCardView.contentsGravity = .TopLeft
        
        // Title label.
        let titleLabel: UILabel = UILabel()
        titleLabel.text = "Graph"
        titleLabel.font = RobotoFont.mediumWithSize(24)
        secondCardView.titleLabel = titleLabel
        
        // Detail label.
        let detailLabel: UILabel = UILabel()
        detailLabel.text = "Build scalable data-driven apps."
        detailLabel.numberOfLines = 0
        secondCardView.detailView = detailLabel
        
        // LEARN MORE button.
		let btn1: FlatButton = FlatButton()
		btn1.pulseColor = MaterialColor.blue.lighten1
		btn1.pulseScale = false
		btn1.setTitle("LEARN MORE", forState: .Normal)
		btn1.setTitleColor(MaterialColor.blue.darken1, forState: .Normal)
		
        // Add buttons to right side.
        secondCardView.rightButtons = [btn1]
    }
}

