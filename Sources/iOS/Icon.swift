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
 *	*	Neither the name of CosmicMind nor the names of its
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

public struct Icon {
	/// An internal reference to the icons bundle.
	private static var internalBundle: Bundle?
	
	/**
	A public reference to the icons bundle, that aims to detect
	the correct bundle to use.
	*/
	public static var bundle: Bundle {
		if nil == Icon.internalBundle {
			Icon.internalBundle = Bundle(for: View.self)
			let url = Icon.internalBundle!.resourceURL!
            let b = Bundle(url: url.appendingPathComponent("io.cosmicmind.material.icons.bundle"))
            if let v = b {
                Icon.internalBundle = v
            }
		}
		return Icon.internalBundle!
	}
	
	/// Get the icon by the file name.
    public static func icon(_ name: String) -> UIImage? {
        return UIImage(named: name, in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    }
    
    /// Google icons.
    public static let add: UIImage? = Icon.icon("ic_add_white")
	public static let addCircle: UIImage? = Icon.icon("ic_add_circle_white")
	public static let addCircleOutline: UIImage? = Icon.icon("ic_add_circle_outline_white")
	public static let arrowBack: UIImage? = Icon.icon("ic_arrow_back_white")
    public static let arrowDownward: UIImage? = Icon.icon("ic_arrow_downward_white")
    public static let audio: UIImage? = Icon.icon("ic_audiotrack_white")
    public static let bell: UIImage? = Icon.icon("cm_bell_white")
	public static let check: UIImage? = Icon.icon("ic_check_white")
	public static let clear: UIImage? = Icon.icon("ic_close_white")
    public static let close: UIImage? = Icon.icon("ic_close_white")
    public static let edit: UIImage? = Icon.icon("ic_edit_white")
	public static let favorite: UIImage? = Icon.icon("ic_favorite_white")
	public static let favoriteBorder: UIImage? = Icon.icon("ic_favorite_border_white")
	public static let history: UIImage? = Icon.icon("ic_history_white")
	public static let home: UIImage? = Icon.icon("ic_home_white")
	public static let image: UIImage? = Icon.icon("ic_image_white")
    public static let menu: UIImage? = Icon.icon("ic_menu_white")
    public static let moreHorizontal: UIImage? = Icon.icon("ic_more_horiz_white")
    public static let moreVertical: UIImage? = Icon.icon("ic_more_vert_white")
    public static let movie: UIImage? = Icon.icon("ic_movie_white")
    public static let pen: UIImage? = Icon.icon("ic_edit_white")
    public static let place: UIImage? = Icon.icon("ic_place_white")
    public static let photoCamera: UIImage? = Icon.icon("ic_photo_camera_white")
    public static let photoLibrary: UIImage? = Icon.icon("ic_photo_library_white")
    public static let search: UIImage? = Icon.icon("ic_search_white")
    public static let settings: UIImage? = Icon.icon("ic_settings_white")
    public static let share: UIImage? = Icon.icon("ic_share_white")
    public static let star: UIImage? = Icon.icon("ic_star_white")
    public static let starBorder: UIImage? = Icon.icon("ic_star_border_white")
    public static let starHalf: UIImage? = Icon.icon("ic_star_half_white")
    public static let videocam: UIImage? = Icon.icon("ic_videocam_white")
    public static let visibility: UIImage? = Icon.icon("ic_visibility_white")
    
	/// CosmicMind icons.
    public struct cm {
        public static let add: UIImage? = Icon.icon("cm_add_white")
        public static let arrowBack: UIImage? = Icon.icon("cm_arrow_back_white")
		public static let arrowDownward: UIImage? = Icon.icon("cm_arrow_downward_white")
		public static let audio: UIImage? = Icon.icon("cm_audio_white")
		public static let audioLibrary: UIImage? = Icon.icon("cm_audio_library_white")
		public static let bell: UIImage? = Icon.icon("cm_bell_white")
		public static let check: UIImage? = Icon.icon("cm_check_white")
		public static let clear: UIImage? = Icon.icon("cm_close_white")
        public static let close: UIImage? = Icon.icon("cm_close_white")
        public static let edit: UIImage? = Icon.icon("cm_pen_white")
        public static let image: UIImage? = Icon.icon("cm_image_white")
        public static let menu: UIImage? = Icon.icon("cm_menu_white")
		public static let microphone: UIImage? = Icon.icon("cm_microphone_white")
		public static let moreHorizontal: UIImage? = Icon.icon("cm_more_horiz_white")
        public static let moreVertical: UIImage? = Icon.icon("cm_more_vert_white")
        public static let movie: UIImage? = Icon.icon("cm_movie_white")
		public static let pause: UIImage? = Icon.icon("cm_pause_white")
		public static let pen: UIImage? = Icon.icon("cm_pen_white")
        public static let photoCamera: UIImage? = Icon.icon("cm_photo_camera_white")
		public static let photoLibrary: UIImage? = Icon.icon("cm_photo_library_white")
		public static let play: UIImage? = Icon.icon("cm_play_white")
		public static let search: UIImage? = Icon.icon("cm_search_white")
		public static let settings: UIImage? = Icon.icon("cm_settings_white")
		public static let share: UIImage? = Icon.icon("cm_share_white")
		public static let shuffle: UIImage? = Icon.icon("cm_shuffle_white")
		public static let skipBackward: UIImage? = Icon.icon("cm_skip_backward_white")
		public static let skipForward: UIImage? = Icon.icon("cm_skip_forward_white")
		public static let star: UIImage? = Icon.icon("cm_star_white")
        public static let videocam: UIImage? = Icon.icon("cm_videocam_white")
		public static let volumeHigh: UIImage? = Icon.icon("cm_volume_high_white")
		public static let volumeMedium: UIImage? = Icon.icon("cm_volume_medium_white")
		public static let volumeOff: UIImage? = Icon.icon("cm_volume_off_white")
	}
}
