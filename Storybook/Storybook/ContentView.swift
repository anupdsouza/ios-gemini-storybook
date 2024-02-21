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
        VStack(spacing: 0) {
            
            Group {

                HStack {
                    Spacer()
                    Image(systemName: "gearshape")
                        .font(.title)
                }
                
                HStack {
                    Text("My Stories")
                        .font(.title).bold()
                    Spacer()
                    Button("Shelves", systemImage: "books.vertical.fill") {
                        
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                    .tint(.gray)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    ForEach(images, id: \.self) { image in
                        Image(image)
                            .resizable()
                            .scaledToFill()
                            .clipShape(RoundedRectangle(cornerRadius: 25.0))
                            .padding(.horizontal, 25)
                            .containerRelativeFrame(.horizontal)
                    }
                }
                .scrollTargetLayout()
            }
            .frame(height: 350)
            .padding(.vertical)
            .scrollIndicators(.never)
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $currentItemID)
            .safeAreaPadding(.horizontal, 70)
            .safeAreaPadding(.vertical, 10)
            
            Text("Visiting Mr. Freeze")
                .font(.title).bold()
            
            Button("New Story", systemImage: "plus") {
                
            }
            .padding()
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .tint(.black)

            Spacer()
        }
    }
}

#Preview {
    ContentView()
}
