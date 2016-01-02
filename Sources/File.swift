//
// Copyright (C) 2015 - 2016 CosmicMind, Inc. <http://cosmicmind.io>. All rights reserved.
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

import Foundation

/**
:name: VideoExtension
*/
public enum VideoExtension {
	case MOV
	case M4V
	case MP4
}

/**
:name: VideoExtensionToString
*/
public func VideoExtensionToString(type: VideoExtension) -> String {
	switch type {
	case .MOV:
		return "mov"
	case .M4V:
		return "m4v"
	case .MP4:
		return "mp4"
	}
}

/**
:name: ImageExtensionToString
*/
public enum ImageExtension {
	case PNG
	case JPG
	case JPEG
	case TIFF
	case GIF
}

/**
:name: ImageExtensionToString
*/
public func ImageExtensionToString(type: ImageExtension) -> String {
	switch type {
	case .PNG:
		return "png"
	case .JPG:
		return "jpg"
	case .JPEG:
		return "jpeg"
	case .TIFF:
		return "tiff"
	case .GIF:
		return "gif"
	}
}

/**
:name: TextExtension
*/
public enum TextExtension {
	case TXT
	case RTF
	case HTML
}

/**
:name:	TextExtensionToString
*/
public func TextExtensionToString(type: TextExtension) -> String {
	switch type {
	case .TXT:
		return "txt"
	case .RTF:
		return "rtf"
	case .HTML:
		return "html"
	}
}

public enum SQLiteExtension {
	case SQLite
	case SQLiteSHM
}

/**
:name:	SQLiteExtensionToString
*/
public func SQLiteExtensionToString(type: SQLiteExtension) -> String {
	switch type {
	case .SQLite:
		return "sqlite"
	case .SQLiteSHM:
		return "sqlite-shm"
	}
}

/**
:name: Schemas used with Persistant Storage
*/
public struct Schema {
	public static let File: String = "File://"
}

/**
:name:	Result enum
*/
public enum Result {
	case Success
	case Failure(error: NSError)
}

/**
:name:	FileType enum
*/
public enum FileType {
	case Directory
	case Image
	case Video
	case Text
	case SQLite
	case Unknown
}

public struct File {
	/**
	:name:	documentDirectoryPath
	*/
	public static let documentDirectoryPath: NSURL? = File.pathForDirectory(.DocumentDirectory)
	
	/**
	:name:	libraryDirectoryPath
	*/
	public static let libraryDirectoryPath: NSURL? = File.pathForDirectory(.LibraryDirectory)
	
	/**
	:name:	applicationDirectoryPath
	*/
	public static let applicationSupportDirectoryPath: NSURL? = File.pathForDirectory(.ApplicationSupportDirectory)
	
	/**
	:name:	cachesDirectoryPath
	*/
	public static let cachesDirectoryPath: NSURL? = File.pathForDirectory(.CachesDirectory)
	
	/**
	:name:	rootPath
	*/
	public static var rootPath: NSURL? {
		let path: NSURL? = File.documentDirectoryPath
		var pathComponents = path?.pathComponents
		pathComponents?.removeLast()
		return NSURL(string:Schema.File.stringByAppendingString((pathComponents?.joinWithSeparator("/"))!))
	}
	
	/**
	:name:	fileExistsAtPath
	*/
	public static func fileExistsAtPath(url: NSURL) -> Bool {
		return NSFileManager.defaultManager().fileExistsAtPath(url.path!)
	}
	
	/**
	:name:	contentsEqualAtPath
	*/
	public static func contentsEqualAtPath(path: NSURL, andPath: NSURL) -> Bool {
		return NSFileManager.defaultManager().contentsEqualAtPath(path.path!, andPath: andPath.path!)
	}
	
	
	/**
	:name:  isWritableFileAtPath
	*/
	public static func isWritableFileAtPath(url: NSURL) -> Bool {
		return NSFileManager.defaultManager().isWritableFileAtPath(url.path!)
	}
	
	/**
	:name:  removeItemAtPath
	*/
	public static func removeItemAtPath(path: NSURL, completion: ((removed: Bool?, error: NSError?) -> Void)) {
		do {
			try NSFileManager.defaultManager().removeItemAtPath(path.path!)
			completion(removed: true, error: nil)
		} catch let error as NSError {
			completion(removed: nil, error: error)
		}
	}
	
	/**
	:name:	createDirectory
	*/
	public static func createDirectory(path: NSURL, name: String, withIntermediateDirectories createIntermediates: Bool, attributes: [String:AnyObject]?, completion: ((created: Bool?, error: NSError?) -> Void)){
		do {
			let newPath = path.URLByAppendingPathComponent(name)
			try NSFileManager.defaultManager().createDirectoryAtPath(newPath.path!, withIntermediateDirectories: createIntermediates, attributes: attributes)
			completion(created: true, error: nil)
		} catch let error as NSError {
			completion(created: nil, error: error)
		}
	}
	
	/**
	:name:	removeDirectory
	*/
	public static func removeDirectory(path: NSURL, completion: ((removed: Bool?, error: NSError?) -> Void))  {
		do {
			try NSFileManager.defaultManager().removeItemAtURL(path)
			completion(removed: true, error: nil)
		} catch let error as NSError {
			completion(removed: false, error: error)
		}
	}
	
	/**
	:name:	contentsOfDirectory
	*/
	public static func contentsOfDirectory(path: NSURL, shouldSkipHiddenFiles skip: Bool = false, completion: ((contents: [NSURL]?, error: NSError?) -> Void)) {
		do {
			let contents = try NSFileManager.defaultManager().contentsOfDirectoryAtURL(path, includingPropertiesForKeys: nil, options: skip == true ? NSDirectoryEnumerationOptions.SkipsHiddenFiles : NSDirectoryEnumerationOptions(rawValue: 0))
			completion(contents: contents, error: nil)
		} catch let error as NSError {
			return completion(contents: nil, error: error)
		}
	}
	
	/**
	:name:	writeTo
	*/
	public static func writeTo(path: NSURL, value: String, name: String, completion: ((write: Bool?, error: NSError?) -> Void)) {
		do{
			try value.writeToURL(path.URLByAppendingPathComponent("/\(name)"), atomically: true, encoding: NSUTF8StringEncoding)
			completion(write: true, error: nil)
		} catch let error as NSError {
			completion(write: false, error: error)
		}
	}
	
	/**
	:name:	readFrom
	*/
	public static func readFrom(path: NSURL, completion: ((string: String?, error: NSError?) -> Void)) {
		let data: NSData? = NSData(contentsOfURL: path)
		if let fileData = data {
			let content = String(data: fileData, encoding:NSUTF8StringEncoding)
			completion(string: content, error: nil)
			return
		}
		completion(string: nil, error: NSError(domain: "com.contentkit.fileReadError", code: 0, userInfo: nil))
	}
	
	/**
	:name:	url
	*/
	public static func url(searchPathDirectory: NSSearchPathDirectory, path: String) -> NSURL? {
		var url: NSURL?
		switch searchPathDirectory {
		case .DocumentDirectory:
			url = File.documentDirectoryPath
		case .LibraryDirectory:
			url = File.libraryDirectoryPath
		case .CachesDirectory:
			url = File.cachesDirectoryPath
		case .ApplicationSupportDirectory:
			url = File.applicationSupportDirectoryPath
		default:
			url = nil
			break
		}
		return url?.URLByAppendingPathComponent(path)
	}
	
	/**
	:name: pathForDirectory
	*/
	public static func pathForDirectory(searchPath: NSSearchPathDirectory) -> NSURL? {
		return try? NSFileManager.defaultManager().URLForDirectory(searchPath, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
	}
	
	/**
	:name: fileType
	*/
	public static func fileType(url: NSURL) -> FileType {
		var isDir: Bool = false
		File.contentsOfDirectory(url) { (contents, error) -> Void in
			if nil == error {
				return isDir = true
			}
		}
		if isDir {
			return .Directory
		}
		if let v: String = url.pathExtension {
			switch v {
			case ImageExtensionToString(.PNG),
			ImageExtensionToString(.JPG),
			ImageExtensionToString(.JPEG),
			ImageExtensionToString(.GIF):
				return .Image
			case TextExtensionToString(.TXT),
			TextExtensionToString(.RTF),
			TextExtensionToString(.HTML):
				return .Text
			case VideoExtensionToString(.MOV),
			VideoExtensionToString(.M4V),
			VideoExtensionToString(.MP4):
				return .Video
			case SQLiteExtensionToString(.SQLite),
			SQLiteExtensionToString(.SQLiteSHM):
				return .SQLite
			default:
				break
			}
		}
		return .Unknown
	}
}