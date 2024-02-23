//
//  ContentView.swift
//  Storybook
//
//  Created by Anup D'Souza on 21/02/24.
//

import SwiftUI

struct ContentView: View {
    @State private var currentItemID: UUID?
    private let images = ["poster1","poster2","poster3","poster4","poster5","poster6"]
    
    var body: some View {
        VStack {
            
            // MARK: Top components
            Group {
                HStack {
                    Spacer()
                    Image(systemName: "gearshape")
                        .font(.title)
                        .foregroundStyle(.white)
                }
                HStack {
                    Text("My Stories")
                        .font(.title).bold()
                        .foregroundStyle(.white)
                    Spacer()
                    Button("Shelves", systemImage: "books.vertical.fill") {
                        
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                    .tint(.secondary)
                }
                .bold()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            
            // MARK: Carousal
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 0) {
                    ForEach(0..<images.count, id: \.self) { index in
                        Image(images[index])
                            .resizable()
                            .scaledToFill()
                            .frame(width: 260, height: 380)
                            .overlay {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(.white, lineWidth: 0.5)
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 20.0))
                            .id(index)
                            .containerRelativeFrame(.horizontal)
                            .scrollTransition { content, phase in
                                content
                                    .scaleEffect(phase.isIdentity ? 1 : 0.9)
                            }
                    }
                }
                .scrollTargetLayout()
            }
            .frame(height: 400)
            .contentMargins(20)
            .safeAreaPadding(.horizontal, 40)
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $currentItemID)
            
            Text("Visiting Mr. Freeze")
                .font(.title).bold()
                .foregroundStyle(.white)
            
            // MARK: Bottom components
            Group {
                HStack(spacing: 30) {
                    Button(action: {}, label: {
                        Image(systemName: "arrow.down.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40)
                    })
                    Button(action: {}, label: {
                        Image(systemName: "ellipsis.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40)
                    })
                }
                
                Button(action: {}, label: {
                    HStack(spacing: 10) {
                        Image(systemName: "plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15)
                        Text("New Story")
                    }
                    .bold()
                    .padding(5)
                    .foregroundStyle(.black)
                })
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .padding()
            }
            .tint(.white)

            Spacer()
        }
        .background {
            Color.black
                .edgesIgnoringSafeArea(.all)
        }
    }
}

#Preview {
    ContentView()
}
