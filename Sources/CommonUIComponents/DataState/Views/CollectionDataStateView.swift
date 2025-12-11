//
//  CollectionDataStateView.swift
//  CommonUIComponents
//
//  Created by NANG SAN KHAM on 12/8/25.
//

import SwiftUI
import APIClient

public struct CollectionDataStateView<Item, LoadingView: View, EmptyDataView: View, ErrorView: View, Content: View>: View {
    
    @Binding var state: CollectionDataState<Item>
    
    var autoLoad: Bool
    var enableRefresh: Bool
    
    let fetch: () async throws -> [Item]
    
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
        fetch: @escaping () async throws -> [Item],
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
            .task { if autoLoad { await initialLoad() }}
            .modifier(
                RefreshModifier(enabled: enableRefresh) {
                    await performFetch(showLoading: false)
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
            content(items)
            
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
    
    private func retry() { Task { await performFetch() } }
    
    private func initialLoad() async {
        guard case .idle = state else { return }
        await performFetch()
    }
    
    private func performFetch(showLoading: Bool = true) async {
        if showLoading { state = .loading }
        do {
            let items = try await fetch()
            state = items.isEmpty ? .empty : .data(items)
        } catch let apiError as APIClientError {
            // 专门捕获 API 层错误
            let errorMessage: String = apiError.errorDescription ?? ""
            print("[CollectionDataStateView][API-ERR][performFetch] ❌ \(errorMessage)")
            if apiError.code == .unauthorized {
                state = .error(ErrorL10n.unauthorized)
            } else {
                state = .error(ErrorL10n.general)
            }
        } catch {
            // 其他未知错误
            let errorMessage: String = error.localizedDescription
            print("[CollectionDataStateView][ERR][performFetch] ❌ \(errorMessage)")
            state = .error(ErrorL10n.general)
        }
    }
}

public extension CollectionDataStateView
where LoadingView == DefaultLoadingView,
      EmptyDataView == DefaultEmptyDataView,
      ErrorView == DefaultErrorView
{
    init(
        state: Binding<CollectionDataState<Item>>,
        autoLoad: Bool = true,
        enableRefresh: Bool = true,
        fetch: @escaping () async throws -> [Item],
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
