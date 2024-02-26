//
//  SearchBarView.swift
//  myDictionary
//
//  Created by 권용진 on 2/26/24.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            if !text.isEmpty {
                Button(action: {
                    self.text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                }
                .buttonStyle(PlainButtonStyle())
                .foregroundColor(Color(.systemGray2))
            }
        }
        .padding(.horizontal)
    }
}
