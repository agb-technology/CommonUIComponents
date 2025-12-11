//
//  CollectionDataStateView2.swift
//  CommonUIComponents
//
//  Created by NANG SAN KHAM on 12/9/25.
//

import SwiftUI
import APIClient

public struct CollectionDataStateView2<Item: Identifiable, LoadingView: View, EmptyDataView: View, ErrorView: View, Content: View>: View {
    
    @Binding var state: CollectionDataState<Item>
    
    var autoLoad: Bool
    var enableRefresh: Bool
    
    // 支持分页：根据当前已有数量请求下一页
    let fetch: (_ currentCount: Int) async throws -> [Item]
    
    @ViewBuilder var loadingView: () -> LoadingView
    @ViewBuilder var emptyView: () -> EmptyDataView
    @ViewBuilder var errorView: (
        LocalizedStringResource?,
        Error?,
        @escaping () -> Void
    ) -> ErrorView
    @ViewBuilder var content: ([Item]) -> Content
    
    public init(
        state: Binding<CollectionDataState<Item>>,
        autoLoad: Bool = true,
        enableRefresh: Bool = true,
        fetch: @escaping (_ currentCount: Int) async throws -> [Item],
        @ViewBuilder loadingView: @escaping () -> LoadingView,
        @ViewBuilder emptyView: @escaping () -> EmptyDataView,
        @ViewBuilder errorView: @escaping (
            LocalizedStringResource?,
            Error?,
            @escaping () -> Void
        ) -> ErrorView,
        @ViewBuilder content: @escaping ([Item]) -> Content
    ) {
        self._state = state
        self.autoLoad = autoLoad
        self.enableRefresh = enableRefresh
        self.fetch = fetch
        self.loadingView = loadingView
        self.emptyView = emptyView
        self.errorView = errorView
        self.content = content
    }
    
    public var body: some View {
        main
            .task { if autoLoad { await initialLoad() } }
            .modifier(
                RefreshModifier(enabled: enableRefresh) {
                    await performFetch(reset: false)
                }
            )
    }
    
    @ViewBuilder
    private var main: some View {
        switch state {
        case .idle, .loading:
            loadingView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        case .data(let items):
            LazyVStack {
                content(items)
                    .onAppear {
                        // 当最后一个 item 出现时加载下一页
                        if let last = items.last {
                            Task { await loadNextPageIfNeeded(lastItem: last) }
                        }
                    }
            }
            
        case .empty:
            emptyView()
            
        case .noMore:
            content(state.items)
            
        case .failure(let error):
            errorView(nil, error, retry)
            
        case .error(let msg):
            errorView(msg, nil, retry)
        }
    }
    
    private func retry() { Task { await performFetch(reset: true) } }
    
    private func initialLoad() async {
        guard case .idle = state else { return }
        await performFetch(reset: true)
    }
    
    private func performFetch(reset: Bool = false) async {
        if reset { state = .loading }
        do {
            let currentCount = reset ? 0 : state.items.count
            print(">>>[CollectionStateDataView][performFetch] currentCount: \(currentCount)")
            let items = try await fetch(currentCount)
            
            if reset {
                state = items.isEmpty ? .empty : .data(items)
            } else {
                let combined = state.items + items
                print(">>> combinedCount: \(combined.count)")
                state = items.isEmpty ? .noMore : .data(combined)
            }
        } catch let apiError as APIClientError {
            let errorMessage: String = apiError.errorDescription ?? ""
            print("[CollectionDataStateView2][API-ERR][performFetch] ❌ \(errorMessage)")
            if apiError.code == .unauthorized {
                state = .error(ErrorL10n.unauthorized)
            } else {
                state = .error(ErrorL10n.general)
            }
        } catch {
            let errorMessage: String = error.localizedDescription
            print("[CollectionDataStateView2][ERR][performFetch] ❌ \(errorMessage)")
            state = .error(ErrorL10n.general)
        }
    }
    
    /// 检查是否需要加载下一页
    private func loadNextPageIfNeeded(lastItem: Item) async {
        // 仅在当前是数据状态且不在加载中时尝试加载下一页
        guard state.isLoading == false else { return }
        guard case .data(let items) = state else { return }
        // 如果已经没有更多数据，直接返回
        // 这里不需要切换到 .noMore 的匹配，因为上面已经限定 .data
        guard let last = items.last, last.id == lastItem.id else { return } // 只在最后一个 item 出现时触发
        await performFetch(reset: false)
    }
}

public extension CollectionDataStateView2
where LoadingView == DefaultLoadingView,
      EmptyDataView == DefaultEmptyDataView,
      ErrorView == DefaultErrorView
{
    init(
        state: Binding<CollectionDataState<Item>>,
        autoLoad: Bool = true,
        enableRefresh: Bool = true,
        fetch: @escaping (_ currentCount: Int) async throws -> [Item],
        @ViewBuilder content: @escaping ([Item]) -> Content
    ) {
        self.init(
            state: state,
            autoLoad: autoLoad,
            enableRefresh: enableRefresh,
            fetch: fetch,
            loadingView: { DefaultLoadingView() },
            emptyView: { DefaultEmptyDataView() },
            errorView: { msg, err, retry in
                DefaultErrorView(message: msg, error: err, retry: retry)
            },
            content: content
        )
    }
}
