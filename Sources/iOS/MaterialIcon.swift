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

public struct MaterialIcon {
	/// An internal reference to the icons bundle.
	private static var internalBundle: NSBundle?
	
	/**
	A public reference to the icons bundle, that aims to detect
	the correct bundle to use.
	*/
	public static var bundle: NSBundle {
		if nil == MaterialIcon.internalBundle {
			MaterialIcon.internalBundle = NSBundle(forClass: MaterialView.self)
			let b: NSBundle? = NSBundle(URL: MaterialIcon.internalBundle!.resourceURL!.URLByAppendingPathComponent("io.cosmicmind.material.icons.bundle")!)
			if let v: NSBundle = b {
				MaterialIcon.internalBundle = v
			}
		}
		return MaterialIcon.internalBundle!
	}
	
	/// Get the icon by the file name.
    public static func icon(name: String) -> UIImage? {
        return UIImage(named: name, inBundle: bundle, compatibleWithTraitCollection: nil)?.imageWithRenderingMode(.AlwaysTemplate)
    }
    
    /// Google icons.
    public static let add: UIImage? = MaterialIcon.icon("ic_add_white")
	public static let addCircle: UIImage? = MaterialIcon.icon("ic_add_circle_white")
	public static let addCircleOutline: UIImage? = MaterialIcon.icon("ic_add_circle_outline_white")
	public static let arrowBack: UIImage? = MaterialIcon.icon("ic_arrow_back_white")
    public static let arrowDownward: UIImage? = MaterialIcon.icon("ic_arrow_downward_white")
    public static let audio: UIImage? = MaterialIcon.icon("ic_audiotrack_white")
    public static let bell: UIImage? = MaterialIcon.icon("cm_bell_white")
	public static let check: UIImage? = MaterialIcon.icon("ic_check_white")
	public static let clear: UIImage? = MaterialIcon.icon("ic_close_white")
    public static let close: UIImage? = MaterialIcon.icon("ic_close_white")
    public static let edit: UIImage? = MaterialIcon.icon("ic_edit_white")
	public static let favorite: UIImage? = MaterialIcon.icon("ic_favorite_white")
	public static let favoriteBorder: UIImage? = MaterialIcon.icon("ic_favorite_border_white")
	public static let history: UIImage? = MaterialIcon.icon("ic_history_white")
	public static let home: UIImage? = MaterialIcon.icon("ic_home_white")
	public static let image: UIImage? = MaterialIcon.icon("ic_image_white")
    public static let menu: UIImage? = MaterialIcon.icon("ic_menu_white")
    public static let moreHorizontal: UIImage? = MaterialIcon.icon("ic_more_horiz_white")
    public static let moreVertical: UIImage? = MaterialIcon.icon("ic_more_vert_white")
    public static let movie: UIImage? = MaterialIcon.icon("ic_movie_white")
    public static let pen: UIImage? = MaterialIcon.icon("ic_edit_white")
    public static let place: UIImage? = MaterialIcon.icon("ic_place_white")
    public static let photoCamera: UIImage? = MaterialIcon.icon("ic_photo_camera_white")
    public static let photoLibrary: UIImage? = MaterialIcon.icon("ic_photo_library_white")
    public static let search: UIImage? = MaterialIcon.icon("ic_search_white")
    public static let settings: UIImage? = MaterialIcon.icon("ic_settings_white")
    public static let share: UIImage? = MaterialIcon.icon("ic_share_white")
    public static let star: UIImage? = MaterialIcon.icon("ic_star_white")
    public static let starBorder: UIImage? = MaterialIcon.icon("ic_star_border_white")
    public static let starHalf: UIImage? = MaterialIcon.icon("ic_star_half_white")
    public static let videocam: UIImage? = MaterialIcon.icon("ic_videocam_white")
    public static let visibility: UIImage? = MaterialIcon.icon("ic_visibility_white")
    
	/// CosmicMind icons.
    public struct cm {
        public static let add: UIImage? = MaterialIcon.icon("cm_add_white")
        public static let arrowBack: UIImage? = MaterialIcon.icon("cm_arrow_back_white")
		public static let arrowDownward: UIImage? = MaterialIcon.icon("cm_arrow_downward_white")
		public static let audio: UIImage? = MaterialIcon.icon("cm_audio_white")
		public static let audioLibrary: UIImage? = MaterialIcon.icon("cm_audio_library_white")
		public static let bell: UIImage? = MaterialIcon.icon("cm_bell_white")
		public static let check: UIImage? = MaterialIcon.icon("cm_check_white")
		public static let clear: UIImage? = MaterialIcon.icon("cm_close_white")
        public static let close: UIImage? = MaterialIcon.icon("cm_close_white")
        public static let edit: UIImage? = MaterialIcon.icon("cm_pen_white")
        public static let image: UIImage? = MaterialIcon.icon("cm_image_white")
        public static let menu: UIImage? = MaterialIcon.icon("cm_menu_white")
		public static let microphone: UIImage? = MaterialIcon.icon("cm_microphone_white")
		public static let moreHorizontal: UIImage? = MaterialIcon.icon("cm_more_horiz_white")
        public static let moreVertical: UIImage? = MaterialIcon.icon("cm_more_vert_white")
        public static let movie: UIImage? = MaterialIcon.icon("cm_movie_white")
		public static let pause: UIImage? = MaterialIcon.icon("cm_pause_white")
		public static let pen: UIImage? = MaterialIcon.icon("cm_pen_white")
        public static let photoCamera: UIImage? = MaterialIcon.icon("cm_photo_camera_white")
		public static let photoLibrary: UIImage? = MaterialIcon.icon("cm_photo_library_white")
		public static let play: UIImage? = MaterialIcon.icon("cm_play_white")
		public static let search: UIImage? = MaterialIcon.icon("cm_search_white")
		public static let settings: UIImage? = MaterialIcon.icon("cm_settings_white")
		public static let share: UIImage? = MaterialIcon.icon("cm_share_white")
		public static let shuffle: UIImage? = MaterialIcon.icon("cm_shuffle_white")
		public static let skipBackward: UIImage? = MaterialIcon.icon("cm_skip_backward_white")
		public static let skipForward: UIImage? = MaterialIcon.icon("cm_skip_forward_white")
		public static let star: UIImage? = MaterialIcon.icon("cm_star_white")
        public static let videocam: UIImage? = MaterialIcon.icon("cm_videocam_white")
		public static let volumeHigh: UIImage? = MaterialIcon.icon("cm_volume_high_white")
		public static let volumeMedium: UIImage? = MaterialIcon.icon("cm_volume_medium_white")
		public static let volumeOff: UIImage? = MaterialIcon.icon("cm_volume_off_white")
	}
}
