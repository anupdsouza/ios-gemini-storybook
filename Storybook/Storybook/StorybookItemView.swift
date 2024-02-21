//
//  StorybookItemView.swift
//  Storybook
//
//  Created by Anup D'Souza on 21/02/24.
//

import SwiftUI

struct StorybookItemView: View {
    @State var item: Storybook?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                Image(item!.coverImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 200)

            }
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.white, lineWidth: 0.5)
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))

            Text(item!.title)
                .frame(height: 50)
                .lineLimit(1)
                .shadow(color: .black, radius: 2, x: 1, y: 1)
        }
    }
}

#Preview {
    StorybookItemView()
}
