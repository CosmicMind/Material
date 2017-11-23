/*
 * Copyright (C) 2015 - 2017, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
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
            let b = Bundle(url: url.appendingPathComponent("com.cosmicmind.material.icons.bundle"))
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
    public static var add = Icon.icon("ic_add_white")
	public static var addCircle = Icon.icon("ic_add_circle_white")
	public static var addCircleOutline = Icon.icon("ic_add_circle_outline_white")
	public static var arrowBack = Icon.icon("ic_arrow_back_white")
    public static var arrowDownward = Icon.icon("ic_arrow_downward_white")
    public static var audio = Icon.icon("ic_audiotrack_white")
    public static var bell = Icon.icon("cm_bell_white")
    public static var cameraFront = Icon.icon("ic_camera_front_white")
    public static var cameraRear = Icon.icon("ic_camera_rear_white")
    public static var check = Icon.icon("ic_check_white")
	public static var clear = Icon.icon("ic_close_white")
    public static var close = Icon.icon("ic_close_white")
    public static var edit = Icon.icon("ic_edit_white")
    public static var email = Icon.icon("ic_email_white")
    public static var favorite = Icon.icon("ic_favorite_white")
	public static var favoriteBorder = Icon.icon("ic_favorite_border_white")
    public static var flashAuto = Icon.icon("ic_flash_auto_white")
    public static var flashOff = Icon.icon("ic_flash_off_white")
    public static var flashOn = Icon.icon("ic_flash_on_white")
    public static var history = Icon.icon("ic_history_white")
	public static var home = Icon.icon("ic_home_white")
	public static var image = Icon.icon("ic_image_white")
    public static var menu = Icon.icon("ic_menu_white")
    public static var moreHorizontal = Icon.icon("ic_more_horiz_white")
    public static var moreVertical = Icon.icon("ic_more_vert_white")
    public static var movie = Icon.icon("ic_movie_white")
    public static var pen = Icon.icon("ic_edit_white")
    public static var place = Icon.icon("ic_place_white")
    public static var phone = Icon.icon("ic_phone_white")
    public static var photoCamera = Icon.icon("ic_photo_camera_white")
    public static var photoLibrary = Icon.icon("ic_photo_library_white")
    public static var search = Icon.icon("ic_search_white")
    public static var settings = Icon.icon("ic_settings_white")
    public static var share = Icon.icon("ic_share_white")
    public static var star = Icon.icon("ic_star_white")
    public static var starBorder = Icon.icon("ic_star_border_white")
    public static var starHalf = Icon.icon("ic_star_half_white")
    public static var videocam = Icon.icon("ic_videocam_white")
    public static var visibility = Icon.icon("ic_visibility_white")
    public static var visibilityOff = Icon.icon("ic_visibility_off_white")
    public static var work = Icon.icon("ic_work_white")
    
	/// CosmicMind icons.
    public struct cm {
        public static var add = Icon.icon("cm_add_white")
        public static var arrowBack = Icon.icon("cm_arrow_back_white")
		public static var arrowDownward = Icon.icon("cm_arrow_downward_white")
		public static var audio = Icon.icon("cm_audio_white")
		public static var audioLibrary = Icon.icon("cm_audio_library_white")
		public static var bell = Icon.icon("cm_bell_white")
		public static var check = Icon.icon("cm_check_white")
		public static var clear = Icon.icon("cm_close_white")
        public static var close = Icon.icon("cm_close_white")
        public static var edit = Icon.icon("cm_pen_white")
        public static var image = Icon.icon("cm_image_white")
        public static var menu = Icon.icon("cm_menu_white")
		public static var microphone = Icon.icon("cm_microphone_white")
		public static var moreHorizontal = Icon.icon("cm_more_horiz_white")
        public static var moreVertical = Icon.icon("cm_more_vert_white")
        public static var movie = Icon.icon("cm_movie_white")
		public static var pause = Icon.icon("cm_pause_white")
		public static var pen = Icon.icon("cm_pen_white")
        public static var photoCamera = Icon.icon("cm_photo_camera_white")
		public static var photoLibrary = Icon.icon("cm_photo_library_white")
		public static var play = Icon.icon("cm_play_white")
		public static var search = Icon.icon("cm_search_white")
		public static var settings = Icon.icon("cm_settings_white")
		public static var share = Icon.icon("cm_share_white")
		public static var shuffle = Icon.icon("cm_shuffle_white")
		public static var skipBackward = Icon.icon("cm_skip_backward_white")
		public static var skipForward = Icon.icon("cm_skip_forward_white")
		public static var star = Icon.icon("cm_star_white")
        public static var videocam = Icon.icon("cm_videocam_white")
		public static var volumeHigh = Icon.icon("cm_volume_high_white")
		public static var volumeMedium = Icon.icon("cm_volume_medium_white")
		public static var volumeOff = Icon.icon("cm_volume_off_white")
	}
}
