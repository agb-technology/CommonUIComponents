//
//  DefaultEmptyDataView.swift
//  CommonUIComponents
//
//  Created by NANG SAN KHAM on 12/8/25.
//

import SwiftUI

public struct DefaultEmptyDataView: View {
   
    public var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "tray")
                .font(.largeTitle)
                .foregroundColor(.secondary)

            Text("No Data")
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
