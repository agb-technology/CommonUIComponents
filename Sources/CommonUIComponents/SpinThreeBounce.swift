//
//  SpinThreeBounce.swift
//  CommonUIComponents
//
//  Created by NANG SAN KHAM on 11/25/25.
//

import SwiftUI

public struct SpinThreeBounce: View {
    let color: Color
    let size: CGFloat
    let duration: Double
    
    public init(color: Color = .white, size: CGFloat = 15, duration: Double = 1.4) {
        self.color = color
        self.size = size
        self.duration = duration
    }
    
    public var body: some View {
        ZStack {
            TimelineView(.animation) { timeline in
                let elapsed = timeline.date.timeIntervalSinceReferenceDate
                HStack(spacing: size * 0.2) {
                    ForEach(0..<3, id: \.self) { i in
                        Circle()
                            .frame(width: size * 0.5, height: size * 0.5)
                            .foregroundColor(color)
                            .scaleEffect(scale(for: elapsed, index: i))
                            .opacity(opacity(for: elapsed, index: i)) // 透明度动画
                    }
                }
                .frame(width: size * 2, height: size)
            }
        }
    }
    
    private func scale(for elapsed: TimeInterval, index: Int) -> CGFloat {
        let delay = Double(index) * (duration * 0.2)
        let time = elapsed.truncatingRemainder(dividingBy: duration) - delay
        let normalized = max(0, min(1, time / (duration * 0.5))) // 限制范围 0~1
        return 0.3 + (1 - 0.3) * sin(normalized * .pi) // 平滑缩放
    }
    
    private func opacity(for elapsed: TimeInterval, index: Int) -> Double {
        let scaleValue = scale(for: elapsed, index: index)
        return max(0, min(1, (scaleValue - 0.3) / (1 - 0.3))) // 0.3时完全透明，1.0时完全可见
    }
}


#Preview {
    SpinThreeBounce(color: Color.red, size: 50, duration: 1.4)
}
