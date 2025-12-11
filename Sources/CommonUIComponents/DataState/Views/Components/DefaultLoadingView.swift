//
//  DefaultLoadingView.swift
//  CommonUIComponents
//
//  Created by NANG SAN KHAM on 12/8/25.
//

import SwiftUI

/// 默认加载中视图
public struct DefaultLoadingView: View {
    public init() {}
    
    public var body: some View {
        ActivityIndicator(indicatorColor: .accentColor)
    }
}

#Preview {
    DefaultLoadingView()
}
