//
//  ActivityIndicator.swift
//  CommonUIComponents
//
//  Created by NANG SAN KHAM on 11/25/25.
//

import SwiftUI
import Utilities

public struct ActivityIndicator: View {
    @State private var isAnimating = false
    
    let strokeWidth: CGFloat
    let length: CGFloat
    let indicatorColor: Color
    let backgroundColor: Color
    let size: CGSize
    
    public init(
        strokeWidth: CGFloat = 3,
        length: CGFloat = 0.2,
        indicatorColor: Color = Color.primary,
        backgroundColor: Color = .gray.opacity(0.2),
        size: CGFloat = 40
    ) {
        self.strokeWidth = strokeWidth
        self.length = length
        self.indicatorColor = indicatorColor
        self.backgroundColor = backgroundColor
        self.size = CGSize(width: size, height: size)
    }
    
    private var strokeContent: some ShapeStyle {
        length <= 0.2 ?
        AnyShapeStyle(indicatorColor) :
        AnyShapeStyle(
            AngularGradient(
                gradient: Gradient(stops: [
                    .init(color: .clear, location: 0),
                    .init(color: indicatorColor, location: 0.5), // remove red color
                    .init(color: indicatorColor.vibrant(), location: 1)
                ]),
                center: .center,
                startAngle: .degrees(0),
                endAngle: .degrees(270)
            )
        )
    }
    
    public var body: some View {
        ZStack {
            Circle()
                .stroke(style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
                .foregroundStyle(backgroundColor)
            
            Circle()
                .trim(from: 0, to: length)
                .stroke(
                    strokeContent,
                    style: StrokeStyle(
                        lineWidth: strokeWidth,
                        lineCap: .round,
                        lineJoin: .round
                    )
                )
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .animation(
                    .linear(duration: 1.5).repeatForever(autoreverses: false),
                    value: isAnimating
                )
        }
        .frame(width: size.width, height: size.height)
        .onAppear {
            isAnimating = true
        }
    }
}


#Preview {
    VStack(spacing: 40) {
        ActivityIndicator()
        
        ActivityIndicator(
            length: 0.8,
            indicatorColor: .blue,
            size: 60
        )
        
        ActivityIndicator(
            length: 0.8,
            indicatorColor: .teal,
            size: 50
        )
        
        ActivityIndicator(
            length: 0.8,
            indicatorColor: .green,
            size: 50
        )
        
        ActivityIndicator(
            length: 0.8,
            indicatorColor: .purple,
            size: 50
        )

    }
    .preferredColorScheme(.dark)
}
