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
        return NSFontAttributeName
    case .paragraphStyle:
        return NSParagraphStyleAttributeName
    case .forgroundColor:
        return NSForegroundColorAttributeName
    case .backgroundColor:
        return NSBackgroundColorAttributeName
    case .ligature:
        return NSLigatureAttributeName
    case .kern:
        return NSKernAttributeName
    case .strikethroughStyle:
        return NSStrikethroughStyleAttributeName
    case .underlineStyle:
        return NSUnderlineStyleAttributeName
    case .strokeColor:
        return NSStrokeColorAttributeName
    case .strokeWidth:
        return NSStrokeWidthAttributeName
    case .shadow:
        return NSShadowAttributeName
    case .textEffect:
        return NSTextEffectAttributeName
    case .attachment:
        return NSAttachmentAttributeName
    case .link:
        return NSLinkAttributeName
    case .baselineOffset:
        return NSBaselineOffsetAttributeName
    case .underlineColor:
        return NSUnderlineColorAttributeName
    case .strikethroughColor:
        return NSStrikethroughColorAttributeName
    case .obliqueness:
        return NSObliquenessAttributeName
    case .expansion:
        return NSExpansionAttributeName
    case .writingDirection:
        return NSWritingDirectionAttributeName
    case .verticalGlyphForm:
        return NSVerticalGlyphFormAttributeName
    }
}

extension NSMutableAttributedString {
    /**
     Adds a character attribute to a given range.
     - Parameter characterAttribute: A CharacterAttribute.
     - Parameter value: Any type.
     - Parameter range: A NSRange.
     */
    open func addAttribute(characterAttribute: CharacterAttribute, value: Any, range: NSRange) {
        addAttribute(CharacterAttributeToValue(attribute: characterAttribute), value: value, range: range)
    }
    
    /**
     Adds a Dictionary of character attributes to a given range.
     - Parameter characterAttributes: A Dictionary of CharacterAttribute type keys and Any type values.
     - Parameter range: A NSRange.
     */
    open func addAttributes(characterAttributes: [CharacterAttribute: Any], range: NSRange) {
        for (k, v) in characterAttributes {
            addAttribute(characterAttribute: k, value: v, range: range)
        }
    }
    
    /**
     Updates a character attribute to a given range.
     - Parameter characterAttribute: A CharacterAttribute.
     - Parameter value: Any type.
     - Parameter range: A NSRange.
     */
    open func updateAttribute(characterAttribute: CharacterAttribute, value: Any, range: NSRange) {
        removeAttribute(characterAttribute: characterAttribute, range: range)
        addAttribute(characterAttribute: characterAttribute, value: value, range: range)
    }
    
    /**
     Updates a Dictionary of character attributes to a given range.
     - Parameter characterAttributes: A Dictionary of CharacterAttribute type keys and Any type values.
     - Parameter range: A NSRange.
     */
    open func updateAttributes(characterAttributes: [CharacterAttribute: Any], range: NSRange) {
        for (k, v) in characterAttributes {
            updateAttribute(characterAttribute: k, value: v, range: range)
        }
    }
    
    /**
     Removes a character attribute from a given range.
     - Parameter characterAttribute: A CharacterAttribute.
     - Parameter range: A NSRange.
     */
    open func removeAttribute(characterAttribute: CharacterAttribute, range: NSRange) {
        removeAttribute(CharacterAttributeToValue(attribute: characterAttribute), range: range)
    }
    
    /**
     Removes a Dictionary of character attributes from a given range.
     - Parameter characterAttributes: An Array of CharacterAttributes.
     - Parameter range: A NSRange.
     */
    open func removeAttributes(characterAttributes: [CharacterAttribute], range: NSRange) {
        for k in characterAttributes {
            removeAttribute(characterAttribute: k, range: range)
        }
    }
}
