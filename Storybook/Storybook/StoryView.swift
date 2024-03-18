//
//  StoryView.swift
//  Storybook
//
//  Created by Anup D'Souza on 13/03/24.
//

import SwiftUI

struct StoryView: View {
    @State var book: Storybook
    @State private var currentPageIndex: Int?
    private var currentPage: Int {
        currentPageIndex ?? 0
    }
    
    var body: some View {
        VStack {
            if currentPage == 0 {
                Text(book.title)
                    .font(.title)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .shadow(color: .black, radius: 2, x: 1, y: 1)
                    .padding(.horizontal, 40)
                    .offset(y: -44)
            }
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    ForEach(0..<book.story.count, id: \.self) { index in
                        GeometryReader { proxy in
                            VStack {
                                Spacer()
                                Group {
                                    Text(book.story[index])
                                    if currentPage == book.story.count - 1 {
                                        Text("Moral: " + book.moral)
                                    }
                                }
                                .font(.title3)
                                .padding()
                                .frame(width: proxy.size.width)
                                .background {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(.black.opacity(0.75))
                                }
                                .opacity(1.0 - min(abs(proxy.frame(in: .global).origin.x)/100.0, 1.0))
                            }
                        }
                        .containerRelativeFrame(.horizontal)
                    }
                }
                .scrollTargetLayout()
            }
            .padding()
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.paging)
            .scrollPosition(id: $currentPageIndex)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundStyle(.white)
        .background {
            Color.clear.overlay {
                Image(uiImage: book.images[currentPage])
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .animation(.easeIn(duration: 0.5), value: true)
            }
            .edgesIgnoringSafeArea(.all)
        }
        .toolbarRole(.editor)
    }
}
