/*
 * Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
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

public enum CharacterAttributePreset {
    case font
    case paragraphStyle
    case forgroundColor
    case backgroundColor
    case ligature
    case kern
    case strikethroughStyle
    case underlineStyle
    case strokeColor
    case strokeWidth
    case shadow
    case textEffect
    case attachment
    case baselineOffset
    case underlineColor
    case strikethroughColor
    case obliqueness
    case expansion
    case writingDirection
    case verticalGlyphForm
}

public func CharacterSpacePresetToValue(preset: CharacterAttributePreset) -> String {
    // Predefined character attributes for text. If the key is not in the dictionary, then use the default values as described below.
    /************************ Attributes ************************/
    @available(iOS 6.0, *)
    public let NSFontAttributeName: String // UIFont, default Helvetica(Neue) 12
    @available(iOS 6.0, *)
    public let NSParagraphStyleAttributeName: String // NSParagraphStyle, default defaultParagraphStyle
    @available(iOS 6.0, *)
    public let NSForegroundColorAttributeName: String // UIColor, default blackColor
    @available(iOS 6.0, *)
    public let NSBackgroundColorAttributeName: String // UIColor, default nil: no background
    @available(iOS 6.0, *)
    public let NSLigatureAttributeName: String // NSNumber containing integer, default 1: default ligatures, 0: no ligatures
    @available(iOS 6.0, *)
    public let NSKernAttributeName: String // NSNumber containing floating point value, in points; amount to modify default kerning. 0 means kerning is disabled.
    @available(iOS 6.0, *)
    public let NSStrikethroughStyleAttributeName: String // NSNumber containing integer, default 0: no strikethrough
    @available(iOS 6.0, *)
    public let NSUnderlineStyleAttributeName: String // NSNumber containing integer, default 0: no underline
    @available(iOS 6.0, *)
    public let NSStrokeColorAttributeName: String // UIColor, default nil: same as foreground color
    @available(iOS 6.0, *)
    public let NSStrokeWidthAttributeName: String // NSNumber containing floating point value, in percent of font point size, default 0: no stroke; positive for stroke alone, negative for stroke and fill (a typical value for outlined text would be 3.0)
    @available(iOS 6.0, *)
    public let NSShadowAttributeName: String // NSShadow, default nil: no shadow
    @available(iOS 7.0, *)
    public let NSTextEffectAttributeName: String // NSString, default nil: no text effect
    
    @available(iOS 7.0, *)
    public let NSAttachmentAttributeName: String // NSTextAttachment, default nil
    @available(iOS 7.0, *)
    public let NSLinkAttributeName: String // NSURL (preferred) or NSString
    @available(iOS 7.0, *)
    public let NSBaselineOffsetAttributeName: String // NSNumber containing floating point value, in points; offset from baseline, default 0
    @available(iOS 7.0, *)
    public let NSUnderlineColorAttributeName: String // UIColor, default nil: same as foreground color
    @available(iOS 7.0, *)
    public let NSStrikethroughColorAttributeName: String // UIColor, default nil: same as foreground color
    @available(iOS 7.0, *)
    public let NSObliquenessAttributeName: String // NSNumber containing floating point value; skew to be applied to glyphs, default 0: no skew
    @available(iOS 7.0, *)
    public let NSExpansionAttributeName: String // NSNumber containing floating point value; log of expansion factor to be applied to glyphs, default 0: no expansion
    
    @available(iOS 7.0, *)
    public let NSWritingDirectionAttributeName: String // NSArray of NSNumbers representing the nested levels of writing direction overrides as defined by Unicode LRE, RLE, LRO, and RLO characters.  The control characters can be obtained by masking NSWritingDirection and NSWritingDirectionFormatType values.  LRE: NSWritingDirectionLeftToRight|NSWritingDirectionEmbedding, RLE: NSWritingDirectionRightToLeft|NSWritingDirectionEmbedding, LRO: NSWritingDirectionLeftToRight|NSWritingDirectionOverride, RLO: NSWritingDirectionRightToLeft|NSWritingDirectionOverride,
    
    @available(iOS 6.0, *)
    public let NSVerticalGlyphFormAttributeName: String // An NSNumber containing an integer value.  0 means horizontal text.  1 indicates vertical text.  If not specified, it could follow higher-level vertical orientation settings.  Currently on iOS, it's always horizontal.  The behavior for any other value is undefined.

}

public enum ParagraphAttribute {
    
}

public enum DocumentAttribute {
    
}
