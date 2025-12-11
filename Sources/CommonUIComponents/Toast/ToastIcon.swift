//
//  ToastIcon.swift
//  CommonUIComponents
//
//  Created by NANG SAN KHAM on 12/8/25.
//

import SwiftUI

/// Toast 图标类型（支持 iOS 16+）
///
/// 用于统一管理 Toast 中的图标来源，支持以下三种情况：
/// - 使用系统 SF Symbols 图标
/// - 使用 App 默认图标（统一样式）
/// - 使用资源文件（来自 App 或 Framework 的 Asset Catalog）
///
/// > 注意：
/// > - 若在 Framework 或 Swift Package 内使用，请传入 `.module` 作为 bundle；
/// > - 若在 App 内使用，则可传入 `.main`。
public enum ToastIcon {
    /// 使用系统 SF Symbols 图标
    case system(name: String)
    
    /// App 默认图标（用于通用提示场景）
    case app
    
    /// 使用 Asset Catalog 中的图片（可来自 App 或 Framework）
    /// - Parameters:
    ///   - name: 图片名称
    ///   - bundle: 图片所在的资源包（默认可为 `nil`）
    case asset(name: String, bundle: Bundle? = nil)
    
    /// 根据枚举类型返回对应的 `SwiftUI.Image`
    ///
    /// 内部自动处理 iOS 17 的 `ImageResource` 安全加载机制。
    public var image: Image {
        switch self {
        case .system(let name):
            return Image(systemName: name)
            
        case .app:
            return Image(systemName: "iphone.crop.circle")
            
        case let .asset(name, bundle):
            if let bundle {
                if #available(iOS 17.0, *) {
                    // iOS17+ 使用类型安全的 ImageResource 方式加载
                    // 若资源名不存在，会在运行时报错，因此保持谨慎使用
                    let resource = ImageResource(name: name, bundle: bundle)
                    return Image(resource)
                } else {
                    // iOS16 及以下使用传统字符串方式加载资源图片
                    return Image(name, bundle: bundle)
                }
            } else {
                // 若未传入 bundle，则返回默认图标，防止崩溃
                return Image(systemName: "iphone.crop.circle")
            }
        }
    }
}
