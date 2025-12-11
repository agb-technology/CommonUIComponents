//
//  BasicDataStateView.swift
//  CommonUIComponents
//
//  Created by NANG SAN KHAM on 12/8/25.
//

import SwiftUI
import APIClient

public struct BasicDataStateView<Value, LoadingView: View, ErrorView: View, Content: View>: View {
    
    @Binding var state: BasicDataState<Value>
    
    var autoLoad: Bool
    var enableRefresh: Bool
    
    let fetch: () async throws -> Value
    
    @ViewBuilder var loadingView: () -> LoadingView
    @ViewBuilder var errorView: (
        LocalizedStringResource?,
        Error?,
        @escaping () -> Void
    ) -> ErrorView
    @ViewBuilder var content: (Value) -> Content
 
    public init(
        state: Binding<BasicDataState<Value>>,
        autoLoad: Bool = true,
        enableRefresh: Bool = true,
        fetch: @escaping () async throws -> Value,
        @ViewBuilder loadingView: @escaping () -> LoadingView,
        @ViewBuilder errorView: @escaping (
            LocalizedStringResource?,
            Error?,
            @escaping ()  -> Void
        ) -> ErrorView,
        @ViewBuilder content: @escaping (Value) -> Content
    ) {
        self._state = state
        self.autoLoad = autoLoad
        self.enableRefresh = enableRefresh
        self.fetch = fetch
        self.loadingView = loadingView
        self.errorView = errorView
        self.content = content
    }
    
    public var body: some View {
        main
            .task { if autoLoad { await initialLoad() }}
            .modifier(
                RefreshModifier(enabled: enableRefresh) { await performFetch(showLoading: false) }
            )
    }
    
    @ViewBuilder
    private var main: some View {
        switch state {
        case .idle, .loading:
            loadingView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        case .success(let value):
            content(value)
            
        case .failure(let err):
            errorView(nil, err, retry)
            
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
            let v = try await fetch()
            state = .success(v)
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

public extension BasicDataStateView
where LoadingView == DefaultLoadingView,
        ErrorView == DefaultErrorView
{
    init(
        state: Binding<BasicDataState<Value>>,
        autoLoad: Bool = true,
        enableRefresh: Bool = true,
        fetch: @escaping () async throws -> Value,
        @ViewBuilder content: @escaping (Value) -> Content
    ) {
        self.init(
            state: state,
            autoLoad: autoLoad,
            enableRefresh: enableRefresh,
            fetch: fetch,
            loadingView: { DefaultLoadingView() },
            errorView: { msg, err, retry in
                DefaultErrorView(message: msg, error: err, retry: retry)
            },
            content: content
        )
    }
}

fileprivate struct BasicDataStateViewDemo: View {
    @State var state: BasicDataState<String> = .idle
    @State var secondsDelay: Int = 3
    
    var body: some View {
        VStack {
            BasicDataStateView(
                state: $state,
                fetch: {
                    try await Task.sleep(for: .seconds(secondsDelay))
                    return "Sample Text"
                }
            ) { text in
                Text(text)
                    .font(.title)
                    .bold()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Spacer()
            
            VStack(spacing: 24) {
                Text("\(state.typeName)")
                    .foregroundColor(.white)
                
                HStack {
                    Button("Idle", action: { set(.idle) })
                    Button("Loading", action: { set(.loading) })
                    Button("Success", action: { set(.success("Success Data Text")) })
                    Button("Failure", action: { set(.failure(CancellationError())) })
                    Button("Error", action: { set(.error("localized.error")) })
                }
                .buttonStyle(.borderedProminent)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .background(Color.black.opacity(0.6))
        }
    }
    
    func set(_ newState: BasicDataState<String>) {
        withAnimation { state = newState }
    }
}

#Preview {
    BasicDataStateViewDemo()
}
