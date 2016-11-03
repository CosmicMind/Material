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

@objc(InterimSpacePreset)
public enum InterimSpacePreset: Int {
    case none
    case interimSpace1
    case interimSpace2
    case interimSpace3
    case interimSpace4
    case interimSpace5
    case interimSpace6
    case interimSpace7
    case interimSpace8
    case interimSpace9
    case interimSpace10
    case interimSpace11
    case interimSpace12
    case interimSpace13
    case interimSpace14
    case interimSpace15
    case interimSpace16
    case interimSpace17
    case interimSpace18
}

public typealias InterimSpace = CGFloat

/// Converts the InterimSpacePreset enum to an InterimSpace value.
public func InterimSpacePresetToValue(preset: InterimSpacePreset) -> InterimSpace {
    switch preset {
    case .none:
        return 0
    case .interimSpace1:
        return 1
    case .interimSpace2:
        return 2
    case .interimSpace3:
        return 4
    case .interimSpace4:
        return 8
    case .interimSpace5:
        return 12
    case .interimSpace6:
        return 16
    case .interimSpace7:
        return 20
    case .interimSpace8:
        return 24
    case .interimSpace9:
        return 28
    case .interimSpace10:
        return 32
    case .interimSpace11:
        return 36
    case .interimSpace12:
        return 40
    case .interimSpace13:
        return 44
    case .interimSpace14:
        return 48
    case .interimSpace15:
        return 52
    case .interimSpace16:
        return 56
    case .interimSpace17:
        return 60
    case .interimSpace18:
        return 64
    }
}
