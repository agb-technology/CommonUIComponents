//
//  NetworkImage.swift
//  CommonUIComponents
//
//  Created by NANG SAN KHAM on 11/25/25.
//

import SwiftUI
import Kingfisher


public struct NetworkImage: View {
    
    let url: String
    let contentMode: SwiftUI.ContentMode
    
    public init(
        url: String,
        contentMode: SwiftUI.ContentMode = SwiftUI.ContentMode.fill
    ) {
        self.url = url
        self.contentMode = contentMode
    }
    
    public var body: some View {
        Rectangle()
            .opacity(0)
            .overlay(
                KingfisherImageLoader(url: url, contentMode: contentMode)
                    .allowsHitTesting(false)
            )
            .clipped()
    }
}

private struct KingfisherImageLoader: View {
    
    let url: String
    let contentMode: SwiftUI.ContentMode
    
    var body: some View {
        KFImage.url(URL(string: url))
            .placeholder {
                Color.gray.opacity(0.2)
            }
            .resizable()
            .aspectRatio(contentMode: contentMode)
    }
}

#Preview {
    NetworkImage(url: "https://picsum.photos/id/101/200/300", contentMode: .fill)
        .frame(width:100, height: 300)
}
