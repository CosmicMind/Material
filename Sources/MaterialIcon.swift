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
			let b: NSBundle? = NSBundle(URL: MaterialIcon.internalBundle!.resourceURL!.URLByAppendingPathComponent("io.cosmicmind.Material.bundle"))
			if let v: NSBundle = b {
				MaterialIcon.internalBundle = v
			}
		}
		return MaterialIcon.internalBundle!
	}
    
    private static func image(name:String!) -> UIImage {
        return (UIImage(named: name, inBundle: bundle, compatibleWithTraitCollection: nil)?.imageWithRenderingMode(.AlwaysTemplate))!
    }
    
    public static let add: UIImage? = MaterialIcon.image("ic_add_white")
    public static let addCircle: UIImage? = MaterialIcon.image("ic_add_circle_white")
    public static let addCircleOutline: UIImage? = MaterialIcon.image("ic_add_circle_outline_white")
    
	public static let arrowBack: UIImage? = MaterialIcon.image("ic_arrow_back_white")
	public static let arrowDownward: UIImage? = MaterialIcon.image("ic_arrow_downward_white")
    
    public static let audio: UIImage? = MaterialIcon.image("ic_audiotrack_white")
    
	public static let clear: UIImage? = MaterialIcon.image("ic_close_white")
    public static let close: UIImage? = MaterialIcon.image("ic_close_white")
    
    public static let edit: UIImage? = MaterialIcon.image("ic_edit_white")
    
    public static let history: UIImage? = MaterialIcon.image("ic_history_white")
    
    public static let picture: UIImage? = MaterialIcon.image("ic_image_white")
    
    public static let menu: UIImage? = MaterialIcon.image("ic_menu_white")
    
	public static let moreHorizontal: UIImage? = MaterialIcon.image("ic_more_horiz_white")
    public static let moreVertical: UIImage? = MaterialIcon.image("ic_more_vert_white")
    
    public static let movie: UIImage? = MaterialIcon.image("ic_movie_white")
    
    public static let pen: UIImage? = MaterialIcon.image("ic_edit_white")
    
    public static let place: UIImage? = MaterialIcon.image("ic_place_white")
    
	public static let photoCamera: UIImage? = MaterialIcon.image("ic_photo_camera_white")
	public static let photoLibrary: UIImage? = MaterialIcon.image("ic_photo_library_white")
    
    public static let search: UIImage? = MaterialIcon.image("ic_search_white")
    
    public static let settings: UIImage? = MaterialIcon.image("ic_settings_white")
    
    public static let share: UIImage? = MaterialIcon.image("ic_share_white")
    
    public static let star: UIImage? = MaterialIcon.image("ic_star_white")
    public static let starBorder: UIImage? = MaterialIcon.image("ic_star_border_white")
    public static let starHalf: UIImage? = MaterialIcon.image("ic_star_half_white")
    
	public static let videocam: UIImage? = MaterialIcon.image("ic_videocam_white")
}
