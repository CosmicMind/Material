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

public enum MaterialIconSize {
	case Small
	case Normal
	case Medium
	case Large
}

public struct MaterialIcon {
	/**
		:name:	iconWithSize
	*/
	public static func iconWithSize(name: String, size: MaterialIconSize) -> UIImage? {
		switch size {
		case .Normal:
			return UIImage(named: name)
		case .Small:
			return UIImage(named: name + "_18pt")
		case .Medium:
			return UIImage(named: name + "_36pt")
		case .Large:
			return UIImage(named: name + "_48pt")
		}
	}
	
	// white
	public struct white {
		/**
			:name:	accessAlarm
		*/
		public static func accessAlarm(size: MaterialIconSize = .Normal) -> UIImage? {
			return MaterialIcon.iconWithSize("ic_access_alarm_white", size: size)
		}
		
		/**
			:name:	alarmOff
		*/
		public static func alarmOff(size: MaterialIconSize = .Normal) -> UIImage? {
			return MaterialIcon.iconWithSize("ic_alarm_off_white", size: size)
		}
		
		/**
			:name:	alarmOn
		*/
		public static func alarmOn(size: MaterialIconSize = .Normal) -> UIImage? {
			return MaterialIcon.iconWithSize("ic_alarm_on_white", size: size)
		}
		
		/**
			:name:	archive
		*/
		public static func archive(size: MaterialIconSize = .Normal) -> UIImage? {
			return MaterialIcon.iconWithSize("ic_archive_white", size: size)
		}
		
		/**
			:name:	check
		*/
		public static func check(size: MaterialIconSize = .Normal) -> UIImage? {
			return MaterialIcon.iconWithSize("ic_check_white", size: size)
		}
		
		/**
			:name:	checkCircle
		*/
		public static func checkCircle(size: MaterialIconSize = .Normal) -> UIImage? {
			return MaterialIcon.iconWithSize("ic_check_circle_white", size: size)
		}
		
		/**
			:name:	close
		*/
		public static func close(size: MaterialIconSize = .Normal) -> UIImage? {
			return MaterialIcon.iconWithSize("ic_close_white", size: size)
		}
		
		/**
			:name:	create
		*/
		public static func create(size: MaterialIconSize = .Normal) -> UIImage? {
			return MaterialIcon.iconWithSize("ic_create_white", size: size)
		}
		
		/**
			:name:	delete
		*/
		public static func delete(size: MaterialIconSize = .Normal) -> UIImage? {
			return MaterialIcon.iconWithSize("ic_delete_white", size: size)
		}
		
		/**
			:name:	list
		*/
		public static func list(size: MaterialIconSize = .Normal) -> UIImage? {
			return MaterialIcon.iconWithSize("ic_list_white", size: size)
		}
		
		/**
			:name:	menu
		*/
		public static func menu(size: MaterialIconSize = .Normal) -> UIImage? {
			return MaterialIcon.iconWithSize("ic_menu_white", size: size)
		}
		
		/**
			:name:	moreVert
		*/
		public static func moreVert(size: MaterialIconSize = .Normal) -> UIImage? {
			return MaterialIcon.iconWithSize("ic_more_vert_white", size: size)
		}
		
		/**
			:name:	search
		*/
		public static func search(size: MaterialIconSize = .Normal) -> UIImage? {
			return MaterialIcon.iconWithSize("ic_search_white", size: size)
		}
		
		/**
			:name:	star
		*/
		public static func star(size: MaterialIconSize = .Normal) -> UIImage? {
			return MaterialIcon.iconWithSize("ic_star_white", size: size)
		}
		
		/**
			:name:	starBorder
		*/
		public static func starBorder(size: MaterialIconSize = .Normal) -> UIImage? {
			return MaterialIcon.iconWithSize("ic_star_border_white", size: size)
		}
		
		/**
			:name:	stars
		*/
		public static func stars(size: MaterialIconSize = .Normal) -> UIImage? {
			return MaterialIcon.iconWithSize("ic_stars_white", size: size)
		}
		
		/**
			:name:	viewList
		*/
		public static func viewList(size: MaterialIconSize = .Normal) -> UIImage? {
			return MaterialIcon.iconWithSize("ic_view_list_white", size: size)
		}
	}
	
	// blueGrey
	public struct blueGrey {
		public struct darken4 {
			/**
				:name:	alarmOff
			*/
			public static func alarmOff(size: MaterialIconSize = .Normal) -> UIImage? {
				return MaterialIcon.iconWithSize("ic_alarm_off_blue_grey_darken_4", size: size)
			}
			
			/**
				:name:	alarmOn
			*/
			public static func alarmOn(size: MaterialIconSize = .Normal) -> UIImage? {
				return MaterialIcon.iconWithSize("ic_alarm_on_blue_grey_darken_4", size: size)
			}
			
			/**
				:name:	archive
			*/
			public static func archive(size: MaterialIconSize = .Normal) -> UIImage? {
				return MaterialIcon.iconWithSize("ic_archive_blue_grey_darken_4", size: size)
			}
			
			/**
				:name:	cancel
			*/
			public static func cancel(size: MaterialIconSize = .Normal) -> UIImage? {
				return MaterialIcon.iconWithSize("ic_cancel_blue_grey_darken_4", size: size)
			}
			
			/**
				:name:	check
			*/
			public static func check(size: MaterialIconSize = .Normal) -> UIImage? {
				return MaterialIcon.iconWithSize("ic_check_blue_grey_darken_4", size: size)
			}
			
			/**
				:name:	checkCircle
			*/
			public static func checkCircle(size: MaterialIconSize = .Normal) -> UIImage? {
				return MaterialIcon.iconWithSize("ic_check_circle_blue_grey_darken_4", size: size)
			}
			
			/**
				:name:	close
			*/
			public static func close(size: MaterialIconSize = .Normal) -> UIImage? {
				return MaterialIcon.iconWithSize("ic_close_blue_grey_darken_4", size: size)
			}
			
			/**
				:name:	delete
			*/
			public static func delete(size: MaterialIconSize = .Normal) -> UIImage? {
				return MaterialIcon.iconWithSize("ic_delete_blue_grey_darken_4", size: size)
			}
			
			/**
				:name:	search
			*/
			public static func search(size: MaterialIconSize = .Normal) -> UIImage? {
				return MaterialIcon.iconWithSize("ic_search_blue_grey_darken_4", size: size)
			}
			
			/**
				:name:	star
			*/
			public static func star(size: MaterialIconSize = .Normal) -> UIImage? {
				return MaterialIcon.iconWithSize("ic_star_blue_grey_darken_4", size: size)
			}
			
			/**
				:name:	stars
			*/
			public static func stars(size: MaterialIconSize = .Normal) -> UIImage? {
				return MaterialIcon.iconWithSize("ic_stars_blue_grey_darken_4", size: size)
			}
		}
	}
	
	// yellow
	public struct yellow {
		public struct darken3 {
			/**
				:name:	star
			*/
			public static func star(size: MaterialIconSize = .Normal) -> UIImage? {
				return MaterialIcon.iconWithSize("ic_star_yellow_darken_3", size: size)
			}
		}
	}
	
	// amber
	public struct amber {
		public struct darken3 {
			/**
				:name:	star
			*/
			public static func star(size: MaterialIconSize = .Normal) -> UIImage? {
				return MaterialIcon.iconWithSize("ic_star_amber_darken_3", size: size)
			}
		}
	}
}
