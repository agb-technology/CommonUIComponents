//
//  DefaultErrorView.swift
//  CommonUIComponents
//
//  Created by NANG SAN KHAM on 12/8/25.
//

import SwiftUI

/// 默认错误视图
public struct DefaultErrorView: View {
    let message: LocalizedStringResource?
    let error: Error?
    let retry: () -> Void
    
    public var body: some View {
        VStack(spacing: 16) {
            Label("Error", systemImage: "xmark.octagon")
                .foregroundColor(.red)
            
            if let message {
                Text(message)
            } else if let error {
                Text(String(describing: error))
            }
            
            Button("Retry", action: retry)
                .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}


#Preview {
    DefaultErrorView(
        message: nil, // nil, "localized.string.resource"
        error: URLError(.badServerResponse), // nil, CancellationError()
    ) {
        print("do something")
    }
}
