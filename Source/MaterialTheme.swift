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

public struct MaterialTheme {
	// white
	public struct white {
		public static let color: UIColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
	}
	
	// black
	public struct black {
		public static let color: UIColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
	}
	
	// red
	public struct red {
		public static let lighten5: UIColor = UIColor(red: 255/255, green: 235/255, blue: 238/255, alpha: 1)
		public static let lighten4: UIColor = UIColor(red: 225/255, green: 205/255, blue: 210/255, alpha: 1)
		public static let lighten3: UIColor = UIColor(red: 239/255, green: 154/255, blue: 254/255, alpha: 1)
		public static let lighten2: UIColor = UIColor(red: 229/255, green: 115/255, blue: 115/255, alpha: 1)
		public static let lighten1: UIColor = UIColor(red: 229/255, green: 83/255, blue: 80/255, alpha: 1)
		public static let color: UIColor = UIColor(red: 244/255, green: 67/255, blue: 54/255, alpha: 1)
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
		public static let lighten4: UIColor = UIColor(red: 248/255, green: 107/255, blue: 208/255, alpha: 1)
		public static let lighten3: UIColor = UIColor(red: 244/255, green: 143/255, blue: 177/255, alpha: 1)
		public static let lighten2: UIColor = UIColor(red: 240/255, green: 98/255, blue: 146/255, alpha: 1)
		public static let lighten1: UIColor = UIColor(red: 236/255, green: 64/255, blue: 122/255, alpha: 1)
		public static let color: UIColor = UIColor(red: 233/255, green: 30/255, blue: 99/255, alpha: 1)
		public static let darken1: UIColor = UIColor(red: 216/255, green: 27/255, blue: 96/255, alpha: 1)
		public static let darken2: UIColor = UIColor(red: 194/255, green: 24/255, blue: 191/255, alpha: 1)
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
		public static let color: UIColor = UIColor(red: 156/255, green: 39/255, blue: 176/255, alpha: 1)
		public static let darken1: UIColor = UIColor(red: 142/255, green: 36/255, blue: 170/255, alpha: 1)
		public static let darken2: UIColor = UIColor(red: 123/255, green: 31/255, blue: 162/255, alpha: 1)
		public static let darken3: UIColor = UIColor(red: 106/255, green: 27/255, blue: 154/255, alpha: 1)
		public static let darken4: UIColor = UIColor(red: 74/255, green: 20/255, blue: 140/255, alpha: 1)
		public static let accent1: UIColor = UIColor(red: 234/255, green: 128/255, blue: 252/255, alpha: 1)
		public static let accent2: UIColor = UIColor(red: 224/255, green: 64/255, blue: 251/255, alpha: 1)
		public static let accent3: UIColor = UIColor(red: 213/255, green: 0/255, blue: 249/255, alpha: 1)
		public static let accent4: UIColor = UIColor(red: 170/255, green: 0/255, blue: 255/255, alpha: 1)
	}
}
