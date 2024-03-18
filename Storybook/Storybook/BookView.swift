//
//  BookView.swift
//  Storybook
//
//  Created by Anup D'Souza on 21/02/24.
//

import SwiftUI

struct BookView: View {
    @State var book: Storybook
    
    var body: some View {
        VStack {
            if let coverImage = book.images.first {
                Image(uiImage: coverImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 260, height: 380)
                    .overlay(alignment: .bottom) {
                        Text(book.title)
                            .font(.title).bold()
                            .frame(width: 250)
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 5)
                            .padding(.bottom, 5)
                            .background {
                                Rectangle()
                                    .fill(.black.opacity(0.8))
                            }
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.white, lineWidth: 0.5)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 20.0))
                    .containerRelativeFrame(.horizontal)
            }
        }
        .scrollTransition { content, phase in
            content
                .scaleEffect(phase.isIdentity ? 1 : 0.8)
        }
        .background {
            Color.black
                .edgesIgnoringSafeArea(.all)
        }
    }
}
