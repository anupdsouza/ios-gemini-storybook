//
//  Library.swift
//  Storybook
//
//  Created by Anup D'Souza on 23/02/24.
//

import Foundation
import SwiftUI
import GoogleGenerativeAI

@Observable class Library {
    private(set) var books = [Storybook]()
    private var fetchingStory = false
    private var fetchedStory = false
    private let model = GenerativeModel(name: "gemini-pro", apiKey: APIKey.default)
    
    func fetchStory(_ promptText: String) async {
        fetchingStory = true
        fetchedStory = false
        
        do {
            let prompt = """
            I want you to create a children's story with the following prompt: \(promptText)
            # Specific Instructions:
            1. The story should be appropriate for the age group 5-10 years old.
            2. The story should be composed of short sentences without difficult words.
            3. Look for character names in the prompt if any & make them central to the story. If not, provide simple character names.
            4. The progression of the story should be consistent with a clear start, middle & end with a satisfying conclusion.
            5. Consider using rhyme & repitition in the story.
            6. Incorporate vivid imagery or environment.
            7. Analyse the story & provide a moral at the end.
            8. The story should be exactly 8 sentences long. Provide a title as well as a moral.
            9. Provide the story as JSON that can be decoded into the sample swift model provided below.
            10. Do not use markdown in the response.
            # Sample Swift Model:
            struct Story {
                var title: String
                var moral: String
                var story: [String]
            }
          """
            let response = try await model.generateContent(prompt)
            guard let text = response.text?.replacingOccurrences(of: "```", with: "").replacingOccurrences(of: "json", with: ""),
                  let data = text.data(using: .utf8) else {
                fetchingStory = false
                return
            }
            print(text)
            
            let story = try JSONDecoder().decode(Story.self, from: data)
            let storyBook = Storybook(title: story.title, moral: story.moral, story: story.story)
            books.append(storyBook)
            
            await MainActor.run {
                withAnimation {
                    fetchedStory = true
                }
            }
        }
        catch {
            fetchingStory = false
            print(error.localizedDescription)
        }
    }
}

