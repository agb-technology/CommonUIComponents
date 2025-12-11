//
//  WormPageIndicator.swift
//  CommonUIComponents
//
//  Created by NANG SAN KHAM on 11/25/25.
//

import SwiftUI

public struct WormPageIndicator: View {
    @Binding var progress: CGFloat  // 当前进度值（0 到 totalPages-1）
    let totalPages: Int             // 总页数
    var dotSize: CGFloat = 8        // 每个指示点的大小
    var spacing: CGFloat = 8        // 点之间的间距
    var activeColor: Color = .blue  // 活动指示器的颜色
    var inactiveColor: Color = .gray.opacity(0.5) // 非活动点的颜色
    
    public init(
        progress: Binding<CGFloat>,
        totalPages: Int,
        dotSize: CGFloat = 8,
        spacing: CGFloat = 8,
        activeColor: Color = .blue,
        inactiveColor: Color = .gray.opacity(0.5)
    ) {
        self._progress = progress
        self.totalPages = totalPages
        self.dotSize = dotSize
        self.spacing = spacing
        self.activeColor = activeColor
        self.inactiveColor = inactiveColor
    }
    
    // 计算属性：最大有效进度值
    private var maxProgress: CGFloat {
        CGFloat(totalPages - 1)
    }
    
    public var body: some View {
        // 水平排列的点
        HStack(spacing: spacing) {
            ForEach(0..<totalPages, id: \.self) { _ in
                Capsule()
                    .fill(inactiveColor)
                    .frame(width: dotSize, height: dotSize)
            }
        }
        .overlay(
            GeometryReader { proxy in
                // 计算所有点和间距的总宽度
                let totalWidth = totalPagesWidth
                // 计算起始 X 位置以使点居中
                let startX = (proxy.size.width - totalWidth) / 2
                // 每个步骤的宽度（点 + 间距）
                let stepWidth = dotSize + spacing
                
                // 计算当前左侧索引和过渡百分比
                let leftIndex = Int(floor(progress))
                let transitionPercent = progress - CGFloat(leftIndex)
                
                // 计算左侧边缘位置（带延迟动画）
                let leftEdge = startX + edgeCalculation(
                    index: leftIndex,
                    percent: transitionPercent,
                    stepWidth: stepWidth,
                    isLeading: true
                )
                
                // 计算右侧边缘位置（带加速动画）
                let rightEdge = startX + edgeCalculation(
                    index: leftIndex,
                    percent: transitionPercent,
                    stepWidth: stepWidth,
                    isLeading: false
                )
                
                // 活动指示器胶囊形状
                Capsule()
                    .fill(activeColor)
                    .frame(width: rightEdge - leftEdge, height: dotSize)
                    .offset(x: leftEdge)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: progress)
            }
        )
    }
    
    // MARK: - 辅助计算方法
    
    // 计算所有点（包括间距）的总宽度
    private var totalPagesWidth: CGFloat {
        CGFloat(totalPages) * dotSize + CGFloat(totalPages - 1) * spacing
    }
    
    // 根据索引和过渡百分比计算边缘位置
    private func edgeCalculation(index: Int, percent: CGFloat, stepWidth: CGFloat, isLeading: Bool) -> CGFloat {
        let basePosition = CGFloat(index) * stepWidth
        
        if isLeading {
            // 对前缘应用延迟动画
            let delayedPercent = max(percent - 0.3, 0) / 0.7
            return basePosition + (delayedPercent.clamped(to: 0...1) * stepWidth)
        } else {
            // 对后缘应用加速动画
            let acceleratedPercent = min(percent / 0.5, 1)
            return basePosition + dotSize + (acceleratedPercent * stepWidth)
        }
    }
}

// MARK: - 扩展用于限制数值范围

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        min(max(self, limits.lowerBound), limits.upperBound)
    }
}
