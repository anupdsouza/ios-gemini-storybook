//
//  Library.swift
//  Storybook
//
//  Created by Anup D'Souza on 23/02/24.
//

import Foundation
import SwiftUI
import GoogleGenerativeAI
import OpenAIKit

@Observable class Library {
    private(set) var books = [Storybook]()
    private var fetchingStory = false
    private var fetchedStory = false
    private let geminiModel = GenerativeModel(name: "gemini-pro", apiKey: APIKey.gemini)
    private let openAi = OpenAI(Configuration(organizationId: APIKey.openAIOrgId, apiKey: APIKey.openAIKey))
    private(set) var fetchedImages: [UIImage]? = []

    func fetchStory(_ promptText: String) async {
        fetchingStory = true
        fetchedStory = false
        
        do {
            let prompt = """
            I want you to create a children's story with the following prompt: \(promptText)
            # Specific Instructions:
            1. The story should be appropriate for the age group 5-10 years old.
            2. The story should be composed of short sentences with words that are easy to pronounce.
            3. Look for character names in the input prompt & if they exist, make them central to the story. If not, provide simple character names.
            4. The progression of the story should be consistent with a clear start, middle & end with a satisfying conclusion.
            5. Consider using rhyme & repitition in the story & incorporate vivid imagery for the story environment.
            7. The story should be EXACTLY 8 sentences long. Provide a title as well as a moral.
            8. Once you create the entire story, combining 2 story sentences at a time; create a total of 4 one line prompts for generating images of the story.
            9. Consider the entire story when creating image prompts.
           10. Always include character information in the prompt. For example, if the character is a human, animal etc.
           11. The prompts should be self contained but also conveying the context with respect to the complete story.
           12. DO NOT use markdown in the response & provide the details in the form of the following JSON structure:

            {
                var title: String
                var moral: String
                var story: [String]
                var imagePrompts: [String]
            }
          """

            let response = try await geminiModel.generateContent(prompt)
            print(response.text ?? "")
            guard let text = response.text?.replacingOccurrences(of: "```", with: "").replacingOccurrences(of: "json", with: ""),
                  let data = text.data(using: .utf8) else {
                fetchingStory = false
                return
            }
            print(response.text ?? "")
            
            let story = try JSONDecoder().decode(Story.self, from: data)
            var storyBook = Storybook(title: story.title, moral: story.moral, story: story.story)
            
            do {
                let images = try await generateImages(for: story.imagePrompts, story: story.story.joined(separator: " "))
                storyBook.images.append(contentsOf: images)
                books.append(storyBook)
                fetchedImages?.append(contentsOf: images)
            } catch {
                print("Error generating images: \(error)")
            }

            print("the story: \(story.story.joined())")
            
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
    
    func generateImages(for pairs: [String], story: String) async throws -> [UIImage] {
        
        return try await withThrowingTaskGroup(of: (Int, UIImage).self) { group in
            var generatedImages = [UIImage?](repeating: nil, count: pairs.count)
            
            for (index, pair) in pairs.enumerated() {
                group.addTask {
                    
                    do {
                        let prompt = """
                        Given the following story for context enclosed between the $ symbol: $\(story)$,
                        generate a children's story book style image with the following prompt: \(pair)"
                        """
                        let imageParam = ImageParameters(
                            prompt: prompt,
                            resolution: .large,
                            model: ImageModel.dalle3,
                            responseFormat: .base64Json
                        )
                        let result = try await self.openAi.createImage(parameters: imageParam)
                        let b64Image = result.data[0].image
                        let image = try self.openAi.decodeBase64Image(b64Image)
                        return (index, image)
                    } catch {
                        throw NSError(domain: "Image Generation", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to create image"])
                    }
                }
            }
            
            for try await (index, image) in group {
                generatedImages[index] = image
            }
            
            return generatedImages.compactMap { $0 }
        }
    }
}

