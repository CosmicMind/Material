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

public struct MaterialColor {
	// clear
	public static let clear: UIColor = UIColor.clearColor()
	
	// white
	public static let white: UIColor = UIColor.whiteColor()
	
	// black
	public static let black: UIColor = UIColor.blackColor()
	
	// dark text
	public struct darkText {
		public static let primary: UIColor = UIColor.blackColor().colorWithAlphaComponent(0.87)
		public static let secondary: UIColor = UIColor.blackColor().colorWithAlphaComponent(0.54)
		public static let others: UIColor = UIColor.blackColor().colorWithAlphaComponent(0.38)
		public static let dividers: UIColor = UIColor.blackColor().colorWithAlphaComponent(0.12)
	}
	
	// light text
	public struct lightText {
		public static let primary: UIColor = UIColor.whiteColor()
		public static let secondary: UIColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
		public static let others: UIColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
		public static let dividers: UIColor = UIColor.whiteColor().colorWithAlphaComponent(0.12)
	}
	
	// red
	public struct red {
		public static let lighten5: UIColor = UIColor(red: 255/255, green: 235/255, blue: 238/255, alpha: 1)
		public static let lighten4: UIColor = UIColor(red: 255/255, green: 205/255, blue: 210/255, alpha: 1)
		public static let lighten3: UIColor = UIColor(red: 239/255, green: 154/255, blue: 154/255, alpha: 1)
		public static let lighten2: UIColor = UIColor(red: 229/255, green: 115/255, blue: 115/255, alpha: 1)
		public static let lighten1: UIColor = UIColor(red: 229/255, green: 83/255, blue: 80/255, alpha: 1)
		public static let base: UIColor = UIColor(red: 244/255, green: 67/255, blue: 54/255, alpha: 1)
		public static let darken1: UIColor = UIColor(red: 229/255, green: 57/255, blue: 53/255, alpha: 1)
		public static let darken2: UIColor = UIColor(red: 211/255, green: 47/255, blue: 47/255, alpha: 1)
		public static let darken3: UIColor = UIColor(red: 198/255, green: 40/255, blue: 40/255, alpha: 1)
		public static let darken4: UIColor = UIColor(red: 183/255, green: 28/255, blue: 28/255, alpha: 1)
		public static let accent1: UIColor = UIColor(red: 255/255, green: 138/255, blue: 128/255, alpha: 1)
		public static let accent2: UIColor = UIColor(red: 255/255, green: 82/255, blue: 82/255, alpha: 1)
		public static let accent3: UIColor = UIColor(red: 255/255, green: 23/255, blue: 68/255, alpha: 1)
		public static let accent4: UIColor = UIColor(red: 213/255, green: 0/255, blue: 0/255, alpha: 1)
	}
	
	// pink
	public struct pink {
		public static let lighten5: UIColor = UIColor(red: 252/255, green: 228/255, blue: 236/255, alpha: 1)
		public static let lighten4: UIColor = UIColor(red: 248/255, green: 187/255, blue: 208/255, alpha: 1)
		public static let lighten3: UIColor = UIColor(red: 244/255, green: 143/255, blue: 177/255, alpha: 1)
		public static let lighten2: UIColor = UIColor(red: 240/255, green: 98/255, blue: 146/255, alpha: 1)
		public static let lighten1: UIColor = UIColor(red: 236/255, green: 64/255, blue: 122/255, alpha: 1)
		public static let base: UIColor = UIColor(red: 233/255, green: 30/255, blue: 99/255, alpha: 1)
		public static let darken1: UIColor = UIColor(red: 216/255, green: 27/255, blue: 96/255, alpha: 1)
		public static let darken2: UIColor = UIColor(red: 194/255, green: 24/255, blue: 91/255, alpha: 1)
		public static let darken3: UIColor = UIColor(red: 173/255, green: 20/255, blue: 87/255, alpha: 1)
		public static let darken4: UIColor = UIColor(red: 136/255, green: 14/255, blue: 79/255, alpha: 1)
		public static let accent1: UIColor = UIColor(red: 255/255, green: 128/255, blue: 171/255, alpha: 1)
		public static let accent2: UIColor = UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1)
		public static let accent3: UIColor = UIColor(red: 245/255, green: 0/255, blue: 87/255, alpha: 1)
		public static let accent4: UIColor = UIColor(red: 197/255, green: 17/255, blue: 98/255, alpha: 1)
	}
	
	// purple
	public struct purple {
		public static let lighten5: UIColor = UIColor(red: 243/255, green: 229/255, blue: 245/255, alpha: 1)
		public static let lighten4: UIColor = UIColor(red: 225/255, green: 190/255, blue: 231/255, alpha: 1)
		public static let lighten3: UIColor = UIColor(red: 206/255, green: 147/255, blue: 216/255, alpha: 1)
		public static let lighten2: UIColor = UIColor(red: 186/255, green: 104/255, blue: 200/255, alpha: 1)
		public static let lighten1: UIColor = UIColor(red: 171/255, green: 71/255, blue: 188/255, alpha: 1)
		public static let base: UIColor = UIColor(red: 156/255, green: 39/255, blue: 176/255, alpha: 1)
		public static let darken1: UIColor = UIColor(red: 142/255, green: 36/255, blue: 170/255, alpha: 1)
		public static let darken2: UIColor = UIColor(red: 123/255, green: 31/255, blue: 162/255, alpha: 1)
		public static let darken3: UIColor = UIColor(red: 106/255, green: 27/255, blue: 154/255, alpha: 1)
		public static let darken4: UIColor = UIColor(red: 74/255, green: 20/255, blue: 140/255, alpha: 1)
		public static let accent1: UIColor = UIColor(red: 234/255, green: 128/255, blue: 252/255, alpha: 1)
		public static let accent2: UIColor = UIColor(red: 224/255, green: 64/255, blue: 251/255, alpha: 1)
		public static let accent3: UIColor = UIColor(red: 213/255, green: 0/255, blue: 249/255, alpha: 1)
		public static let accent4: UIColor = UIColor(red: 170/255, green: 0/255, blue: 255/255, alpha: 1)
	}
	
	// deepPurple
	public struct deepPurple {
		public static let lighten5: UIColor = UIColor(red: 237/255, green: 231/255, blue: 246/255, alpha: 1)
		public static let lighten4: UIColor = UIColor(red: 209/255, green: 196/255, blue: 233/255, alpha: 1)
		public static let lighten3: UIColor = UIColor(red: 179/255, green: 157/255, blue: 219/255, alpha: 1)
		public static let lighten2: UIColor = UIColor(red: 149/255, green: 117/255, blue: 205/255, alpha: 1)
		public static let lighten1: UIColor = UIColor(red: 126/255, green: 87/255, blue: 194/255, alpha: 1)
		public static let base: UIColor = UIColor(red: 103/255, green: 58/255, blue: 183/255, alpha: 1)
		public static let darken1: UIColor = UIColor(red: 94/255, green: 53/255, blue: 177/255, alpha: 1)
		public static let darken2: UIColor = UIColor(red: 81/255, green: 45/255, blue: 168/255, alpha: 1)
		public static let darken3: UIColor = UIColor(red: 69/255, green: 39/255, blue: 160/255, alpha: 1)
		public static let darken4: UIColor = UIColor(red: 49/255, green: 27/255, blue: 146/255, alpha: 1)
		public static let accent1: UIColor = UIColor(red: 179/255, green: 136/255, blue: 255/255, alpha: 1)
		public static let accent2: UIColor = UIColor(red: 124/255, green: 77/255, blue: 255/255, alpha: 1)
		public static let accent3: UIColor = UIColor(red: 101/255, green: 31/255, blue: 255/255, alpha: 1)
		public static let accent4: UIColor = UIColor(red: 98/255, green: 0/255, blue: 234/255, alpha: 1)
	}
	
	// indigo
	public struct indigo {
		public static let lighten5: UIColor = UIColor(red: 232/255, green: 234/255, blue: 246/255, alpha: 1)
		public static let lighten4: UIColor = UIColor(red: 197/255, green: 202/255, blue: 233/255, alpha: 1)
		public static let lighten3: UIColor = UIColor(red: 159/255, green: 168/255, blue: 218/255, alpha: 1)
		public static let lighten2: UIColor = UIColor(red: 121/255, green: 134/255, blue: 203/255, alpha: 1)
		public static let lighten1: UIColor = UIColor(red: 92/255, green: 107/255, blue: 192/255, alpha: 1)
		public static let base: UIColor = UIColor(red: 63/255, green: 81/255, blue: 181/255, alpha: 1)
		public static let darken1: UIColor = UIColor(red: 57/255, green: 73/255, blue: 171/255, alpha: 1)
		public static let darken2: UIColor = UIColor(red: 48/255, green: 63/255, blue: 159/255, alpha: 1)
		public static let darken3: UIColor = UIColor(red: 40/255, green: 53/255, blue: 147/255, alpha: 1)
		public static let darken4: UIColor = UIColor(red: 26/255, green: 35/255, blue: 126/255, alpha: 1)
		public static let accent1: UIColor = UIColor(red: 140/255, green: 158/255, blue: 255/255, alpha: 1)
		public static let accent2: UIColor = UIColor(red: 83/255, green: 109/255, blue: 254/255, alpha: 1)
		public static let accent3: UIColor = UIColor(red: 61/255, green: 90/255, blue: 254/255, alpha: 1)
		public static let accent4: UIColor = UIColor(red: 48/255, green: 79/255, blue: 254/255, alpha: 1)
	}
	
	// blue
	public struct blue {
		public static let lighten5: UIColor = UIColor(red: 227/255, green: 242/255, blue: 253/255, alpha: 1)
		public static let lighten4: UIColor = UIColor(red: 187/255, green: 222/255, blue: 251/255, alpha: 1)
		public static let lighten3: UIColor = UIColor(red: 144/255, green: 202/255, blue: 249/255, alpha: 1)
		public static let lighten2: UIColor = UIColor(red: 100/255, green: 181/255, blue: 246/255, alpha: 1)
		public static let lighten1: UIColor = UIColor(red: 66/255, green: 165/255, blue: 245/255, alpha: 1)
		public static let base: UIColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1)
		public static let darken1: UIColor = UIColor(red: 30/255, green: 136/255, blue: 229/255, alpha: 1)
		public static let darken2: UIColor = UIColor(red: 25/255, green: 118/255, blue: 210/255, alpha: 1)
		public static let darken3: UIColor = UIColor(red: 21/255, green: 101/255, blue: 192/255, alpha: 1)
		public static let darken4: UIColor = UIColor(red: 13/255, green: 71/255, blue: 161/255, alpha: 1)
		public static let accent1: UIColor = UIColor(red: 130/255, green: 177/255, blue: 255/255, alpha: 1)
		public static let accent2: UIColor = UIColor(red: 68/255, green: 138/255, blue: 255/255, alpha: 1)
		public static let accent3: UIColor = UIColor(red: 41/255, green: 121/255, blue: 255/255, alpha: 1)
		public static let accent4: UIColor = UIColor(red: 41/255, green: 98/255, blue: 255/255, alpha: 1)
	}
	
	// light blue
	public struct lightBlue {
		public static let lighten5: UIColor = UIColor(red: 225/255, green: 245/255, blue: 254/255, alpha: 1)
		public static let lighten4: UIColor = UIColor(red: 179/255, green: 229/255, blue: 252/255, alpha: 1)
		public static let lighten3: UIColor = UIColor(red: 129/255, green: 212/255, blue: 250/255, alpha: 1)
		public static let lighten2: UIColor = UIColor(red: 79/255, green: 195/255, blue: 247/255, alpha: 1)
		public static let lighten1: UIColor = UIColor(red: 41/255, green: 182/255, blue: 246/255, alpha: 1)
		public static let base: UIColor = UIColor(red: 3/255, green: 169/255, blue: 244/255, alpha: 1)
		public static let darken1: UIColor = UIColor(red: 3/255, green: 155/255, blue: 229/255, alpha: 1)
		public static let darken2: UIColor = UIColor(red: 2/255, green: 136/255, blue: 209/255, alpha: 1)
		public static let darken3: UIColor = UIColor(red: 2/255, green: 119/255, blue: 189/255, alpha: 1)
		public static let darken4: UIColor = UIColor(red: 1/255, green: 87/255, blue: 155/255, alpha: 1)
		public static let accent1: UIColor = UIColor(red: 128/255, green: 216/255, blue: 255/255, alpha: 1)
		public static let accent2: UIColor = UIColor(red: 64/255, green: 196/255, blue: 255/255, alpha: 1)
		public static let accent3: UIColor = UIColor(red: 0/255, green: 176/255, blue: 255/255, alpha: 1)
		public static let accent4: UIColor = UIColor(red: 0/255, green: 145/255, blue: 234/255, alpha: 1)
	}
	
	// cyan
	public struct cyan {
		public static let lighten5: UIColor = UIColor(red: 224/255, green: 247/255, blue: 250/255, alpha: 1)
		public static let lighten4: UIColor = UIColor(red: 178/255, green: 235/255, blue: 242/255, alpha: 1)
		public static let lighten3: UIColor = UIColor(red: 128/255, green: 222/255, blue: 234/255, alpha: 1)
		public static let lighten2: UIColor = UIColor(red: 77/255, green: 208/255, blue: 225/255, alpha: 1)
		public static let lighten1: UIColor = UIColor(red: 38/255, green: 198/255, blue: 218/255, alpha: 1)
		public static let base: UIColor = UIColor(red: 0/255, green: 188/255, blue: 212/255, alpha: 1)
		public static let darken1: UIColor = UIColor(red: 0/255, green: 172/255, blue: 193/255, alpha: 1)
		public static let darken2: UIColor = UIColor(red: 0/255, green: 151/255, blue: 167/255, alpha: 1)
		public static let darken3: UIColor = UIColor(red: 0/255, green: 131/255, blue: 143/255, alpha: 1)
		public static let darken4: UIColor = UIColor(red: 0/255, green: 96/255, blue: 100/255, alpha: 1)
		public static let accent1: UIColor = UIColor(red: 132/255, green: 255/255, blue: 255/255, alpha: 1)
		public static let accent2: UIColor = UIColor(red: 24/255, green: 255/255, blue: 255/255, alpha: 1)
		public static let accent3: UIColor = UIColor(red: 0/255, green: 229/255, blue: 255/255, alpha: 1)
		public static let accent4: UIColor = UIColor(red: 0/255, green: 184/255, blue: 212/255, alpha: 1)
	}
	
	// teal
	public struct teal {
		public static let lighten5: UIColor = UIColor(red: 224/255, green: 242/255, blue: 241/255, alpha: 1)
		public static let lighten4: UIColor = UIColor(red: 178/255, green: 223/255, blue: 219/255, alpha: 1)
		public static let lighten3: UIColor = UIColor(red: 128/255, green: 203/255, blue: 196/255, alpha: 1)
		public static let lighten2: UIColor = UIColor(red: 77/255, green: 182/255, blue: 172/255, alpha: 1)
		public static let lighten1: UIColor = UIColor(red: 38/255, green: 166/255, blue: 154/255, alpha: 1)
		public static let base: UIColor = UIColor(red: 0/255, green: 150/255, blue: 136/255, alpha: 1)
		public static let darken1: UIColor = UIColor(red: 0/255, green: 137/255, blue: 123/255, alpha: 1)
		public static let darken2: UIColor = UIColor(red: 0/255, green: 121/255, blue: 107/255, alpha: 1)
		public static let darken3: UIColor = UIColor(red: 0/255, green: 105/255, blue: 92/255, alpha: 1)
		public static let darken4: UIColor = UIColor(red: 0/255, green: 77/255, blue: 64/255, alpha: 1)
		public static let accent1: UIColor = UIColor(red: 167/255, green: 255/255, blue: 235/255, alpha: 1)
		public static let accent2: UIColor = UIColor(red: 100/255, green: 255/255, blue: 218/255, alpha: 1)
		public static let accent3: UIColor = UIColor(red: 29/255, green: 233/255, blue: 182/255, alpha: 1)
		public static let accent4: UIColor = UIColor(red: 0/255, green: 191/255, blue: 165/255, alpha: 1)
	}
	
	// green
	public struct green {
		public static let lighten5: UIColor = UIColor(red: 232/255, green: 245/255, blue: 233/255, alpha: 1)
		public static let lighten4: UIColor = UIColor(red: 200/255, green: 230/255, blue: 201/255, alpha: 1)
		public static let lighten3: UIColor = UIColor(red: 165/255, green: 214/255, blue: 167/255, alpha: 1)
		public static let lighten2: UIColor = UIColor(red: 129/255, green: 199/255, blue: 132/255, alpha: 1)
		public static let lighten1: UIColor = UIColor(red: 102/255, green: 187/255, blue: 106/255, alpha: 1)
		public static let base: UIColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1)
		public static let darken1: UIColor = UIColor(red: 67/255, green: 160/255, blue: 71/255, alpha: 1)
		public static let darken2: UIColor = UIColor(red: 56/255, green: 142/255, blue: 60/255, alpha: 1)
		public static let darken3: UIColor = UIColor(red: 46/255, green: 125/255, blue: 50/255, alpha: 1)
		public static let darken4: UIColor = UIColor(red: 27/255, green: 94/255, blue: 32/255, alpha: 1)
		public static let accent1: UIColor = UIColor(red: 185/255, green: 246/255, blue: 202/255, alpha: 1)
		public static let accent2: UIColor = UIColor(red: 105/255, green: 240/255, blue: 174/255, alpha: 1)
		public static let accent3: UIColor = UIColor(red: 0/255, green: 230/255, blue: 118/255, alpha: 1)
		public static let accent4: UIColor = UIColor(red: 0/255, green: 200/255, blue: 83/255, alpha: 1)
	}
	
	// light green
	public struct lightGreen {
		public static let lighten5: UIColor = UIColor(red: 241/255, green: 248/255, blue: 233/255, alpha: 1)
		public static let lighten4: UIColor = UIColor(red: 220/255, green: 237/255, blue: 200/255, alpha: 1)
		public static let lighten3: UIColor = UIColor(red: 197/255, green: 225/255, blue: 165/255, alpha: 1)
		public static let lighten2: UIColor = UIColor(red: 174/255, green: 213/255, blue: 129/255, alpha: 1)
		public static let lighten1: UIColor = UIColor(red: 156/255, green: 204/255, blue: 101/255, alpha: 1)
		public static let base: UIColor = UIColor(red: 139/255, green: 195/255, blue: 74/255, alpha: 1)
		public static let darken1: UIColor = UIColor(red: 124/255, green: 179/255, blue: 66/255, alpha: 1)
		public static let darken2: UIColor = UIColor(red: 104/255, green: 159/255, blue: 56/255, alpha: 1)
		public static let darken3: UIColor = UIColor(red: 85/255, green: 139/255, blue: 47/255, alpha: 1)
		public static let darken4: UIColor = UIColor(red: 51/255, green: 105/255, blue: 30/255, alpha: 1)
		public static let accent1: UIColor = UIColor(red: 204/255, green: 255/255, blue: 144/255, alpha: 1)
		public static let accent2: UIColor = UIColor(red: 178/255, green: 255/255, blue: 89/255, alpha: 1)
		public static let accent3: UIColor = UIColor(red: 118/255, green: 255/255, blue: 3/255, alpha: 1)
		public static let accent4: UIColor = UIColor(red: 100/255, green: 221/255, blue: 23/255, alpha: 1)
	}
	
	// lime
	public struct lime {
		public static let lighten5: UIColor = UIColor(red: 249/255, green: 251/255, blue: 231/255, alpha: 1)
		public static let lighten4: UIColor = UIColor(red: 240/255, green: 244/255, blue: 195/255, alpha: 1)
		public static let lighten3: UIColor = UIColor(red: 230/255, green: 238/255, blue: 156/255, alpha: 1)
		public static let lighten2: UIColor = UIColor(red: 220/255, green: 231/255, blue: 117/255, alpha: 1)
		public static let lighten1: UIColor = UIColor(red: 212/255, green: 225/255, blue: 87/255, alpha: 1)
		public static let base: UIColor = UIColor(red: 205/255, green: 220/255, blue: 57/255, alpha: 1)
		public static let darken1: UIColor = UIColor(red: 192/255, green: 202/255, blue: 51/255, alpha: 1)
		public static let darken2: UIColor = UIColor(red: 175/255, green: 180/255, blue: 43/255, alpha: 1)
		public static let darken3: UIColor = UIColor(red: 158/255, green: 157/255, blue: 36/255, alpha: 1)
		public static let darken4: UIColor = UIColor(red: 130/255, green: 119/255, blue: 23/255, alpha: 1)
		public static let accent1: UIColor = UIColor(red: 244/255, green: 255/255, blue: 129/255, alpha: 1)
		public static let accent2: UIColor = UIColor(red: 238/255, green: 255/255, blue: 65/255, alpha: 1)
		public static let accent3: UIColor = UIColor(red: 198/255, green: 255/255, blue: 0/255, alpha: 1)
		public static let accent4: UIColor = UIColor(red: 174/255, green: 234/255, blue: 0/255, alpha: 1)
	}
	
	// yellow
	public struct yellow {
		public static let lighten5: UIColor = UIColor(red: 255/255, green: 253/255, blue: 231/255, alpha: 1)
		public static let lighten4: UIColor = UIColor(red: 255/255, green: 249/255, blue: 196/255, alpha: 1)
		public static let lighten3: UIColor = UIColor(red: 255/255, green: 245/255, blue: 157/255, alpha: 1)
		public static let lighten2: UIColor = UIColor(red: 255/255, green: 241/255, blue: 118/255, alpha: 1)
		public static let lighten1: UIColor = UIColor(red: 255/255, green: 238/255, blue: 88/255, alpha: 1)
		public static let base: UIColor = UIColor(red: 255/255, green: 235/255, blue: 59/255, alpha: 1)
		public static let darken1: UIColor = UIColor(red: 253/255, green: 216/255, blue: 53/255, alpha: 1)
		public static let darken2: UIColor = UIColor(red: 251/255, green: 192/255, blue: 45/255, alpha: 1)
		public static let darken3: UIColor = UIColor(red: 249/255, green: 168/255, blue: 37/255, alpha: 1)
		public static let darken4: UIColor = UIColor(red: 245/255, green: 127/255, blue: 23/255, alpha: 1)
		public static let accent1: UIColor = UIColor(red: 255/255, green: 255/255, blue: 141/255, alpha: 1)
		public static let accent2: UIColor = UIColor(red: 255/255, green: 255/255, blue: 0/255, alpha: 1)
		public static let accent3: UIColor = UIColor(red: 255/255, green: 234/255, blue: 0/255, alpha: 1)
		public static let accent4: UIColor = UIColor(red: 255/255, green: 214/255, blue: 0/255, alpha: 1)
	}
	
	// amber
	public struct amber {
		public static let lighten5: UIColor = UIColor(red: 255/255, green: 248/255, blue: 225/255, alpha: 1)
		public static let lighten4: UIColor = UIColor(red: 255/255, green: 236/255, blue: 179/255, alpha: 1)
		public static let lighten3: UIColor = UIColor(red: 255/255, green: 224/255, blue: 130/255, alpha: 1)
		public static let lighten2: UIColor = UIColor(red: 255/255, green: 213/255, blue: 79/255, alpha: 1)
		public static let lighten1: UIColor = UIColor(red: 255/255, green: 202/255, blue: 40/255, alpha: 1)
		public static let base: UIColor = UIColor(red: 255/255, green: 193/255, blue: 7/255, alpha: 1)
		public static let darken1: UIColor = UIColor(red: 255/255, green: 179/255, blue: 0/255, alpha: 1)
		public static let darken2: UIColor = UIColor(red: 255/255, green: 160/255, blue: 0/255, alpha: 1)
		public static let darken3: UIColor = UIColor(red: 255/255, green: 143/255, blue: 0/255, alpha: 1)
		public static let darken4: UIColor = UIColor(red: 255/255, green: 111/255, blue: 0/255, alpha: 1)
		public static let accent1: UIColor = UIColor(red: 255/255, green: 229/255, blue: 127/255, alpha: 1)
		public static let accent2: UIColor = UIColor(red: 255/255, green: 215/255, blue: 64/255, alpha: 1)
		public static let accent3: UIColor = UIColor(red: 255/255, green: 196/255, blue: 0/255, alpha: 1)
		public static let accent4: UIColor = UIColor(red: 255/255, green: 171/255, blue: 0/255, alpha: 1)
	}
	
	// orange
	public struct orange {
		public static let lighten5: UIColor = UIColor(red: 255/255, green: 243/255, blue: 224/255, alpha: 1)
		public static let lighten4: UIColor = UIColor(red: 255/255, green: 224/255, blue: 178/255, alpha: 1)
		public static let lighten3: UIColor = UIColor(red: 255/255, green: 204/255, blue: 128/255, alpha: 1)
		public static let lighten2: UIColor = UIColor(red: 255/255, green: 183/255, blue: 77/255, alpha: 1)
		public static let lighten1: UIColor = UIColor(red: 255/255, green: 167/255, blue: 38/255, alpha: 1)
		public static let base: UIColor = UIColor(red: 255/255, green: 152/255, blue: 0/255, alpha: 1)
		public static let darken1: UIColor = UIColor(red: 251/255, green: 140/255, blue: 0/255, alpha: 1)
		public static let darken2: UIColor = UIColor(red: 245/255, green: 124/255, blue: 0/255, alpha: 1)
		public static let darken3: UIColor = UIColor(red: 239/255, green: 108/255, blue: 0/255, alpha: 1)
		public static let darken4: UIColor = UIColor(red: 230/255, green: 81/255, blue: 0/255, alpha: 1)
		public static let accent1: UIColor = UIColor(red: 255/255, green: 209/255, blue: 128/255, alpha: 1)
		public static let accent2: UIColor = UIColor(red: 255/255, green: 171/255, blue: 64/255, alpha: 1)
		public static let accent3: UIColor = UIColor(red: 255/255, green: 145/255, blue: 0/255, alpha: 1)
		public static let accent4: UIColor = UIColor(red: 255/255, green: 109/255, blue: 0/255, alpha: 1)
	}
	
	
	// deep orange
	public struct deepOrange {
		public static let lighten5: UIColor = UIColor(red: 251/255, green: 233/255, blue: 231/255, alpha: 1)
		public static let lighten4: UIColor = UIColor(red: 255/255, green: 204/255, blue: 188/255, alpha: 1)
		public static let lighten3: UIColor = UIColor(red: 255/255, green: 171/255, blue: 145/255, alpha: 1)
		public static let lighten2: UIColor = UIColor(red: 255/255, green: 138/255, blue: 101/255, alpha: 1)
		public static let lighten1: UIColor = UIColor(red: 255/255, green: 112/255, blue: 67/255, alpha: 1)
		public static let base: UIColor = UIColor(red: 255/255, green: 87/255, blue: 34/255, alpha: 1)
		public static let darken1: UIColor = UIColor(red: 244/255, green: 81/255, blue: 30/255, alpha: 1)
		public static let darken2: UIColor = UIColor(red: 230/255, green: 74/255, blue: 25/255, alpha: 1)
		public static let darken3: UIColor = UIColor(red: 216/255, green: 67/255, blue: 21/255, alpha: 1)
		public static let darken4: UIColor = UIColor(red: 191/255, green: 54/255, blue: 12/255, alpha: 1)
		public static let accent1: UIColor = UIColor(red: 255/255, green: 158/255, blue: 128/255, alpha: 1)
		public static let accent2: UIColor = UIColor(red: 255/255, green: 110/255, blue: 64/255, alpha: 1)
		public static let accent3: UIColor = UIColor(red: 255/255, green: 61/255, blue: 0/255, alpha: 1)
		public static let accent4: UIColor = UIColor(red: 221/255, green: 44/255, blue: 0/255, alpha: 1)
	}
	
	
	// brown
	public struct brown {
		public static let lighten5: UIColor = UIColor(red: 239/255, green: 235/255, blue: 233/255, alpha: 1)
		public static let lighten4: UIColor = UIColor(red: 215/255, green: 204/255, blue: 200/255, alpha: 1)
		public static let lighten3: UIColor = UIColor(red: 188/255, green: 170/255, blue: 164/255, alpha: 1)
		public static let lighten2: UIColor = UIColor(red: 161/255, green: 136/255, blue: 127/255, alpha: 1)
		public static let lighten1: UIColor = UIColor(red: 141/255, green: 110/255, blue: 99/255, alpha: 1)
		public static let base: UIColor = UIColor(red: 121/255, green: 85/255, blue: 72/255, alpha: 1)
		public static let darken1: UIColor = UIColor(red: 109/255, green: 76/255, blue: 65/255, alpha: 1)
		public static let darken2: UIColor = UIColor(red: 93/255, green: 64/255, blue: 55/255, alpha: 1)
		public static let darken3: UIColor = UIColor(red: 78/255, green: 52/255, blue: 46/255, alpha: 1)
		public static let darken4: UIColor = UIColor(red: 62/255, green: 39/255, blue: 35/255, alpha: 1)
	}
	
	// grey
	public struct grey {
		public static let lighten5: UIColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
		public static let lighten4: UIColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
		public static let lighten3: UIColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
		public static let lighten2: UIColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1)
		public static let lighten1: UIColor = UIColor(red: 189/255, green: 189/255, blue: 189/255, alpha: 1)
		public static let base: UIColor = UIColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 1)
		public static let darken1: UIColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1)
		public static let darken2: UIColor = UIColor(red: 97/255, green: 97/255, blue: 97/255, alpha: 1)
		public static let darken3: UIColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1)
		public static let darken4: UIColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1)
	}
	
	// blue grey
	public struct blueGrey {
		public static let lighten5: UIColor = UIColor(red: 236/255, green: 239/255, blue: 241/255, alpha: 1)
		public static let lighten4: UIColor = UIColor(red: 207/255, green: 216/255, blue: 220/255, alpha: 1)
		public static let lighten3: UIColor = UIColor(red: 176/255, green: 190/255, blue: 197/255, alpha: 1)
		public static let lighten2: UIColor = UIColor(red: 144/255, green: 164/255, blue: 174/255, alpha: 1)
		public static let lighten1: UIColor = UIColor(red: 120/255, green: 144/255, blue: 156/255, alpha: 1)
		public static let base: UIColor = UIColor(red: 96/255, green: 125/255, blue: 139/255, alpha: 1)
		public static let darken1: UIColor = UIColor(red: 84/255, green: 110/255, blue: 122/255, alpha: 1)
		public static let darken2: UIColor = UIColor(red: 69/255, green: 90/255, blue: 100/255, alpha: 1)
		public static let darken3: UIColor = UIColor(red: 55/255, green: 71/255, blue: 79/255, alpha: 1)
		public static let darken4: UIColor = UIColor(red: 38/255, green: 50/255, blue: 56/255, alpha: 1)
	}
}
