//
//  RefreshModifier.swift
//  CommonUIComponents
//
//  Created by NANG SAN KHAM on 12/8/25.
//

import SwiftUI

struct RefreshModifier: ViewModifier {
    let enabled: Bool
    let action: () async -> Void
    
    @ViewBuilder
    func body(content: Content) -> some View {
        if enabled {
            content.refreshable { await action() }
        } else {
            content
        }
    }
}
