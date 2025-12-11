//
//  ToastMessage.swift
//  CommonUIComponents
//
//  Created by NANG SAN KHAM on 12/8/25.
//

import SwiftUI

public enum ToastMessage {
    case plain(String, style: ToastStyle = .none)
    case localized(LocalizedStringResource, style: ToastStyle = .none)
    
    public var style: ToastStyle {
        switch self {
        case .plain(_, let style): return style
        case .localized(_, let style): return style
        }
    }
    
    public func toText() -> Text {
        switch self {
        case .plain(let string, _):
            return Text(string)
        case .localized(let localized, _):
            return Text(localized)
        }
    }
}
