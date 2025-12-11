//
//  SimpleDataState.swift
//  CommonUIComponents
//
//  Created by NANG SAN KHAM on 12/9/25.
//

import Foundation

public enum SimpleDataState: Equatable {
    case idle            // 初始状态
    case loading         // 正在加载
    case loaded          // 加载完成
    case empty           // 数据为空
    case noMore          // 没有更多数据
    case error(LocalizedStringResource) // 加载出错（带本地化错误描述）
}

extension SimpleDataState: DataStateProtocol {
    /// 判断当前是否为加载中状态
    public var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }
    
    /// 判断当前是否为错误状态
    public var isError: Bool {
        if case .error = self { return true }
        return false
    }
    
    /// 获取错误信息（若有）
    public var errorMessage: LocalizedStringResource? {
        if case let .error(message) = self { return message }
        return nil
    }
    
    /// 创建带本地化字符串 key 的错误状态
    public static func error(_ key: String, bundle: Bundle?) -> Self {
        .error(LocalizedStringResource(String.LocalizationValue(key), bundle: bundle ?? .module))
    }
    
    /// 创建带原始文本（verbatim）的错误状态（不会去查 Localizable.strings）
    public static func verbatim(_ text: String) -> Self {
        .error(LocalizedStringResource(stringLiteral: text))
    }
}
