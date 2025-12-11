//
//  DismissKeyboardModifier.swift
//  CommonUIComponents
//
//  Created by NANG SAN KHAM on 11/25/25.
//

import SwiftUI

/// 用于点击视图任意区域隐藏键盘的修饰符
///
/// 该修饰符通过添加一个覆盖整个视图区域的点击手势，在用户点击非输入区域时自动隐藏键盘。
///
/// ## 使用示例
/// ```swift
/// VStack {
///     TextField("输入内容", text: $text)
///     Spacer()
/// }
/// .modifier(DismissKeyboardModifier())
/// ```
///
/// ## 注意事项
/// - 需要确保目标视图有足够的点击区域（可通过添加 Spacer 或设置 frame）
/// - 在包含多个可聚焦元素的复杂布局中表现良好
struct DismissKeyboardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .contentShape(Rectangle())  // 扩展点击区域到整个视图范围
            .onTapGesture {
                hideKeyboard()
            }
    }
    
    /// 隐藏当前第一响应者的私有方法
    private func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}

public extension View {
    
    /// 为视图添加点击隐藏键盘功能的便捷方法
    ///
    /// 通过添加透明点击手势实现以下效果：
    /// - 点击视图任意区域隐藏键盘
    /// - 自动处理手势冲突（不影响其他交互）
    /// - 兼容所有 iOS 输入控件（TextField, TextEditor 等）
    ///
    /// - Returns: 添加了隐藏键盘功能的视图
    func dismissKeyboardOnTap() -> some View {
        self.modifier(DismissKeyboardModifier())
    }
}
