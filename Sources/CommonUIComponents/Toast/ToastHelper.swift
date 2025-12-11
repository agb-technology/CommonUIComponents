//
//  ToastHelper.swift
//  CommonUIComponents
//
//  Created by NANG SAN KHAM on 12/8/25.
//

import Foundation

/// Toast 提示助手类 - Combine 与 Swift Concurrency 混合架构范例
///
/// **设计模式**：单例模式 + 观察者模式 + 异步编程
///
/// ## 技术架构
/// - **Combine**：负责状态管理和数据流（响应式编程）
/// - **Swift Concurrency**：负责异步任务执行和定时控制（结构化并发）
/// - **@MainActor**：确保所有操作在主线程执行，保障线程安全
///
/// ## @MainActor作用
/// - **线程安全**：强制所有属性和方法都在主线程执行，防止多线程竞态条件
/// - **线程安全**：强制所有属性和方法都在主线程执行，防止多线程竞态条件
/// - **UI 保障**：确保 Combine 的状态更新安全触发 SwiftUI 视图刷新，避免 UI 更新在后台线程
/// - **异步安全**：保证 Swift Concurrency 异步任务完成后能够安全更新 UI 状态
/// - **代码简化**：自动处理线程调度，避免手动使用 DispatchQueue.main.async
/// - **编译检查**：编译器静态检查，防止在后台线程误操作 UI 相关状态
///
/// ## 使用示例
/// ```swift
/// // 显示一个信息提示 Toast，3秒后自动消失
/// ToastHelper.shared.showToast(.plain("操作成功", style: .success))
///
/// // 手动隐藏当前显示的 Toast
/// ToastHelper.shared.dismiss()
/// ```
@MainActor
public final class ToastHelper: ObservableObject {
    
    // 单例模式
    public static let shared = ToastHelper()
    
    // Combine 发布者:
    // `@Published`: 当值改变时自动通知所有订阅者（SwiftUI 视图）
    // `private(set)`:  外部只读，内部可写，确保状态变更的可控性
    @Published public private(set) var isPresented: Bool = false
    @Published public private(set) var toastMessage: ToastMessage = .plain("", style: .none)
    @Published public private(set) var position: ToastPosition = .bottom
    
    /// Swift Concurrency：当前活动的异步任务
    /// - 用于管理自动隐藏的延时任务
    /// - 使用 Task 而不是 Combine 的 AnyCancellable 来获得更好的取消机制
    private var currentTask: Task<Void, Never>?
    
    private init() {}
    
    /// 显示 Toast 提示
    /// - Parameters:
    ///   - message: Toast 消息内容（包含样式）
    ///   - duration: 显示持续时间，默认 3.0 秒
    ///   - position: 显示位置，默认底部
    ///
    /// Combine 负责的部分：
    ///   - 更新 @Published 属性，触发 UI 更新
    ///   - 状态管理：isPresented, toastMessage, position
    ///
    /// Swift Concurrency 负责的部分：
    ///   - 使用 Task 创建异步任务
    ///   - 使用 Task.sleep 实现精确的延时
    ///   - 使用 Task.isCancelled 检查任务取消状态
    ///   - 结构化并发：自动管理任务生命周期
    public func showToast(
        _ message: ToastMessage,
        duration: TimeInterval = 3.0,
        position: ToastPosition = .bottom
    ) {
        // 取消之前可能还在运行的异步任务
        currentTask?.cancel()
        
        // Combine 状态更新：触发 UI 重新渲染
        self.toastMessage = message
        self.position = position
        self.isPresented = true
        
        // 创建新的异步任务来处理自动隐藏
        currentTask = Task {
            // 等待指定时间
            try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
            
            // 检查任务是否被取消(防止在任务取消后仍然执行隐藏操作)
            guard !Task.isCancelled else { return }
            
            // Combine 状态更新：隐藏 Toast
            isPresented = false
        }
    }
    
    /// 手动取消并隐藏当前显示的 Toast
    ///
    /// Swift Concurrency 负责的部分：
    ///   - 取消异步任务，防止不必要的隐藏操作
    ///
    /// Combine 负责的部分：
    ///   - 立即更新 UI 状态，隐藏 Toast
    public func dismiss() {
        currentTask?.cancel() // 取消异步任务
        isPresented = false  // 立即隐藏 toast
    }
    
    // 预览支持
    public static var preview: ToastHelper {
        let helper = ToastHelper()
        helper.showToast(.plain("Preview message", style: .info))
        return helper
    }
}