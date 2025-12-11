//
//  CornerRadiusModifier.swift
//  CommonUIComponents
//
//  Created by NANG SAN KHAM on 11/25/25.
//

import SwiftUI

/// 自定义圆角 Shape，用于指定某几个角需要圆角
struct RoundedCornerShape: Shape {
    /// 圆角半径
    var radius: CGFloat
    
    /// 需要设置圆角的角（例如：.topLeft, .topRight）
    var corners: UIRectCorner
    
    /// 根据指定的圆角配置，绘制路径
    func path(in rect: CGRect) -> Path {
        // 使用 UIBezierPath 创建指定圆角的路径
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        // 转换为 SwiftUI 的 Path
        return Path(path.cgPath)
    }
}

public extension View {
    /// 为 View 设置指定角的圆角
    /// - Parameters:
    ///   - radius: 圆角半径
    ///   - corners: 需要设置圆角的角
    /// - Returns: 带圆角裁剪效果的 View
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCornerShape(radius: radius, corners: corners))
    }
}

#Preview {
    Rectangle()
        .fill(Color.red)
        .frame(width: .infinity, height: 180)
        // 只设置上方两个角为圆角
        .cornerRadius(40, corners: [.topLeft, .topRight])
        .padding()
}
