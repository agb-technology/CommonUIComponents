//
//  ErrorL10n.swift
//  CommonUIComponents
//
//  Created by NANG SAN KHAM on 12/8/25.
//

import Foundation
import SwiftUI

public enum ErrorL10n {
    public static let general = ErrorL10n.localized("error.general")
    public static let network = ErrorL10n.localized("error.general.network")
    public static let unauthorized = ErrorL10n.localized("error.general.unauthorized")
    public static let server = ErrorL10n.localized("error.general.server")
    public static let timeout = ErrorL10n.localized("error.general.timeout")
}

// MARK: - Helper

internal extension ErrorL10n {
    /// 从当前 Swift Package 的 bundle 中加载本地化文本
    ///
    /// 用于 SwiftUI `Text()`，例如：
    /// ```swift
    /// Text(ErrorL10n.general)
    /// ```
    ///
    /// - Parameter key: Localizable.strings 中的 key
    /// - Returns: LocalizedStringResource，可直接传给 Text()
    static func localized(_ key: String) -> LocalizedStringResource {
        LocalizedStringResource(String.LocalizationValue(key), bundle: .module)
    }
}

// MARK: - Preview

@available(iOS 17, *)
#Preview {
    
    @Previewable @AppStorage("appLanguage")
    var languageCode: String = "en"
    
    VStack(spacing: 16) {
        
        Spacer()
        
        Group {
            Text(ErrorL10n.general)
                .lineSpacing(6)
            Text(ErrorL10n.network)
                .lineSpacing(6)
            Text(ErrorL10n.unauthorized)
                .lineSpacing(6)
            Text(ErrorL10n.server)
                .lineSpacing(6)
            Text(ErrorL10n.timeout)
                .lineSpacing(6)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        
        Spacer()
        
        VStack(spacing: 14) {
            HStack {
                Text(verbatim: languageCode)
                    .foregroundStyle(Color.orange)
                
                Text(Locale.current.identifier)
                    .foregroundStyle(Color.purple)
            }
            
            HStack {
                Button("English") {
                    languageCode = "en"
                }
                
                Button("Chinese") {
                    languageCode = "zh"
                }
                
                Button("Burmese") {
                    languageCode = "my"
                }
            }
        }
    }
    .padding(.horizontal, 24)
    .padding(.vertical, 48)
    .environment(\.locale, Locale(identifier: languageCode))
}
