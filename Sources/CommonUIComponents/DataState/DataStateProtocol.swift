//
//  DataStateProtocol.swift
//  CommonUIComponents
//
//  Created by NANG SAN KHAM on 12/4/25.
//

// 统一协议
public protocol DataStateProtocol {
    var isLoading: Bool { get }
    var isError: Bool { get }
}
