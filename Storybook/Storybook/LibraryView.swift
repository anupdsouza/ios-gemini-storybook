//
//  LibraryView.swift
//  Storybook
//
//  Created by Anup D'Souza on 21/02/24.
//

import SwiftUI

struct LibraryView: View {
    @State private var showPromptAlert = false
    @State private var promptText = ""
    @State private var library = Library()    
    
    var body: some View {
        NavigationStack {
            VStack {
                if library.books.isEmpty {
                    emptyLibraryView()
                } else {
                    // MARK: Top components
                    headerView()
                    
                    // MARK: Carousal
                    storybooksView()
                    
                    // MARK: Bottom components
                    footerView()
                    
                    Spacer()
                }
            }
            .background {
                Color.black
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .tint(.white)
    }
    
    @ViewBuilder private func emptyLibraryView() -> some View {
        ContentUnavailableView(label: {
            Label("No Stories", systemImage: "doc.richtext")
        }, description: {
            Text("Click the button below to create one!")
        }, actions: {
            newStoryButtonView()
        })
        .foregroundStyle(.white)
        .tint(.white)
    }

    @ViewBuilder private func headerView() -> some View {
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
    }
    
    @ViewBuilder private func footerView() -> some View {
        Group {
            HStack(spacing: 20) {
                Group {
                    Button(action: {}, label: {
                        footerButtonView("arrow.down")
                    })
                    
                    Button(action: {}, label: {
                        footerButtonView("ellipsis")
                    })
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.circle)
                .tint(.secondary)
                .foregroundStyle(.white)
            }
            
            newStoryButtonView()
        }
        .tint(.white)
    }
    
    @ViewBuilder private func footerButtonView(_ imageName: String) -> some View {
        Image(systemName: imageName)
            .resizable()
            .scaledToFit()
            .frame(width: 20, height: 20)
            .padding(4)
    }
    
    @ViewBuilder private func storybooksView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 0) {
                
                ForEach(0..<library.books.count, id: \.self) { index in
                    let storybook = library.books[index]
                    NavigationLink(destination: StoryView(book: storybook)) {
                        BookView(book: storybook)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .scrollTargetLayout()
        }
        .frame(height: 450)
        .contentMargins(20)
        .safeAreaPadding(.horizontal, 40)
        .scrollTargetBehavior(.viewAligned)
    }
    
    @ViewBuilder private func newStoryButtonView() -> some View {
        Button(action: {
            showPromptAlert = true
        }, label: {
            Group {
                HStack(spacing: 15) {
                    if library.fetchingStory {
                        Text("Please wait...")
                        ProgressView()
                            .tint(.black)
                    } else {
                        Image(systemName: "plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15)
                        Text("New Story")
                    }
                }
            }
            .bold()
            .padding(5)
            .foregroundStyle(.black)
        })
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.capsule)
        .padding()
        .alert("Enter a prompt for the story", isPresented: $showPromptAlert) {
            TextField("Prompt", text: $promptText)
                .foregroundStyle(.black)
            
            Button("Submit", action: {
                print(promptText)
                showPromptAlert = false
                Task {
                    await library.fetchStory(promptText)
                }
            })
            Button("Cancel", role: .cancel, action: { promptText = "" })
        } message: {
            Text("Include as much detail as possible")
        }
        .alert("Error creating story, please try again later.", isPresented: $library.errorFetchingStory) {
            Button("Ok", role: .cancel, action: {})
        }
    }
}

#Preview {
    LibraryView()
}
