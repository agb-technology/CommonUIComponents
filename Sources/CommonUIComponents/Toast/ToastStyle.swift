//
//  ToastStyle.swift
//  CommonUIComponents
//
//  Created by NANG SAN KHAM on 12/8/25.
//

import SwiftUI

public enum ToastStyle {
    case none
    case info
    case success
    case error
    case warning
    case custom(color: Color, icon: ToastIcon?)
    
    public var icon: ToastIcon? {
        switch self {
        case .none:
            return nil
        case .info:
            return .system(name: "info.circle") // 􀅴
        case .success:
            return .system(name: "checkmark.circle") // 􀁢
        case .error:
            return .system(name: "xmark.circle") // 􀁠
        case .warning:
            return .system(name: "exclamationmark.triangle") // 􀇾
        case .custom(_, let icon):
            return icon
        }
    }
    
    public var backgroundColor: Color {
        switch self {
        case .none: return .black.opacity(0.85)
        case .info: return .black.opacity(0.85)
        case .success: return .green.opacity(0.85)
        case .error: return .red.opacity(0.85)
        case .warning: return .orange.opacity(0.85)
        case .custom(let color, _): return color
        }
    }
}

public extension ToastStyle {
    /// 创建一个自定义样式，默认使用 `.black.opacity(0.85)` 背景
    static func custom(icon: ToastIcon?) -> ToastStyle {
        .custom(color: .black.opacity(0.85), icon: icon)
    }
}

