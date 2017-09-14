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

public enum CharacterAttribute: String {
    case font = "NSFontAttributeName"
    case paragraphStyle = "NSParagraphStyleAttributeName"
    case forgroundColor = "NSForegroundColorAttributeName"
    case backgroundColor = "NSBackgroundColorAttributeName"
    case ligature = "NSLigatureAttributeName"
    case kern = "NSKernAttributeName"
    case strikethroughStyle = "NSStrikethroughStyleAttributeName"
    case underlineStyle = "NSUnderlineStyleAttributeName"
    case strokeColor = "NSStrokeColorAttributeName"
    case strokeWidth = "NSStrokeWidthAttributeName"
    case shadow = "NSShadowAttributeName"
    case textEffect = "NSTextEffectAttributeName"
    case attachment = "NSAttachmentAttributeName"
    case link = "NSLinkAttributeName"
    case baselineOffset = "NSBaselineOffsetAttributeName"
    case underlineColor = "NSUnderlineColorAttributeName"
    case strikethroughColor = "NSStrikethroughColorAttributeName"
    case obliqueness = "NSObliquenessAttributeName"
    case expansion = "NSExpansionAttributeName"
    case writingDirection = "NSWritingDirectionAttributeName"
    case verticalGlyphForm = "NSVerticalGlyphFormAttributeName"
}

public func CharacterAttributeToValue(attribute: CharacterAttribute) -> String {
    switch attribute {
    case .font:
        return NSAttributedStringKey.font.rawValue
    case .paragraphStyle:
        return NSAttributedStringKey.paragraphStyle.rawValue
    case .forgroundColor:
        return NSAttributedStringKey.foregroundColor.rawValue
    case .backgroundColor:
        return NSAttributedStringKey.backgroundColor.rawValue
    case .ligature:
        return NSAttributedStringKey.ligature.rawValue
    case .kern:
        return NSAttributedStringKey.kern.rawValue
    case .strikethroughStyle:
        return NSAttributedStringKey.strikethroughStyle.rawValue
    case .underlineStyle:
        return NSAttributedStringKey.underlineStyle.rawValue
    case .strokeColor:
        return NSAttributedStringKey.strokeColor.rawValue
    case .strokeWidth:
        return NSAttributedStringKey.strokeWidth.rawValue
    case .shadow:
        return NSAttributedStringKey.shadow.rawValue
    case .textEffect:
        return NSAttributedStringKey.textEffect.rawValue
    case .attachment:
        return NSAttributedStringKey.attachment.rawValue
    case .link:
        return NSAttributedStringKey.link.rawValue
    case .baselineOffset:
        return NSAttributedStringKey.baselineOffset.rawValue
    case .underlineColor:
        return NSAttributedStringKey.underlineColor.rawValue
    case .strikethroughColor:
        return NSAttributedStringKey.strikethroughColor.rawValue
    case .obliqueness:
        return NSAttributedStringKey.obliqueness.rawValue
    case .expansion:
        return NSAttributedStringKey.expansion.rawValue
    case .writingDirection:
        return NSAttributedStringKey.writingDirection.rawValue
    case .verticalGlyphForm:
        return NSAttributedStringKey.verticalGlyphForm.rawValue
    }
}

extension NSMutableAttributedString {
    /**
     Adds a character attribute to a given range.
     - Parameter characterAttribute: A CharacterAttribute.
     - Parameter value: Any type.
     - Parameter range: A NSRange.
     */
    open func add(characterAttribute: CharacterAttribute, value: Any, range: NSRange) {
        addAttribute(NSAttributedStringKey(rawValue: CharacterAttributeToValue(attribute: characterAttribute)), value: value, range: range)
    }
    
    /**
     Adds a Dictionary of character attributes to a given range.
     - Parameter characterAttributes: A Dictionary of CharacterAttribute type keys and Any type values.
     - Parameter range: A NSRange.
     */
    open func add(characterAttributes: [CharacterAttribute: Any], range: NSRange) {
        for (k, v) in characterAttributes {
            add(characterAttribute: k, value: v, range: range)
        }
    }
    
    /**
     Updates a character attribute to a given range.
     - Parameter characterAttribute: A CharacterAttribute.
     - Parameter value: Any type.
     - Parameter range: A NSRange.
     */
    open func update(characterAttribute: CharacterAttribute, value: Any, range: NSRange) {
        remove(characterAttribute: characterAttribute, range: range)
        add(characterAttribute: characterAttribute, value: value, range: range)
    }
    
    /**
     Updates a Dictionary of character attributes to a given range.
     - Parameter characterAttributes: A Dictionary of CharacterAttribute type keys and Any type values.
     - Parameter range: A NSRange.
     */
    open func update(characterAttributes: [CharacterAttribute: Any], range: NSRange) {
        for (k, v) in characterAttributes {
            update(characterAttribute: k, value: v, range: range)
        }
    }
    
    /**
     Removes a character attribute from a given range.
     - Parameter characterAttribute: A CharacterAttribute.
     - Parameter range: A NSRange.
     */
    open func remove(characterAttribute: CharacterAttribute, range: NSRange) {
        removeAttribute(NSAttributedStringKey(rawValue: CharacterAttributeToValue(attribute: characterAttribute)), range: range)
    }
    
    /**
     Removes a Dictionary of character attributes from a given range.
     - Parameter characterAttributes: An Array of CharacterAttributes.
     - Parameter range: A NSRange.
     */
    open func remove(characterAttributes: [CharacterAttribute], range: NSRange) {
        for k in characterAttributes {
            remove(characterAttribute: k, range: range)
        }
    }
}
