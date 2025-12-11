//
//  ScreenSizeModifier.swift
//  CommonUIComponents
//
//  Created by NANG SAN KHAM on 11/25/25.
//

import SwiftUI

// 1. 定义自定义 EnvironmentKey
private struct ScreenSizeKey: EnvironmentKey {
    static let defaultValue: CGSize = .zero
}

// 2. 扩展 EnvironmentValues，添加 screenSize 属性
public extension EnvironmentValues {
    var screenSize: CGSize {
        get { self[ScreenSizeKey.self] }
        set { self[ScreenSizeKey.self] = newValue }
    }
}

// 3. 定义一个 ViewModifier，通过 GeometryReader 获取实际尺寸，并注入环境变量
public struct ScreenSizeModifier: ViewModifier {
    public func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .environment(\.screenSize, geometry.size) // 将获取的尺寸传递到 environment 中
        }
    }
}

// 4. 为 View 扩展，提供一个便捷方法使用这个修改器
public extension View {
    func withScreenSize() -> some View {
        self.modifier(ScreenSizeModifier())
    }
}
