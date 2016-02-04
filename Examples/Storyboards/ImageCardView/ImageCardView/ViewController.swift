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

    @IBOutlet weak var imageCardView: ImageCardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Example of image card view
        prepareImageCardViewExample()
    }
    
    /**
     :name:	prepareImageCardViewExample
     :description: General preparation statements.
     */
    func prepareImageCardViewExample() {
		imageCardView.divider = false
		
		// Image.
		imageCardView.image = UIImage(named: "MaterialImageCardViewBackgroundImage")
		
		// Title label.
		let titleLabel: UILabel = UILabel()
		titleLabel.text = "Material Design"
		titleLabel.textColor = MaterialColor.white
		titleLabel.font = RobotoFont.regularWithSize(24)
		imageCardView.titleLabel = titleLabel
		imageCardView.titleLabelInset.top = 80
		
		// Star button.
		let img1: UIImage? = UIImage(named: "ic_star_grey_darken_2")
		let btn1: FlatButton = FlatButton()
		btn1.pulseColor = MaterialColor.blueGrey.lighten1
		btn1.pulseScale = false
		btn1.setImage(img1, forState: .Normal)
		btn1.setImage(img1, forState: .Highlighted)
		
		// Favorite button.
		let img2: UIImage? = UIImage(named: "ic_favorite_grey_darken_2")
		let btn2: FlatButton = FlatButton()
		btn2.pulseColor = MaterialColor.blueGrey.lighten1
		btn2.pulseScale = false
		btn2.setImage(img2, forState: .Normal)
		btn2.setImage(img2, forState: .Highlighted)
		
		// Share button.
		let img3: UIImage? = UIImage(named: "ic_share_grey_darken_2")
		let btn3: FlatButton = FlatButton()
		btn3.pulseColor = MaterialColor.blueGrey.lighten1
		btn3.pulseScale = false
		btn3.setImage(img3, forState: .Normal)
		btn3.setImage(img3, forState: .Highlighted)
		
		// Add buttons to right side.
		imageCardView.rightButtons = [btn1, btn2, btn3]
    }
}

