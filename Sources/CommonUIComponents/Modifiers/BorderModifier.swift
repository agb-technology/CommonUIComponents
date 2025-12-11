//
//  BorderModifier.swift
//  CommonUIComponents
//
//  Created by NANG SAN KHAM on 11/25/25.
//

import SwiftUI

/// 用于绘制某一侧边框的 Shape
/// 支持 top / bottom / leading / trailing 四种方向
struct EdgeBorder: Shape {
    /// 边框的厚度
    var width: CGFloat
    /// 要绘制的边（上、下、左、右）
    var edge: Edge
    
    /// 根据不同边创建对应方向的矩形路径
    func path(in rect: CGRect) -> Path {
        var path = Path()
        switch edge {
        case .top:
            // 上边框
            path.addRect(CGRect(x: 0, y: 0, width: rect.width, height: width))
        case .bottom:
            // 下边框
            path.addRect(CGRect(x: 0, y: rect.height - width, width: rect.width, height: width))
        case .leading:
            // 左边框
            path.addRect(CGRect(x: 0, y: 0, width: width, height: rect.height))
        case .trailing:
            // 右边框
            path.addRect(CGRect(x: rect.width - width, y: 0, width: width, height: rect.height))
        }
        return path
    }
}

public extension View {
    /// 为 View 添加指定边的边框效果
    /// - Parameters:
    ///   - width: 边框厚度
    ///   - color: 边框颜色
    ///   - edges: 要绘制边框的边集合（如 [.top, .bottom]）
    /// - Returns: 添加边框后的 View
    func border(width: CGFloat, color: Color, edges: [Edge]) -> some View {
        overlay(
            ForEach(edges, id: \.self) { edge in
                EdgeBorder(width: width, edge: edge)
                    .foregroundColor(color)
            }
        )
    }
}

#Preview {
    VStack(spacing: 30) {
        
        Text("Single Edge")
            .padding(.horizontal, 12)
            .border(width: 4, color: .green, edges: [.leading])
        
        Text("Top + Bottom")
            .padding()
            .border(width: 4, color: .orange, edges: [.top, .bottom])
        
        Text("Left + Right")
            .padding()
            .border(width: 4, color: .pink, edges: [.leading, .trailing])
        
        Text("All Edges")
            .padding()
            .border(width: 4, color: .black, edges: [.top, .bottom, .leading, .trailing])
    }
    .padding()
}
