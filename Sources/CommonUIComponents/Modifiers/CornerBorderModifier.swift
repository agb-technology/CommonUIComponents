//
//  CornerBorderModifier.swift
//  CommonUIComponents
//
//  Created by NANG SAN KHAM on 11/25/25.
//

import SwiftUI

/// 自定义边角描边 Shape
/// 可在四个角绘制类似「 」的短线边框效果
struct BorderShape: Shape {
    /// 每条角线的长度
    var lineLength: CGFloat
    
    /// 绘制路径
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // 左上角「
        path.move(to: CGPoint(x: rect.minX, y: rect.minY + lineLength))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX + lineLength, y: rect.minY))
        
        // 右上角 「
        path.move(to: CGPoint(x: rect.maxX - lineLength, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + lineLength))
        
        // 左下角 「
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY - lineLength))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX + lineLength, y: rect.maxY))
        
        // 右下角 」
        path.move(to: CGPoint(x: rect.maxX - lineLength, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - lineLength))
        
        return path
    }
}

public extension View {
    /// 为视图添加四角短线边框
    /// - Parameters:
    ///   - lineLength: 每个角线段的长度
    ///   - lineWidth: 描边线的粗细
    ///   - color: 描边颜色
    /// - Returns: 带四角描边效果的 View
    func cornerBorder(
        lineLength: CGFloat = 20,
        lineWidth: CGFloat = 3,
        color: Color = Color.primary
    ) -> some View {
        self.overlay(
            BorderShape(lineLength: lineLength)
                .stroke(color, lineWidth: lineWidth)
        )
    }
}

#Preview {
    Rectangle()
        .fill(Color.clear)
        .frame(width: 250, height: 250)
        .cornerBorder(
            lineLength: 40,
            lineWidth: 4,
            color: Color.red
        )
}
