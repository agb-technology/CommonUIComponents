//
//  BasicDataState.swift
//  CommonUIComponents
//
//  Created by NANG SAN KHAM on 12/4/25.
//

import SwiftUI

/// 单对象状态
public enum BasicDataState<Value> {
    case idle
    case loading
    case success(Value)
    case failure(Error)
    case error(LocalizedStringResource) // 加载出错（带本地化错误描述）
    
    public var value: Value? {
        if case let .success(v) = self { return v }
        return nil
    }
    
    public var typeName: String {
        switch self {
        case .idle: "idle"
        case .loading: "loading"
        case .success: "success"
        case .failure: "failure"
        case .error: "error"
        }
    }
}

extension BasicDataState: DataStateProtocol {
    public var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }
    
    public var isError: Bool {
        switch self {
        case .failure, .error:
            return true
        default:
            return false
        }
    }
    
    /// 获取错误信息（若有）
    public var errorMessage: LocalizedStringResource? {
        if case let .error(message) = self { return message }
        return nil
    }
    
    /// 创建带本地化字符串 key 的错误状态
    public static func error(_ key: String, bundle: Bundle = .main) -> Self {
        .error(LocalizedStringResource(String.LocalizationValue(key), bundle: bundle))
    }
    
    /// 创建带原始文本（verbatim）的错误状态（不会去查 Localizable.strings）
    public static func verbatim(_ text: String) -> Self {
        .error(LocalizedStringResource(stringLiteral: text))
    }
}
