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
	private static var internalBundle: NSBundle?
	public static var bundle: NSBundle {
		if nil == MaterialIcon.internalBundle {
			MaterialIcon.internalBundle = NSBundle(forClass: MaterialView.self)
			let b: NSBundle? = NSBundle(URL: MaterialIcon.internalBundle!.resourceURL!.URLByAppendingPathComponent("io.cosmicmind.material.icons.bundle"))
			if let v: NSBundle = b {
				MaterialIcon.internalBundle = v
			}
		}
		return MaterialIcon.internalBundle!
	}

	/// Default Google icons.
	public static let add: UIImage? = UIImage(named: "ic_add_white", inBundle: bundle, compatibleWithTraitCollection: nil)?.imageWithRenderingMode(.AlwaysTemplate)
	public static let arrowBack: UIImage? = UIImage(named: "ic_arrow_back_white", inBundle: bundle, compatibleWithTraitCollection: nil)?.imageWithRenderingMode(.AlwaysTemplate)
	public static let arrowDownward: UIImage? = UIImage(named: "ic_arrow_downward_white", inBundle: bundle, compatibleWithTraitCollection: nil)?.imageWithRenderingMode(.AlwaysTemplate)
	public static let clear: UIImage? = UIImage(named: "ic_close_white", inBundle: bundle, compatibleWithTraitCollection: nil)?.imageWithRenderingMode(.AlwaysTemplate)
	public static let close: UIImage? = UIImage(named: "ic_close_white", inBundle: bundle, compatibleWithTraitCollection: nil)?.imageWithRenderingMode(.AlwaysTemplate)
	public static let menu: UIImage? = UIImage(named: "ic_menu_white", inBundle: bundle, compatibleWithTraitCollection: nil)?.imageWithRenderingMode(.AlwaysTemplate)
	public static let moreHorizontal: UIImage? = UIImage(named: "ic_more_horiz_white", inBundle: bundle, compatibleWithTraitCollection: nil)?.imageWithRenderingMode(.AlwaysTemplate)
	public static let moreVertical: UIImage? = UIImage(named: "ic_more_vert_white", inBundle: bundle, compatibleWithTraitCollection: nil)?.imageWithRenderingMode(.AlwaysTemplate)
	public static let search: UIImage? = UIImage(named: "ic_search_white", inBundle: bundle, compatibleWithTraitCollection: nil)?.imageWithRenderingMode(.AlwaysTemplate)
	public static let share: UIImage? = UIImage(named: "ic_share_white", inBundle: bundle, compatibleWithTraitCollection: nil)?.imageWithRenderingMode(.AlwaysTemplate)
	public static let star: UIImage? = UIImage(named: "ic_star_white", inBundle: bundle, compatibleWithTraitCollection: nil)?.imageWithRenderingMode(.AlwaysTemplate)
	public static let videocam: UIImage? = UIImage(named: "ic_videocam_white", inBundle: bundle, compatibleWithTraitCollection: nil)?.imageWithRenderingMode(.AlwaysTemplate)

	/// Custom CosmicMind icons.
	public struct cm {
		public static let add: UIImage? = UIImage(named: "cm_add_white", inBundle: bundle, compatibleWithTraitCollection: nil)?.imageWithRenderingMode(.AlwaysTemplate)
		public static let arrowBack: UIImage? = UIImage(named: "cm_arrow_back_white", inBundle: bundle, compatibleWithTraitCollection: nil)?.imageWithRenderingMode(.AlwaysTemplate)
		public static let arrowDownward: UIImage? = UIImage(named: "cm_arrow_downward_white", inBundle: bundle, compatibleWithTraitCollection: nil)?.imageWithRenderingMode(.AlwaysTemplate)
		public static let audio: UIImage? = UIImage(named: "cm_audio_white", inBundle: bundle, compatibleWithTraitCollection: nil)?.imageWithRenderingMode(.AlwaysTemplate)
		public static let bell: UIImage? = UIImage(named: "cm_bell_white", inBundle: bundle, compatibleWithTraitCollection: nil)?.imageWithRenderingMode(.AlwaysTemplate)
		public static let clear: UIImage? = UIImage(named: "cm_close_white", inBundle: bundle, compatibleWithTraitCollection: nil)?.imageWithRenderingMode(.AlwaysTemplate)
		public static let close: UIImage? = UIImage(named: "cm_close_white", inBundle: bundle, compatibleWithTraitCollection: nil)?.imageWithRenderingMode(.AlwaysTemplate)
		public static let image: UIImage? = UIImage(named: "cm_image_white", inBundle: bundle, compatibleWithTraitCollection: nil)?.imageWithRenderingMode(.AlwaysTemplate)
		public static let menu: UIImage? = UIImage(named: "cm_menu_white", inBundle: bundle, compatibleWithTraitCollection: nil)?.imageWithRenderingMode(.AlwaysTemplate)
		public static let moreHorizontal: UIImage? = UIImage(named: "cm_more_horiz_white", inBundle: bundle, compatibleWithTraitCollection: nil)?.imageWithRenderingMode(.AlwaysTemplate)
		public static let moreVertical: UIImage? = UIImage(named: "cm_more_vert_white", inBundle: bundle, compatibleWithTraitCollection: nil)?.imageWithRenderingMode(.AlwaysTemplate)
		public static let pen: UIImage? = UIImage(named: "cm_pen_white", inBundle: bundle, compatibleWithTraitCollection: nil)?.imageWithRenderingMode(.AlwaysTemplate)
		public static let photoCamera: UIImage? = UIImage(named: "cm_photo_camera_white", inBundle: bundle, compatibleWithTraitCollection: nil)?.imageWithRenderingMode(.AlwaysTemplate)
		public static let photoLibrary: UIImage? = UIImage(named: "cm_photo_library_white", inBundle: bundle, compatibleWithTraitCollection: nil)?.imageWithRenderingMode(.AlwaysTemplate)
		public static let search: UIImage? = UIImage(named: "cm_search_white", inBundle: bundle, compatibleWithTraitCollection: nil)?.imageWithRenderingMode(.AlwaysTemplate)
		public static let settings: UIImage? = UIImage(named: "cm_settings_white", inBundle: bundle, compatibleWithTraitCollection: nil)?.imageWithRenderingMode(.AlwaysTemplate)
		public static let share: UIImage? = UIImage(named: "cm_share_white", inBundle: bundle, compatibleWithTraitCollection: nil)?.imageWithRenderingMode(.AlwaysTemplate)
		public static let star: UIImage? = UIImage(named: "cm_star_white", inBundle: bundle, compatibleWithTraitCollection: nil)?.imageWithRenderingMode(.AlwaysTemplate)
		public static let video: UIImage? = UIImage(named: "cm_video_white", inBundle: bundle, compatibleWithTraitCollection: nil)?.imageWithRenderingMode(.AlwaysTemplate)
		public static let videocam: UIImage? = UIImage(named: "cm_videocam_white", inBundle: bundle, compatibleWithTraitCollection: nil)?.imageWithRenderingMode(.AlwaysTemplate)
	}
}
